SUMMARY = "Layer to manage FPGA images for PCIe Root Port Example Designs"
DESCRIPTION = "Layer to manage FPGA images for PCIe Root Port Example Designs on Intel SoCFPGA Development Kits"
SECTION = "bsp"

LICENSE = "MIT & GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

ARM64_GHRD_HPS_RBF = "ghrd.hps.rbf"

SRC_URI:agilex5_mk_a5e065bb32aes1 = "\
		${@bb.utils.contains("IMAGE_TYPE", "rped", "file://agilex5_mk_a5e065bb32aes1_rped_${ARM64_GHRD_CORE_RBF}", "", d)} \
		${@bb.utils.contains("IMAGE_TYPE", "rped", "file://agilex5_mk_a5e065bb32aes1_rped_${ARM64_GHRD_HPS_RBF}", "", d)} \
		"

SRC_URI[agilex5_mk_a5e065bb32aes1_rped_core.sha256sum] = "c9145f5b6399f286ed40334d12e8590aa0768d03574f8adfb9dd7530e9de01b3"
SRC_URI[agilex5_mk_a5e065bb32aes1_rped_hps.sha256sum] = "c769d51fb56ca33a2df9cb0da8dcc3aae851aeeda8f4fa6530498b5bb14060c9"

do_install() {
	# RPED: start hw-ref-design:do_install MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}
	
	install -D -m 0644 ${WORKDIR}/${MACHINE}_${IMAGE_TYPE}_${ARM64_GHRD_CORE_RBF} ${D}/boot/${ARM64_GHRD_CORE_RBF}
	install -D -m 0644 ${WORKDIR}/${MACHINE}_${IMAGE_TYPE}_${ARM64_GHRD_HPS_RBF} ${D}/boot/${ARM64_GHRD_HPS_RBF}

	# RPED: end hw-ref-design:do_install MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}
}

do_deploy() {
	# RPED: start hw-ref-design:do_deploy MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}

	install -D -m 0644 ${WORKDIR}/${MACHINE}_${IMAGE_TYPE}_${ARM64_GHRD_CORE_RBF} ${DEPLOYDIR}/${MACHINE}_${IMAGE_TYPE}_ghrd/${ARM64_GHRD_CORE_RBF}
	install -D -m 0644 ${WORKDIR}/${MACHINE}_${IMAGE_TYPE}_${ARM64_GHRD_HPS_RBF} ${DEPLOYDIR}/${MACHINE}_${IMAGE_TYPE}_ghrd/${ARM64_GHRD_HPS_RBF}

	# RPED: end hw-ref-design:do_deploy MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}
}
