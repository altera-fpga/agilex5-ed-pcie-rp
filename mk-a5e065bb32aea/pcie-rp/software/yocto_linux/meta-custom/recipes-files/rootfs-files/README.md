# rootfs-files Recipe

This recipe provides a simple, extensible mechanism to deploy generic files (documents, scripts, configs, static binaries, static libraries, etc.) into the target root filesystem.

## Purpose

The `rootfs-files` recipe allows you to bundle static content into your Yocto images without writing complex recipes or modifying existing packages. It's ideal for:

- Platform README files and documentation with getting-started instructions
- System configuration files
- Custom scripts or utilities
- Precompiled static binaries
- Static libraries
- Any static content needed on the target

## Current Behavior (this PCIe Root Port design)

By default, the recipe installs from `files/`:

| Source | Target on rootfs |
|--------|------------------|
| `files/README.md` | `/home/root/README.md` |

NVMe / PCIe tools (`nvme-cli`, `lspci`, `fio`, `dtc`) come from packages in `IMAGE_INSTALL`
(`meta-custom/conf/layer.conf`), not from this recipe.

## Configuration Variables

You can customize the installation path and primary filename via BitBake variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `FILE_DIR` | `/home/root` | Target directory for `FILE_NAME` |
| `FILE_NAME` | `README.md` | Name of the file installed under `FILE_DIR` |

### Example: Installing an extra config under `/etc`

1. Add your file to `files/`, e.g., `files/custom.conf`
2. Override variables / extend `do_install` in the recipe or a bbappend
3. Update `SRC_URI` in `rootfs-files.bb` to include `file://custom.conf`

## Adding Multiple Files

To add more files, extend `SRC_URI`, `do_install`, and `FILES:${PN}` in `rootfs-files.bb`.

## Testing

Build and verify the recipe standalone (from a `kas shell kas.yml` environment):

```bash
bitbake rootfs-files
oe-pkgdata-util list-pkg-files rootfs-files
```

Expected paths include:
```text
/home/root/README.md
```

To test in a full image, ensure the package is in `IMAGE_INSTALL` and build:
```bash
bitbake console-image-minimal
# or: bitbake gsrd-console-image
```

After booting, verify:
```bash
cat /home/root/README.md
```
