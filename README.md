# Agilex™ 5 PCIe Root Port System Example Design

This system example design demonstrates a PCIe root port running on the [Agilex™ 5 FPGA E-Series 065B Premium Development Kit](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/a5e065b-premium.html) connected to a Non-Volatile Memory express (NVMe) endpoint. The PCIe root port is capable of Gen4x4 speeds. The design is intended to serve as a reference to customers on how to implement and run a performant root port system using the Agilex™ 5 SoC and relevant IP.

## Description

The PCIe root port example design is based on the Agilex™ 5 Golden System Reference Design (GSRD) with the following components added:

- Linux driver for PCIe root port IP that runs on HPS, enumerates the PCIe endpoint(s) and configures the PCIe root port Hard IP (HIP) through a dedicated reconfiguration AXI-Lite interface.
- The Multichannel DMA (MCDMA) bridge which interfaces between the SoC's AXI-MM interface on one end and the AXI-ST interface on the PCIe root port IP (carrying PCIe TLP traffic) on the other.
- Various bridges, interconnects and adapters to handle clock crossing, data path and control path.

The system block diagram is shown below:

![Agilex™ 5 Root Port block diagram](https://github.com/altera-fpga/agilex5-ed-pcie-rp/blob/rel/25.1/images/SM_RP.png)

- The HPS-to-FPGA (H2F) lightweight AXI4 interface on the HPS is used for accessing the control and status (CSR) interface of various blocks on the design. It connects to the reconfiguration interface on the PCIe root port HIP as well as the Configuration Slave (CS) interface on the MCDMA bridge.
   - Configuration of the PCIe Endpoint (as part of Enumeration) is done via the CS interface. This interface supports only one outstanding configuration write/read transaction, as the number of PCIe tags allotted to this interface is only one (inside the MCDMA bridge).
   - The connection to the HIP reconfiguration interface allows for updating the Type1 configuration space fields such as Primary, Secondary and Subordinate Bus numbers as well as Memory ranges to support different addressing schemes, i.e., Route by ID or Route by Address. PCIe root port configuration and status register accesses for IRQ and error status are also done via the same path.
- Transfer of large memory transactions between the SoC's H2F AXI4 interface and the PCIe endpoint occurs via the Bursting AXI-MM Slave (BAS) interface on the MCDMA bridge. This interface theoretically supports 64 outstanding read transactions. 
- MSI/MSI-X interrupts from the PCIe endpoint are handled through the Bursting AXI-MM Master (BAM) interface on the bridge IP.
- The bridge IP also supports memory requests (Read/Write) initiated by the endpoint (DMA bus mastering) targeting System Memory. These transactions are routed via the HPS's FPGA-to-HPS (F2H) AXI4 interface as shown in the diagram.

## Project Details

- **Family**: Agilex 5
- **Quartus Version**: 25.1
- **Development Kit**: Agilex 5 FPGA E-Series 065B Premium Development Kit DK-A5E065BB32AES1
- **Device Part**: A5ED065BB32AE4SR0
- **Category**: HPS, PCIe
- **Source**: GitHub
- **Design Support**: Simulation, Compile/Timing, Hardware
- **URL**: https://github.com/altera-fpga/agilex5-ed-pcie-rp
- **Design Package**: a5ed065es-premium-devkit-pcie-rp-gen4x4.zip

## Repository Structure

Directory Structure used in this example design:

 ```bash
    |--- doc
    |--- src
    |   |--- hw
    |   |--- sw
 ```

## Getting Started

Follow the steps below to build the design:

- [Building the hardware](src/hw/README.md)
- [Building the software](src/sw/README.md)
