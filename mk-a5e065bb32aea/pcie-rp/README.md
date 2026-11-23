# Altera Agilex 5 PCIe Root Port System Example Design

System Example Design for the [Agilex 5 FPGA E-Series 065B Modular Development Kit (MK-A5E065BB32AEA)](https://www.altera.com/products/devkit/po-3274/agilex-5-fpga-and-soc-e-series-065b-modular-development-kit)
(`mk-a5e065bb32aea`) demonstrating a PCIe Gen4x4 root port with HPS, Multichannel DMA
(MCDMA) bridge, and related interconnect.

## Dependency

- Altera Quartus Prime Pro (see Project Details in the [repository README](../../README.md) for the supported version)
- Software / Yocto: [software/yocto_linux/README.md](software/yocto_linux/README.md)

## Directory structure

```text
pcie-rp/
+-- Makefile / project_config.mk / swbuild_config.mk
+-- src/                        # HARDWARE - RTL / Qsys / custom IP
+-- syn/g4x4/                   # HARDWARE - Quartus project + Makefile
|   +-- output_files/
+-- sim_example/                # HARDWARE - example simulation scripts / TB
+-- software/
    +-- yocto_linux/            # SOFTWARE - see software/yocto_linux/README.md
```

| Path | Role |
|------|------|
| `src/` | RTL, Qsys, custom IP |
| `syn/g4x4/` | Quartus project and compile `Makefile` |
| `sim_example/` | Example simulation environment |
| `software/yocto_linux/` | Yocto / KAS BSP |

## Compiling via Makefile (hardware and software)

The top-level Makefile is in the design root (`pcie-rp/`). The Quartus project
(`top.qpf` / `top.qsf`) lives in `syn/g4x4/`.

Run `make help` from `pcie-rp/` for the full target list.

Public stem: `mk-a5e065bb32aea-baseline-pcie-rp`  
Hardware revision (SOF / RBF basename): `baseline_a55` (`REVISION_NAMES` in `project_config.mk`).

**Full build (hardware and software):**

```bash
make mk-a5e065bb32aea-baseline-pcie-rp-all
```

This runs the hardware build, generates the core RBF from the SOF, then runs the Yocto SD software build.

**Hardware build only:**

```bash
make mk-a5e065bb32aea-baseline-pcie-rp-build
```

This calls `syn/g4x4/Makefile` (`make -C syn/g4x4 all`) and then copies `syn/g4x4/output_files/top.sof`
to `output_files/baseline_a55.sof` for the install and software targets.

**Software build only**, after the hardware build generates the required SOF (core RBF is produced automatically):

```bash
make mk-a5e065bb32aea-baseline-pcie-rp-software-yocto_linux_sd-build-sw
```

This runs `quartus_pfg` to create the core RBF, then
`software/yocto_linux/build.sh <core.rbf> sd`.

**Install SOF / reports / software artifacts** under `install/`:

```bash
make mk-a5e065bb32aea-baseline-pcie-rp-install
```

**Install core RBF only** (SOF + `quartus_pfg` → `install/binaries/`):

```bash
make mk-a5e065bb32aea-baseline-pcie-rp-install-core-rbf
```

Yocto RBF/DTB names and kas details:
[software/yocto_linux/README.md](software/yocto_linux/README.md).

## Building the Hardware only

See [syn/g4x4/README.md](./syn/g4x4/README.md).

## Programming files (SOF + FSBL)

There is no checked-in SPL hex any more (`software/yocto_linux/artifacts/` was removed with the
GSRD 2.0 migration). `u-boot-spl-dtb.hex` is produced by the Yocto build under
`software/yocto_linux/build/tmp/deploy/images/agilex5e/`.

After a Yocto build:

```bash
cd syn/g4x4
quartus_pfg -c -o hps=on \
  -o hps_path=../../software/yocto_linux/build/tmp/deploy/images/agilex5e/u-boot-spl-dtb.hex \
  output_files/top.sof \
  output_files/top.rbf
```

Or use the revision-named SOF produced by the top-level Makefile under `output_files/`.

In CI, `scripts/build-hw-mdk.sh` uses the SPL hex from the latest nightly software publish when
available; otherwise the software workflow generates `*.ghrd.hps.rbf` after it publishes the hex.

## Simulation example

See [sim_example/README](sim_example/README).

## Software

Yocto / KAS, RBF/DTB names, `build.sh`, binaries:  
**[software/yocto_linux/README.md](software/yocto_linux/README.md)**.
