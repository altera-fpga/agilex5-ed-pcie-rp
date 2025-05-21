SUMMARY = "Layer to manage FPGA images for PCIe Root Port Example Designs"
DESCRIPTION = "Layer to manage FPGA images for PCIe Root Port Example Designs on Intel SoCFPGA Development Kits"
SECTION = "bsp"

LICENSE = "MIT & GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:agilex5_dk_a5e065bb32aes1 = "\
		${@bb.utils.contains("IMAGE_TYPE", "rped", "file://agilex5_dk_a5e065bb32aes1_rped_${ARM64_GHRD_CORE_RBF}", "", d)} \
		"

SRC_URI[agilex5_dk_a5e065bb32aes1_rped_core.sha256sum] = "ecde39c8c3b68dfc90990ce20aa0d5ec97d595924ed3a8b42929e5aa88aeede7"

do_install() {
	# RPED: start hw-ref-design:do_install MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}
	
	install -D -m 0644 ${WORKDIR}/sources/${MACHINE}_${IMAGE_TYPE}_${ARM64_GHRD_CORE_RBF} ${DEPLOYDIR}/${MACHINE}_${IMAGE}_ghrd/${ARM64_GHRD_CORE_RBF}

	# RPED: end hw-ref-design:do_install MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}
}

do_deploy() {
	# RPED: start hw-ref-design:do_deploy MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}

	install -D -m 0644 ${WORKDIR}/sources/${MACHINE}_${IMAGE_TYPE}_${ARM64_GHRD_CORE_RBF} ${DEPLOYDIR}/${MACHINE}_${IMAGE_TYPE}_ghrd/${ARM64_GHRD_CORE_RBF}

	# RPED: end hw-ref-design:do_deploy MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}
}
