# Overview of yocto_linux

Yocto / KAS BSP for the Agilex™ 5 PCIe Root Port SED on the Agilex™ 5 FPGA E-Series 065B
Modular Development Kit (`MACHINE=agilex5e`).
Select the design with **`PCIE_RP_DESIGN`** (see `meta-custom/conf/pcie-rp-solution.inc`; default `PCIE_RP_G4X4`).
Hardware compile (`src/` / `syn/g4x4/`): [../../README.md](../../README.md) and
[../../syn/g4x4/README.md](../../syn/g4x4/README.md).

The base layer is `meta-altera-fpga` / `meta-altera-bsp`. Configure and build with KAS and BitBake.

This `yocto_linux/` tree is the **software** BSP. Hardware for this PCIe Root Port design lives
alongside it under `mk-a5e065bb32aea/pcie-rp/`:

| Path | Role |
|------|------|
| `../../src/` | Hardware — RTL / Qsys / custom IP |
| `../../syn/g4x4/` | Hardware — Quartus project / Makefile |
| `../` (`software/`) | Software parent |
| `.` (`yocto_linux/`) | KAS / Yocto (this README) |

See [../../README.md](../../README.md) for hardware build and programming-file steps.

**Note:** There is **no** `artifacts/` directory any more. `u-boot-spl-dtb.hex` and other
boot binaries are generated under `build/tmp/deploy/images/agilex5e/` after a Yocto build.

## Design details

| Item | Value |
|------|-------|
| Family | Agilex 5 |
| Development kit | Agilex 5 FPGA E-Series 065B Modular Development Kit (MK-A5E065BB32AEA, `mk-a5e065bb32aea`) |
| Device part | A5ED065BB32AE4S |
| Quartus Prime Pro | 26.3 |
| PCIe | GTS root port, Hard IP mode `Gen4 x4` (16.0 Gbps lane rate), NVMe endpoint |
| Subsystem | PCIe root port + HPS + Multichannel DMA (MCDMA) bridge |
| `MACHINE` | `agilex5e` (`kas/machine.yml`) |
| Hardware revision | `baseline_a55` (`REVISION_NAMES` in `../../project_config.mk`) |
| Make stem | `mk-a5e065bb32aea-baseline-pcie-rp` |
| Deploy directory | `build/tmp/deploy/images/agilex5e/` |

## Component versions

Set in `kas/bsp.yml`; all three are fetched from the public `altera-fpga` repositories with
`SRCREV = "${AUTOREV}"`, i.e. the tip of the branch at build time.

| Component | Branch | Recipe version |
|-----------|--------|----------------|
| Linux | `socfpga-6.18.37-lts` | `linux-socfpga-lts` 6.18.37 |
| U-Boot | `socfpga_v2026.07` | `u-boot-socfpga` v2026.07 |
| Arm Trusted Firmware | `socfpga_v2.15.0` | `arm-trusted-firmware` v2.15 (BL31 reports v2.15.1) |

## Migration from GSRD 1.0

| GSRD 1.0 (`src/sw`, `meta-altera-pcie-rp`) | GSRD 2.0 (`software/yocto_linux`, `meta-custom`) |
|---------------------------------------------|---------------------------------------------------|
| `agilex5_dk_a5e065bb32aes1-rped-build.sh`, `IMAGE_TYPE=rped` | `build.sh <core.rbf> sd` (KAS) |
| `MACHINE=agilex5_dk_a5e065bb32aes1` | `MACHINE=agilex5e` (`kas/machine.yml`) |
| Kernel `socfpga-6.18.37-lts` + 12 patches | Kernel `socfpga-6.18.37-lts` + 13 patches (the same 12 plus `0013-PCI-altera-Limit-MRRS-to-512-bytes-on-MCDMA-Root-Por`) |
| `device-tree.bbappend` (socdk.dts override) | `device-tree/socfpga_agilex5_pcie_root_port_modular.dts` built with the kernel |
| `hw-ref-design.bbappend` + checked-in RBFs | `recipes-fpga/fpga-bitstream/files/baseline_a55.core.rbf` staged from HW build |
| `fit_kernel_agilex5_dk_a5e065bb32aes1_rped.its` (crc32) | `fit_agilex5_kernel_pcie_rp.its` (sha256 / rsa2048), `kernel.itb` |
| `artifacts/<ver>/u-boot-spl-dtb.hex` | Yocto deploy `u-boot-spl-dtb.hex` |

Following is the top level view of the yocto_linux framework.

```
.
├── kas
│   ├── bsp.yml
│   ├── gsrd
│   │   └── Kconfig
│   ├── image
│   │   ├── all-image-targets.yaml
│   │   ├── console-image-minimal.yaml
│   │   ├── core-image-minimal.yaml
│   │   ├── gsrd-console-image.yaml
│   │   └── Kconfig
│   └── machine.yml
├── kas.yml
├── Kconfig
├── meta-custom
│   ├── classes
│   ├── conf
│   │   ├── layer.conf
│   │   ├── pcie-rp-solution.inc
│   │   └── machine
│   ├── LICENSE
│   ├── README.md
│   ├── recipes-bsp
│   │   └── u-boot
│   ├── recipes-files
│   │   ├── rootfs-files
│   │   ├── test-suite-agilex5
│   │   └── uboot-test-suite-agilex5
│   ├── recipes-fpga
│   │   └── fpga-bitstream
│   └── recipes-kernel
│       ├── linux
│       │   ├── device-tree
│       │   └── linux-socfpga-lts
│       │       ├── configs
│       │       └── patches
│       └── perf
├── scripts
├── build.sh
├── kas_build.sh
├── clean_build.sh
└── README.md

```

## KAS
- **Kconfig**  
Contains configuration definitions for KAS menu options to configure the Yocto.
- **kas.yml**  
kas.yaml is the configuration file used by KAS and contains the info of repos to be cloned, machine and other Yocto related configurations.

- **kas/image**  
The image directory contains yaml configurations for core-image-minimal, console-image-minimal and gsrd-console-image targets.

    - **core-image-minimal**  
        In the Yocto core-image-minimal is the most basic reference image recipes provided by the Poky
        distribution. It’s essentially a minimal root filesystem which is just enough to boot the system and
        provide a command-line interface.
    - **console-image-minimal**  
        In addition to core-image-base, console-image-minimal enables following packages,
        - Common essentials
        - Network essentials
        - Openssh
        - NFS
        - lighttpd
        - udev
        - systemd
        - mtd-utils

    - **gsrd-console-image**  
        In addition to core-image-base, gsrd-console-image enables following packages,
        - Common essentials
        - dev-tools essentials
        - Network essentials
        - web-server essentials
        - nfs-utils-client
        - Openssh
        - FIO
        - perl
        - NFS
        - lighttpd
        - udev
        - systemd
        - mtd-utils

The PCIe Root Port design additionally installs `rootfs-files`, `nvme-cli`, `dtc`, `fio`,
`pciutils` (`lspci`), `util-linux` and `coreutils` in every image
(`IMAGE_INSTALL` in `meta-custom/conf/layer.conf`).

## meta-custom layer
- **conf**  
Contains layer configuration and `pcie-rp-solution.inc` (design → RBF / DTB mapping).
- **recipes-bsp**  
Contains _u-boot_ customizations (environment, `bootfile=kernel.itb`).
- **recipes-files**  
Contains recipes for adding custom files and test suites to the root filesystem.
- **recipes-fpga**  
Contains the _fpga-bitstream_ recipe to include RBF file.
- **recipes-kernel**  
Contains _linux_ recipe to create Kernel Image with custom configurations.
    - _device-tree_ — `socfpga_agilex5_pcie_root_port_modular.dts` (MDK board + PCIe Root Port).
    - _linux-socfpga-lts_ — PCIe Root Port kernel patches, NVMe config fragment and FIT `.its` files.

Refer following links to understand more on BSP customization (Top level ```meta-custom/README.md``` provides introduction to each section).

- U-Boot — `meta-custom/recipes-bsp/u-boot/`
- Linux Kernel
	```meta-custom/recipes-kernel/linux/README.md```
- Linux Device Tree
	```meta-custom/recipes-kernel/linux/device-tree/README.md```
- FPGA Bitstream
	```meta-custom/recipes-fpga/fpga-bitstream/README.md```

## scripts
Contains helper scripts and configuration files for generating QSPI JIC images from Yocto build outputs.
Refer to ```scripts/README.md``` for detailed instructions on creating bootable images for QSPI flash.

# Yocto Build

## Prepare FPGA Bitstream (RBF)

`PCIE_RP_DESIGN` (default `PCIE_RP_G4X4`) selects the RBF name via
`meta-custom/conf/pcie-rp-solution.inc` → `FPGA_RBF_FILE`. Do **not** hard-code
`FPGA_RBF_FILE` in `kas.yml`.

| `PCIE_RP_DESIGN` | Filename under `fpga-bitstream/files/` |
|------------------|----------------------------------------|
| `PCIE_RP_G4X4` | `baseline_a55.core.rbf` |

**Preferred (top-level Make):** HW + SW together — Make creates the core RBF and
`kas_build.sh` copies it to `fpga-bitstream/files/<REVISION>.core.rbf`
(`REVISION` from `project_config.mk`; must match `FPGA_RBF_FILE` above):

```bash
# from mk-a5e065bb32aea/pcie-rp/
make mk-a5e065bb32aea-baseline-pcie-rp-all
```

**Manual copy** (if building Yocto without that Make target):

```bash
# From software/yocto_linux/
REVISION=baseline_a55
cp ../../output_files/${REVISION}.core.rbf \
  meta-custom/recipes-fpga/fpga-bitstream/files/${REVISION}.core.rbf
```

**The bitstream is not stored in this repository.** `*.rbf` and `*.sof` are listed in
`.gitignore` and only a `.dummy` placeholder is tracked under `fpga-bitstream/files/`.
Because `kas.yml` sets `FPGA_ENABLE_CORE_PGM ?= "1"`, a fresh clone fails at `do_fetch`
until you supply the core RBF by one of the two methods above.

Setting `FPGA_ENABLE_CORE_PGM = "0"` builds a `kernel.itb` with **no** bitstream inside and
selects `fit_agilex5_kernel_no_rbf_pcie_rp.its`, which provides only `board-0` and `board-2`;
booting `board-4` then fails because that configuration does not exist.

The DTB `socfpga_agilex5_pcie_root_port_modular.dtb` is built with the kernel from
`meta-custom/recipes-kernel/linux/device-tree/`; see its README.

## Build environment

**Prerequisites**
- Ubuntu 22.04 LTS or later is recommended for Yocto builds
- The system shell must use bash instead of dash. On Ubuntu 22.04, run:
  ```bash
  sudo ln -sf /bin/bash /bin/sh
  ```
- Network access to the public `altera-fpga` repositories (`meta-altera-fpga`, `linux-socfpga`,
  `u-boot-socfpga`, `arm-trusted-firmware`). No credentials are required.
  KAS runs git with a temporary `HOME`, so pass your git configuration explicitly:
  ```bash
  export GITCONFIG_FILE=$HOME/.gitconfig
  ```

Install the following host packages and tools required for yocto build.

**Host packages**
```bash
# apt install build-essential chrpath cpio debianutils diffstat file gawk gcc git iputils-ping libacl1 liblz4-tool locales python3 python3-git python3-jinja2 python3-pexpect python3-pip python3-subunit python3-newt socat texinfo unzip wget xz-utils zstd
```
Reference, https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html#build-host-packages

**KAS tool**
```bash
$ python3 -m venv venv --system-site-packages
$ source venv/bin/activate
$ pip install --upgrade pip
$ pip install kas
$ pip install kconfiglib
```
Reference, https://kas.readthedocs.io/en/latest/userguide/getting-started.html#dependencies-installation

## How to build

### PCIe Root Port design selection (`PCIE_RP_DESIGN`)

Valid values: `PCIE_RP_G4X4`  
Default: `PCIE_RP_G4X4`

| Value | Behavior |
|-------|----------|
| `PCIE_RP_G4X4` | One FIT (`kernel.itb`) for the Gen4x4 PCIe Root Port design (`syn/g4x4`) |

### From design root (`pcie-rp/`) — top-level make

```bash
cd ../..   # pcie-rp/
make mk-a5e065bb32aea-baseline-pcie-rp-all
# Hardware only:
make mk-a5e065bb32aea-baseline-pcie-rp-build
# Software only (needs SOF / core RBF from HW):
make mk-a5e065bb32aea-baseline-pcie-rp-software-yocto_linux_sd-build-sw
```

### Recommended — `build.sh`

Make supplies the core RBF path. Manual equivalent from `yocto_linux/`:

```bash
./build.sh ../../output_files/baseline_a55.core.rbf sd
# Usage: ./build.sh <RBF_FILE> <BOOT_SOURCE>
# BOOT_SOURCE: sd | qspi | emmc | nand
```

### Default targets — `kas build`

`kas.yml` declares the default targets, so a bare `kas build` produces the same images as
`build.sh`:

```yaml
target:
  - console-image-minimal
  - gsrd-console-image
```

```bash
kas build kas.yml
```

### From command line — `kas shell`

```bash
PCIE_RP_DESIGN=PCIE_RP_G4X4 kas shell kas.yml -c "bitbake console-image-minimal"
```

Or:

```bash
export PCIE_RP_DESIGN=PCIE_RP_G4X4
kas shell kas.yml
bitbake console-image-minimal
```

### Using Yocto GUI (`kas menu`)

```bash
export PCIE_RP_DESIGN=PCIE_RP_G4X4   # optional; default is PCIE_RP_G4X4
kas menu
# configure options, then Build — or Save & Exit and:
kas shell .config.yaml
bitbake console-image-minimal
```

### Binaries
After the build, the generated binaries can be found in:

```text
build/tmp/deploy/images/agilex5e/
```

(`MACHINE` is set to `agilex5e` in `kas/machine.yml`.)

**List of Binaries**
|Binaries								        |Description                                                            |
|-----------------------------------------------|-----------------------------------------------------------------------|
|uboot.env										|U-Boot environment file.                                               |
|boot.scr.uimg  								|Boot script.                                                           |
|u-boot-spl-dtb.bin								|U-Boot FSBL image in binary format.                                    |
|u-boot-spl-dtb.hex								|U-Boot FSBL image in hex format (replaces old `artifacts/*/u-boot-spl-dtb.hex`). |
|u-boot.itb										|U-Boot proper + device tree blob.                                      |
|bl31.bin                                       |Arm Trusted Firmware                                                   |
|Image											|Linux Kernel image.                                                    |
|kernel.itb									|Linux kernel FIT (Image + DTBs + core RBF); configurations below.      |
|socfpga_agilex5_pcie_root_port_modular.dtb		|PCIe Root Port SED device tree blob for Linux Kernel.                  |
|console-image-minimal-agilex5e.rootfs.tar.gz	|console-image-minimal rootfs.					                        |
|console-image-minimal-agilex5e.rootfs.wic      |SD/MMC bootable disk image.                                            |
|gsrd-console-image-agilex5e.rootfs.wic         |SD/MMC bootable disk image (if building gsrd-console-image).           |

**`kernel.itb` configurations**

| Configuration | DTB | FPGA core RBF | Use |
|---------------|-----|---------------|-----|
| `board-0` (default) | PCIe Root Port | yes | SD boot default (`board_id=0`) |
| `board-1` | Vanilla GSRD (`LINUX_DTB_FILE`, `socfpga_agilex5_socdk.dtb`) | no | Boot without the PCIe Root Port |
| `board-2` | PCIe Root Port | no | Core RBF already loaded (JTAG / U-Boot); used by MDK regression |
| `board-4` | PCIe Root Port | yes | GSRD 1.0 compatible name |

Boot a specific configuration from U-Boot with `bootm ${loadaddr}#board-2`.

### Programming files with FSBL (quartus_pfg)

After Yocto has produced `u-boot-spl-dtb.hex`, run from `syn/g4x4/` (or pass absolute paths):

```bash
# From mk-a5e065bb32aea/pcie-rp/syn/g4x4/
quartus_pfg -c -o hps=on \
  -o hps_path=../../software/yocto_linux/build/tmp/deploy/images/agilex5e/u-boot-spl-dtb.hex \
  output_files/top.sof \
  output_files/top.rbf
```

Optional: write an SOF with FSBL into the Yocto deploy directory:

```bash
# From software/yocto_linux/
DEPLOY=build/tmp/deploy/images/agilex5e
REVISION=baseline_a55
SOF_IN=../../output_files/${REVISION}.sof

quartus_pfg -c -o hps_path=${DEPLOY}/u-boot-spl-dtb.hex \
  ${SOF_IN} \
  ${DEPLOY}/${REVISION}_yocto_linux_sd.sof
```

Hardware compile details: [../../README.md](../../README.md).

### Steps to create QSPI bootable image (JIC)
Follow steps mentioned in ```scripts/README.md``` file.

### Notes

#### KAS Configuration - Include and Append/Override configurations

KAS supports modularizing build configurations by allowing multiple YAML files to be included and merged.
When multiple files are specified, KAS processes and merges them **in order**, with settings in later files overriding those from earlier ones.
This mechanism enables maintaining a stable base configuration while applying targeted overrides or additions as needed.

**Usage Example**

Before building, verify final configuration after merge:
```bash
kas dump kas.yml:qspi_boot_src.yml
```

To build the project:
```bash
kas build kas.yml:qspi_boot_src.yml
```

* `kas.yml` is the base configuration file (it already includes `kas/bsp.yml` and `kas/machine.yml`).
* `qspi_boot_src.yml` contains override settings for QSPI boot.

**References**

* [Including In-Tree Configuration Files](https://kas.readthedocs.io/en/latest/userguide/project-configuration.html#including-in-tree-configuration-files)
* [Including Configuration Files from Other Repos](https://kas.readthedocs.io/en/latest/userguide/project-configuration.html#including-configuration-files-from-other-repos)
* [Including Configuration Files via the Command Line](https://kas.readthedocs.io/en/latest/userguide/project-configuration.html#including-configuration-files-via-the-command-line)

#### Bitbake commands for building key targets
- **Core Image**
```bash
$ bitbake -c build core-image-minimal
```
- **Baseline System Example Design image**
```bash
$ bitbake -c build gsrd-console-image
```
- **U-Boot**
```bash
$ bitbake -c build u-boot-socfpga (or) bitbake -c build virtual/bootloader
```
- **Linux**
```bash
$ bitbake -c build linux-socfpga-lts  (or) bitbake -c build virtual/kernel
```
- **ATF**
```bash
$ bitbake -c build arm-trusted-firmware
```
- **Device Tree** (built with the kernel; DTB selected by `PCIE_RP_DESIGN` / `pcie-rp-solution.inc`)
```bash
$ bitbake -c build linux-socfpga-lts
```

### Documentation
- [HPS PCIe Root Port System Example Design User Guide: Agilex 5 E-Series 065B Modular Development Kit](https://altera-fpga.github.io/latest/embedded-designs/agilex-5/e-series/modular-065b/pcie-rp/ug-pcie_rp-agx5e-modular-065b/)
- [KAS] https://kas.readthedocs.io/en/latest/
- [YOCTO] https://docs.yoctoproject.org/
