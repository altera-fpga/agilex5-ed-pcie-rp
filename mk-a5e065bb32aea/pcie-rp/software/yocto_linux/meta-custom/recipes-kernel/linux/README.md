# Linux Kernel - linux-socfpga-lts

## Kernel source
`linux-socfpga-lts_%.bbappend` builds `socfpga-6.18.37-lts` from
`altera-fpga/linux-socfpga` (`KBRANCH`, `SRCREV = ${AUTOREV}`).
That branch does not yet contain Agilex 5 PCIe Root Port support, so the GSRD 1.0 patch
series is applied on top (refreshed for 6.18.37):

| Patch | Purpose |
|-------|---------|
| `0001-dt-bindings-PCI-altera-Add-binding-for-Agilex-5.patch` | DT binding |
| `0002-arm64-dts-agilex5-Add-dtsi-for-PCIe-Root-Port.patch` | `socfpga_agilex5_pcie_root_port.dtsi` |
| `0003-arm64-dts-agilex5-Add-dts-enabling-PCIe-Root-Port.patch` | `socfpga_agilex5_pcie_root_port.dts` (premium devkit) |
| `0004-PCI-altera-Do-not-dispose-parent-IRQ-mapping.patch` | Upstream backport (`Cc: stable`): do not dispose the parent IRQ mapping on teardown |
| `0005-PCI-altera-Fix-resource-leaks-on-probe-failure.patch` | Upstream backport (`Cc: stable`): chained handler / INTx domain leak on probe failure |
| `0006-PCI-altera-Add-Agilex-5-support.patch` | Driver support |
| `0007-PCI-altera-Add-register-regmap-for-debugfs.patch` | debugfs regmap |
| `0008-PCI-altera-Enable-PCIe-performance-monitor.patch` | Performance counters |
| `0009-PCI-Configure-Root-Port-MPS-during-host-probing.patch` | Configure Root Port MPS during host probing |
| `0010-arm64-dts-intel-agilex5-Add-reserved-memory-for-PCIe.patch` | Reserved memory for the HW design |
| `0011-PCI-altera-Add-Agilex5-Root-Port-legacy-INTx-support.patch` | Agilex 5 Root Port legacy INTx (INTA-D + CFG_AER) |
| `0012-Move-msi-irq-affinity-to-A76.patch` | Pin MSI IRQ affinity to the A76 cores |

## Device tree
Refer and follow the steps in:

```text
meta-custom/recipes-kernel/linux/device-tree/README.md
```

## FIT image (`kernel.itb`)
`do_deploy:prepend` replaces the meta-altera-bsp FIT templates with
`fit_agilex5_kernel_pcie_rp.its` / `fit_agilex5_kernel_no_rbf_pcie_rp.its`, which add the
GSRD 1.0 `board-2` (PCIe DTB, no core RBF) and `board-4` (PCIe DTB + core RBF) configurations.

## Configuration fragments
This design adds `linux-socfpga-lts/configs/config_nvme.cfg` (via `nvme.scc`): NVMe core/block
driver, NVMe multipath and a 256 MB CMA pool.

Follow the below steps to create and add configuration fragments for Linux Kernel.

### Set bitbake build environment
```bash
$ kas shell kas.yml
```

### Create Linux Kernel configuration fragment
- Launch Linux configuration menu and edit configurations and Save & Exit.
```bash
$ bitbake -c menuconfig linux-socfpga-lts
```
- Generate kernel configuration fragment file.
```bash
$ bitbake -c diffconfig linux-socfpga-lts
# Note - This command generates the fragment.cfg file.
```

### Add configuration fragment for linux-socfpga-lts Kernel
- Copy `fragment.cfg` to `linux-socfpga-lts/configs/`
- Create `fragment.scc` at the same location with a line such as:
  `kconf non-hardware fragment.cfg`
  (kconf option depends on the fragment contents; see Yocto documentation.)
- Append to `SRC_URI` in `linux-socfpga-lts_%.bbappend`:
```bitbake
file://fragment.scc
```

### Build Linux kernel
```bash
$ bitbake -c clean linux-socfpga-lts
$ bitbake -c build linux-socfpga-lts
```

## Linux Kernel patching
Follow below steps to create the patch & build Linux Kernel.

### Clone Linux Kernel repo
```bash
$ git clone https://github.com/altera-fpga/linux-socfpga.git
$ cd linux-socfpga
$ git checkout socfpga-6.18.37-lts
$ git am <path to>/linux-socfpga-lts/patches/*.patch
```

Do your source code changes.

### Generate the source patch
```bash
$ git add <changed files>
$ git commit -m "Add my custom feature"  # include Upstream-Status: per Yocto docs
$ git format-patch -1 HEAD
# generates e.g. 0001-Add-my-custom-feature.patch
```

### Add source patch for linux-socfpga-lts Kernel
- Copy the patch to `linux-socfpga-lts/patches/` (renumber it after the existing series)
- Append to `SRC_URI` in `linux-socfpga-lts_%.bbappend`:
```bitbake
file://0013-Add-my-custom-feature.patch
```

The repository-root `.gitignore` ignores `*.patch`; `software/yocto_linux/.gitignore`
re-includes `linux-socfpga-lts/patches/*.patch`.

### Build Linux kernel
```bash
$ kas shell kas.yml
$ bitbake -c clean linux-socfpga-lts
$ bitbake -c build linux-socfpga-lts
```

## List of Linux binaries
With `MACHINE=agilex5e`:

```text
build/tmp/deploy/images/agilex5e/Image
build/tmp/deploy/images/agilex5e/kernel.itb
build/tmp/deploy/images/agilex5e/socfpga_agilex5_pcie_root_port_modular.dtb
```
