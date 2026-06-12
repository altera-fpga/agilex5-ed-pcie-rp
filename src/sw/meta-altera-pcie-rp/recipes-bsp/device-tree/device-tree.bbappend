SUMMARY = "Intel SoCFPGA Development Kit devicetrees for PCIe Root Port Example Designs"
DESCRIPTION = "Devicetree addons for PCIe Root Port Example Designs on Intel SoCFPGA Development Kits"
SECTION = "bsp"

LICENSE = "MIT & GPL-2.0-only"

do_configure:append() {
	# RPED: device-tree MACHINE is ${MACHINE} and IMAGE_TYPE is ${IMAGE_TYPE}

	cp ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts/intel/socfpga_agilex5_pcie_root_port.dts ${WORKDIR}/
	if [[ "${MACHINE}" == "agilex5_mk_a5e065bb32aes1" ]]; then
		sed -i 's/\#include \"socfpga_agilex5_socdk.dts\"/\#include \"socfpga_agilex5_vanilla_modular.dts\"/' ${WORKDIR}/socfpga_agilex5_pcie_root_port.dts
	fi
}
