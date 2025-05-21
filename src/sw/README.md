# Yocto Project layer with Agilex™ 5 PCIe Root Port System Example Design

This directory contains a Yocto Project layer with the [Agilex™ 5 PCIe Root Port System Example](https://github.com/altera-fpga/agilex5-ed-pcie-rp) for the [Intel® SoCFPGA Golden Software Reference Design (GSRD)](https://github.com/altera-opensource/gsrd-socfpga).

## Supported Targets

The following targets are currently supported:

|    Board                                               |   OPN             |
| ------------------------------------------------------ | ----------------- |
| Agilex™ 5 FPGA E-Series Premium Development Kit        | DK-A5E065BB32AES1 |

## Yocto Build Instructions

 1. Clone the repository:

    ```
    git clone https://github.com/altera-fpga/agilex5-ed-pcie-rp
    cd agilex5-ed-pcie-rp/src/sw/
    ```

 2. Source the script to set component versions (Linux, U-Boot, ATF, Machine, Image):

    |    Board                                               |   Command                                   |
    | ------------------------------------------------------ | ------------------------------------------- |
    | Agilex™ 5 FPGA E-Series Premium Development Kit        | `. agilex5_dk_a5e065bb32aes1-rped-build.sh` |

 3. Setup the build environment:

    ```
    build_setup
    ```

 4. Perform Yocto bitbake to generate binaries:

    ```
    bitbake_image
    ```

 5. Package binaries into build folder:

    ```
    package
    ```
