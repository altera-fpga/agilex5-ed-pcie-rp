# meta-custom

This BitBake layer contains design-specific metadata for this PCIe Root Port System Example Design:
device trees, kernel/U-Boot customizations, FPGA bitstream integration, and application recipes.

Hardware for this design lives under `mk-a5e065bb32aea/pcie-rp/` (`src/`, `syn/g4x4/`).
This layer is the Yocto customization side under `software/yocto_linux/meta-custom/`.
It replaces the GSRD 1.0 `meta-altera-pcie-rp` layer.

## Layer layout

```text
meta-custom/
├── conf/
│   ├── layer.conf                   # IMAGE_INSTALL (nvme-cli, dtc, fio, pciutils, ...)
│   └── pcie-rp-solution.inc         # PCIE_RP_DESIGN → RBF / DTB / SOLUTION
├── classes/
├── recipes-bsp/u-boot/              # U-Boot env / appends
├── recipes-files/
│   ├── rootfs-files/
│   ├── test-suite-agilex5/
│   └── uboot-test-suite-agilex5/
├── recipes-fpga/fpga-bitstream/     # core.rbf integration
└── recipes-kernel/
    ├── linux/
    │   ├── device-tree/             # socfpga_agilex5_pcie_root_port_modular.dts
    │   └── linux-socfpga-lts/       # configs/ (NVMe), patches/ (PCIe RP driver), FIT .its
    └── perf/
```

## U-Boot
U-Boot customizations for this design are under `recipes-bsp/u-boot/`
(for example `u-boot-socfpga-env-var.bbappend`, which sets `bootfile=kernel.itb`).
Machine/boot settings are also driven from `kas/machine.yml` and `kas.yml`
(see the parent [../README.md](../README.md)).

## Linux Kernel
For detailed instructions and customization guidance, refer to:
`recipes-kernel/linux/README.md`

- Device Tree — `recipes-kernel/linux/device-tree/socfpga_agilex5_pcie_root_port_modular.dts`,
  selected by `PCIE_RP_DESIGN` / `pcie-rp-solution.inc`
- Configuration fragments — `recipes-kernel/linux/linux-socfpga-lts/configs/` (`nvme.scc`)
- Source patching — `recipes-kernel/linux/linux-socfpga-lts/patches/` (Agilex 5 PCIe Root Port driver)
- FIT image — `recipes-kernel/linux/linux-socfpga-lts/fit_agilex5_kernel*_pcie_rp.its`

## FPGA Bitstream
For details on FPGA bitstream handling, refer to:
`recipes-fpga/fpga-bitstream/README.md`

- Place the design `.core.rbf` under `recipes-fpga/fpga-bitstream/files/`
- Filename comes from `PCIE_RP_DESIGN` → `FPGA_RBF_FILE` in `conf/pcie-rp-solution.inc`
  (default `PCIE_RP_G4X4` → `baseline_a55.core.rbf`)
- Top-level Make / `kas_build.sh` copies the HW-generated core RBF there automatically

## Other recipes in this layer
- **recipes-files** — rootfs README and test suites
  (see `recipes-files/rootfs-files/README.md`)
