# Linux Kernel device-tree (Agilex™ 5 PCIe Root Port)

## Files in this folder

| File | Purpose |
|------|---------|
| `socfpga_agilex5_pcie_root_port_modular.dts` | Modular Development Kit board DTS + PCIe Root Port |

The DTS includes two files from the patched kernel tree (`arch/arm64/boot/dts/intel/`):

- `socfpga_agilex5_socdk_modular.dts` — MDK board (in `socfpga-6.18.37-lts`)
- `socfpga_agilex5_pcie_root_port.dtsi` — PCIe Root Port nodes
  (from `0002-arm64-dts-agilex5-add-dtsi-for-PCIe-Root-Port.patch`)

and enables `pcie_0_pcie_aglx` and `pcie_0_msi_irq`.

The kernel bbappend copies every `.dts` / `.dtsi` here into `arch/arm64/boot/dts/intel/`,
adds the DTB to the kernel Makefile, builds it and stages it in the deploy directory.

`PCIE_RP_DESIGN` → DTB name is selected by `meta-custom/conf/pcie-rp-solution.inc` (`FPGA_LINUX_DTB_FILE`):

| `PCIE_RP_DESIGN` | DTB |
|------------------|-----|
| `PCIE_RP_G4X4` | `socfpga_agilex5_pcie_root_port_modular.dtb` |

`kas/machine.yml` keeps the GSRD base board DTS for the vanilla FIT configuration (`board-1`):

```text
LINUX_DTS_FILE = "socfpga_agilex5_socdk.dts"
#CUSTOM_LINUX_DTS_FILE = "socfpga_agilex5_pcie_root_port_modular.dts"
```

Output:

```text
build/tmp/deploy/images/agilex5e/socfpga_agilex5_pcie_root_port_modular.dtb
```

The GSRD 1.0 `device-tree.bbappend` (which overwrote `socfpga_agilex5_socdk.dts`) is no longer used.
