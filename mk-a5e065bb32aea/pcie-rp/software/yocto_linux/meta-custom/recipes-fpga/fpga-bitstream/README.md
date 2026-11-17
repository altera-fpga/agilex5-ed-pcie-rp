# Core RBF FPGA configuration (Agilex™ 5 PCIe Root Port)

## Place the bitstream

Copy the hardware-generated **core** RBF into:

```text
meta-custom/recipes-fpga/fpga-bitstream/files/
```

Use the **exact** filename for the design you will build (`PCIE_RP_DESIGN` → `FPGA_RBF_FILE` in `meta-custom/conf/pcie-rp-solution.inc`):

| `PCIE_RP_DESIGN` | Filename |
|------------------|----------|
| `PCIE_RP_G4X4` | `baseline_a55.core.rbf` |

**Preferred:** top-level Make does this for you. After HW:

```bash
make mk-a5e065bb32aea-baseline-pcie-rp-all
# or software only:
make mk-a5e065bb32aea-baseline-pcie-rp-software-yocto_linux_sd-build-sw
```

That generates `output_files/<REVISION>.core.rbf` and `kas_build.sh` copies it into
`files/<REVISION>.core.rbf` (`REVISION` from `project_config.mk` `REVISION_NAMES`).
That name must match the table above (`FPGA_RBF_FILE` from `pcie-rp-solution.inc`).

**Manual copy** (if not using Make):

```bash
# From software/yocto_linux/
REVISION=baseline_a55
cp ../../output_files/${REVISION}.core.rbf \
  meta-custom/recipes-fpga/fpga-bitstream/files/${REVISION}.core.rbf
```

Do **not** hard-code `FPGA_RBF_FILE` in `kas.yml`. `pcie-rp-solution.inc` sets it from `PCIE_RP_DESIGN` (default `PCIE_RP_G4X4`).

The RBF is a build input and is not checked in (`files/*.rbf` is ignored). The GSRD 1.0
`hw-ref-design.bbappend` with checked-in RBFs and a sha256 check is no longer used.

## Build

```bash
# from yocto_linux/ — Make path already ran build.sh with the core.rbf
kas shell kas.yml -c "bitbake console-image-minimal"

# or only the bitstream recipe:
kas shell kas.yml -c "bitbake fpga-bitstream"
```

## What the recipe installs

- Input: `${FPGA_RBF_FILE}` from `files/` (name from `pcie-rp-solution.inc`)
- Deployed for HPS-first boot when `FPGA_ENABLE_CORE_PGM` is enabled
- Kernel FIT stages the core RBF inside `kernel.itb` (`board-0` / `board-4`)

## Optional: kas menu

If you use `kas menu`, enable **Enable core RBF FPGA configuration** and set the Core RBF filename to match the table above. The supported flow for this SED is `PCIE_RP_DESIGN` + `pcie-rp-solution.inc`.
