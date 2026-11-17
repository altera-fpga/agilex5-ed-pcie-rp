KERNEL_REPO = "git://github.com/altera-fpga/linux-socfpga.git"
LINUX_VERSION = "6.18.37"
KBRANCH = "socfpga-6.18.37-lts"
KERNEL_VERSION_SANITY_SKIP = "1"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

# Append GSRD specific kernel config fragments and Patches.
FILESEXTRAPATHS:prepend := "${THISDIR}/device-tree:${THISDIR}/linux-socfpga-lts:${THISDIR}/linux-socfpga-lts/configs:${THISDIR}/linux-socfpga-lts/patches:"

# PCIe Root Port DTB built from kernel sources plus device-tree/*.dts.
# FPGA_LINUX_DTB_FILE comes from meta-custom/conf/pcie-rp-solution.inc via PCIE_RP_DESIGN.
KERNEL_DEVICETREE:append = " intel/${FPGA_LINUX_DTB_FILE}"

IMAGE_BOOT_FILES:append = " ${FPGA_LINUX_DTB_FILE}"

# Agilex 5 PCIe Root Port support is not on socfpga-6.18.37-lts yet.
SRC_URI:append = " \
	file://nvme.scc \
	file://fit_agilex5_kernel_pcie_rp.its \
	file://fit_agilex5_kernel_no_rbf_pcie_rp.its \
	file://0001-dt-bindings-PCI-altera-Add-binding-for-Agilex-5.patch \
	file://0002-arm64-dts-agilex5-Add-dtsi-for-PCIe-Root-Port.patch \
	file://0003-arm64-dts-agilex5-Add-dts-enabling-PCIe-Root-Port.patch \
	file://0004-PCI-altera-Do-not-dispose-parent-IRQ-mapping.patch \
	file://0005-PCI-altera-Fix-resource-leaks-on-probe-failure.patch \
	file://0006-PCI-altera-Add-Agilex-5-support.patch \
	file://0007-PCI-altera-Add-register-regmap-for-debugfs.patch \
	file://0008-PCI-altera-Enable-PCIe-performance-monitor.patch \
	file://0009-PCI-Configure-Root-Port-MPS-during-host-probing.patch \
	file://0010-arm64-dts-intel-agilex5-Add-reserved-memory-for-PCIe.patch \
	file://0011-PCI-altera-Add-Agilex5-Root-Port-legacy-INTx-support.patch \
	file://0012-Move-msi-irq-affinity-to-A76.patch \
	file://0013-PCI-altera-Limit-MRRS-to-512-bytes-on-MCDMA-Root-Por.patch \
	"

# Board DTS files under device-tree/ (socfpga_agilex5_pcie_root_port_modular.dts).
python __anonymous () {
    import os

    layerdir = d.getVar("LAYERDIR_meta_custom")
    tree = os.path.join(layerdir, "recipes-kernel/linux/device-tree")
    if not os.path.isdir(tree):
        return

    for fname in os.listdir(tree):
        if fname.endswith(".dts") or fname.endswith(".dtsi"):
            d.appendVar("SRC_URI", " file://%s" % fname)
}

do_patch:append() {
    DTS_SRC_DIR="${WORKDIR}/sources"
    DTS_DST_DIR="${S}/arch/arm64/boot/dts/intel"
    MAKEFILE="${DTS_DST_DIR}/Makefile"
    # BitBake does not expand ${VAR%.dtb}; assign then use shell suffix removal
    dtb_file="${FPGA_LINUX_DTB_FILE}"
    dts_name="${dtb_file%.dtb}.dts"

    if [ -z "${dtb_file}" ]; then
        bbfatal "FPGA_LINUX_DTB_FILE is empty (check PCIE_RP_DESIGN / pcie-rp-solution.inc)"
    fi

    if [ -f "${DTS_SRC_DIR}/${dts_name}" ]; then
        install -m 0644 "${DTS_SRC_DIR}/${dts_name}" "${DTS_DST_DIR}"
        bbnote "Installed ${dts_name} from device-tree/"
    elif [ -f "${DTS_DST_DIR}/${dts_name}" ]; then
        bbnote "Using in-kernel DTS: ${DTS_DST_DIR}/${dts_name}"
    else
        bbfatal "DTS ${dts_name} not in kernel (${DTS_DST_DIR}) or device-tree/ (check PCIE_RP_DESIGN / pcie-rp-solution.inc)"
    fi

    if [ -d "${DTS_SRC_DIR}" ]; then
        find "${DTS_SRC_DIR}" -maxdepth 1 -type f -name "*.dtsi" | while read DTSI; do
            install -m 0644 "${DTSI}" "${DTS_DST_DIR}/$(basename "${DTSI}")"
        done
    fi

    if ! grep -Fq "${dtb_file}" "${MAKEFILE}"; then
        echo "dtb-\$(CONFIG_ARCH_INTEL_SOCFPGA) += ${dtb_file}" >> "${MAKEFILE}"
    fi

    # kgit-s2q commits the patch series; commit these files too, otherwise
    # scripts/setlocalversion sees a modified tree and appends "-dirty".
    if [ -d "${S}/.git" ]; then
        git -C "${S}" add -A "${DTS_DST_DIR}"
        git -C "${S}" -c user.name="OpenEmbedded" -c user.email="oe@localhost" \
            commit -q -m "arm64: dts: intel: install PCIe Root Port device tree" || true
    fi
}

addtask do_patch after do_unpack before do_configure

do_compile:append() {
	if [ -n "${FPGA_LINUX_DTB_FILE}" ]; then
		dtb_rel="intel/${FPGA_LINUX_DTB_FILE}"
		bbnote "Building PCIe Root Port DTB from kernel: ${dtb_rel}"
		oe_runmake ${dtb_rel} || oe_runmake dtbs
	fi
}

do_deploy:prepend() {
	if [ -z "${FPGA_LINUX_DTB_FILE}" ]; then
		bbfatal "FPGA_LINUX_DTB_FILE is empty (check PCIE_RP_DESIGN / pcie-rp-solution.inc)"
	fi

	dtb_name="${FPGA_LINUX_DTB_FILE}"
	dtb_src=""

	for cand in \
		"${B}/arch/${ARCH}/boot/dts/intel/${dtb_name}" \
		"${B}/arch/${ARCH}/boot/dts/${dtb_name}" \
		"${D}${nonarch_base_libdir}/firmware/${dtb_name}" \
		"${D}/boot/${dtb_name}"; do
		if [ -f "${cand}" ]; then
			dtb_src="${cand}"
			break
		fi
	done

	if [ -z "${dtb_src}" ]; then
		bbfatal "Cannot find kernel-built DTB ${dtb_name} under ${B}/arch/${ARCH}/boot/dts"
	fi

	if [ -n "${DEPLOYDIR}" ]; then
		install -d "${DEPLOYDIR}"
		install -m 0644 "${dtb_src}" "${DEPLOYDIR}/${dtb_name}"
	fi
	if [ -n "${LINUXDEPLOYDIR}" ]; then
		install -d "${LINUXDEPLOYDIR}"
		install -m 0644 "${dtb_src}" "${LINUXDEPLOYDIR}/${dtb_name}"
	fi
	bbnote "Staged PCIe Root Port DTB: ${dtb_src} -> deploy/${dtb_name}"

	# meta-altera-bsp builds kernel.itb from ${UNPACKDIR}/fit_${MACHINE_STRIP}_kernel*.its;
	# replace those with the PCIe Root Port versions that add board-2 / board-4.
	cp -f "${UNPACKDIR}/fit_${MACHINE_STRIP}_kernel_pcie_rp.its" "${UNPACKDIR}/fit_${MACHINE_STRIP}_kernel.its"
	cp -f "${UNPACKDIR}/fit_${MACHINE_STRIP}_kernel_no_rbf_pcie_rp.its" "${UNPACKDIR}/fit_${MACHINE_STRIP}_kernel_no_rbf.its"
}

do_deploy:append() {
        if [ ! -f "${DEPLOYDIR}/kernel.itb" ]; then
                bbfatal "kernel.itb not found in ${DEPLOYDIR}"
        fi
        if [ ! -f "${B}/.config" ]; then
                bbfatal "kernel .config not found at ${B}/.config"
        fi
}
