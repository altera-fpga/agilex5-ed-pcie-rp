
SUMMARY = "Intel SoCFPGA Development Kit Linux Kernel layer for PCIe Root Port Example Designs"
DESCRIPTION = "Linux Kernel addons for PCIe Root Port Example Designs on Intel SoCFPGA Development Kits"
SECTION = "kernel"

LICENSE = "MIT & GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-socfpga-lts:"

SRC_URI:append:agilex5_mk_a5e065bb32aes1 = " \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://nvme.scc", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://fit_kernel_agilex5_mk_a5e065bb32aes1_rped.its", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0001-dt-bindings-PCI-altera-Add-binding-for-Agilex-5.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0002-arm64-dts-agilex5-Add-dtsi-for-PCIe-Root-Port.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0003-arm64-dts-agilex5-Add-dts-enabling-PCIe-Root-Port.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0004-PCI-altera-Do-not-dispose-parent-IRQ-mapping.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0005-PCI-altera-Fix-resource-leaks-on-probe-failure.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0006-PCI-altera-Add-Agilex-5-support.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0007-PCI-altera-Add-register-regmap-for-debugfs.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0008-PCI-altera-Enable-PCIe-performance-monitor.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0009-v6-1-2-PCI-Configure-Root-Port-MPS-during-host-probing.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0010-arm64-dts-intel-agilex5-Add-reserved-memory-for-PCIe.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0011-PCI-altera-Add-Agilex5-Root-Port-legacy-INTx-support.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0012-Move-msi-irq-affinity-to-A76.patch", "", d)} \
	"

SRCREV = "${AUTOREV}"
KERNEL_VERSION_SANITY_SKIP = "1"

do_deploy:append() {
	# RPED: start linux-socfpga MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}

	# linux.dtb
	cp ${DTBDEPLOYDIR}/socfpga_agilex5_pcie_root_port.dtb ${B}

	# core.rbf
	cp ${DEPLOY_DIR_IMAGE}/${MACHINE}_${IMAGE_TYPE}_ghrd/ghrd.core.rbf ${B}

	cp ${WORKDIR}/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${B}

	# Image
	cp ${LINUXDEPLOYDIR}/Image ${B}
	# Compress Image to lzma format
	if [ -e ${B}/Image.lzma ]; then
		rm ${B}/Image.lzma
	fi
	xz --format=lzma -f ${B}/Image
	# Generate kernel.itb
	mkimage -f ${B}/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${B}/kernel.itb
	# Deploy kernel.its, kernel.itb and Image.lzma
	install -m 744 ${B}/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${DEPLOYDIR}
	install -m 744 ${B}/kernel.itb ${DEPLOYDIR}
	install -m 744 ${B}/Image.lzma ${DEPLOYDIR}
	# RPED: end linux-socfpga MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}
	exit 0
}
