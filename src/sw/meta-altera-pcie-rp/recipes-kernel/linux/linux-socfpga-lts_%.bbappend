
SUMMARY = "Intel SoCFPGA Development Kit Linux Kernel layer for PCIe Root Port Example Designs"
DESCRIPTION = "Linux Kernel addons for PCIe Root Port Example Designs on Intel SoCFPGA Development Kits"
SECTION = "kernel"

LICENSE = "MIT & GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-socfpga-lts:"

SRC_URI:append:agilex5_dk_a5e065bb32aes1 = " \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://nvme.scc", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://fit_kernel_agilex5_dk_a5e065bb32aes1_rped.its", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0001-dt-bindings-PCI-altera-add-binding-for-Agilex-5.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0002-arm64-dts-agilex5-add-dtsi-for-PCIe-Root-Port.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0003-arm64-dts-agilex5-add-dts-enabling-PCIe-Root-Port.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0004-PCI-altera-add-Agilex-5-support.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0005-PCI-altera-add-register-regmap-for-debugfs.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0006-PCI-altera-enable-all-performance-counters.patch", "", d)} \
	${@bb.utils.contains("IMAGE_TYPE", "rped", "file://0007-PCI-altera-set-maximum-supported-TLP-data-payload-si.patch", "", d)} \
	"

# TODO Once Agilex 5 support has been merged into linux-socfpga main branch,
# remove the temporary override below to use latest commit from ${KBRANCH}.
SRCREV = "${AUTOREV}"
KERNEL_VERSION_SANITY_SKIP = "1"

do_deploy:append() {
	# RPED: start linux-socfpga MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}

	# linux.dtb
	cp ${DTBDEPLOYDIR}/socfpga_agilex5_socdk.dtb ${B}
	cp ${DTBDEPLOYDIR}/socfpga_agilex5_vanilla.dtb ${B}

	# core.rbf
	cp ${DEPLOY_DIR_IMAGE}/${MACHINE}_${IMAGE_TYPE}_ghrd/ghrd.core.rbf ${B}

	cp ${WORKDIR}/sources-unpack/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${B}

	# Image
	cp ${LINUXDEPLOYDIR}/Image ${B}
	# Compress Image to lzma format
	xz --format=lzma --force ${B}/Image
	# Generate kernel.itb
	mkimage -f ${B}/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${B}/kernel.itb
	# Deploy kernel.its, kernel.itb and Image.lzma
	install -m 744 ${B}/fit_kernel_${MACHINE}_${IMAGE_TYPE}.its ${DEPLOYDIR}
	install -m 744 ${B}/kernel.itb ${DEPLOYDIR}
	install -m 744 ${B}/Image.lzma ${DEPLOYDIR}
	# RPED: end linux-socfpga MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}
	exit 0
}
