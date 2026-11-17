# Custom rootfs files (PCIe Root Port SED)

These files are installed onto the target root filesystem by the `rootfs-files` recipe
(see [../README.md](../README.md)).

| File | Installed path | Purpose |
|------|----------------|---------|
| `README.md` | `/home/root/README.md` | Placeholder / notes on target |

To add more files, place them in this directory and update `SRC_URI` / `do_install` in
`../rootfs-files.bb`.
