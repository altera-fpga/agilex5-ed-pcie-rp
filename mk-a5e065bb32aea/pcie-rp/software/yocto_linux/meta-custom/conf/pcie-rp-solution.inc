# Map PCIE_RP_DESIGN -> RBF / DTB / SOLUTION
# Usage: PCIE_RP_DESIGN=PCIE_RP_G4X4 kas shell kas.yml -c "bitbake console-image-minimal"
# FPGA_RBF_FILE must match the first REVISION_NAMES entry in ../../project_config.mk
# because kas_build.sh stages the core RBF as ${REVISION_NAME}.core.rbf.
PCIE_RP_DESIGN ??= "PCIE_RP_G4X4"
python () {
    design = (d.getVar("PCIE_RP_DESIGN") or "PCIE_RP_G4X4").strip().upper()
    rbf_map = {
        "PCIE_RP_G4X4": "baseline_a55.core.rbf",
    }
    dtb_map = {
        "PCIE_RP_G4X4": "socfpga_agilex5_pcie_root_port_modular.dtb",
    }
    sol_map = {
        "PCIE_RP_G4X4": "PCIE_RP_G4X4",
    }
    if design not in rbf_map:
        bb.fatal("Unsupported PCIE_RP_DESIGN='%s'. Valid: %s" %
                 (design, " ".join(sorted(rbf_map))))
    d.setVar("PCIE_RP_DESIGN", design)
    d.setVar("FPGA_RBF_FILE", rbf_map[design])
    d.setVar("FPGA_LINUX_DTB_FILE", dtb_map[design])
    d.setVar("SOLUTION", sol_map[design])
    # Do NOT set CUSTOM_LINUX_DEVICE_TREE here; kas.yml keeps it as "1"
}
