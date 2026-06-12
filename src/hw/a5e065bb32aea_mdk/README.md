# Agilex™ 5 PCIe Root Port System Example Design

This system example design demonstrates a PCIe root port running on the [Agilex™ 5 FPGA E-Series 065B Modular Development Kit](https://docs.altera.com/r/docs/820977/current/agilextm-5-fpga-e-series-065b-modular-development-kit-user-guide) connected to a Non-Volatile Memory express (NVMe) endpoint. The PCIe root port is capable of Gen4x4 speeds. The design is intended to serve as a reference to customers on how to implement and run a performant root port system using the Agilex™ 5 SoC and relevant IP.

## Description

The PCIe root port example design is based on the Agilex™ 5 Golden System Reference Design (GSRD) with the following components added:

- Linux driver for PCIe root port IP that runs on HPS, enumerates the PCIe endpoint(s) and configures the PCIe root port Hard IP (HIP) through a dedicated reconfiguration AXI-Lite interface.
- The Multichannel DMA (MCDMA) bridge which interfaces between the SoC's AXI-MM interface on one end and the AXI-ST interface on the PCIe root port IP (carrying PCIe TLP traffic) on the other.
- Various bridges, interconnects and adapters to handle clock crossing, data path and control path.

The system block diagram is shown below:

![Agilex™ 5 Root Port block diagram](https://github.com/altera-fpga/agilex5-ed-pcie-rp/blob/rel/26.1/images/SM_RP_MDK.png)

- The HPS-to-FPGA (H2F) lightweight AXI4 interface on the HPS is used for accessing the control and status (CSR) interface of various blocks on the design. It connects to the reconfiguration interface on the PCIe root port HIP as well as the Configuration Slave (CS) interface on the MCDMA bridge.
   - Configuration of the PCIe Endpoint (as part of Enumeration) is done via the CS interface. This interface supports only one outstanding configuration write/read transaction, as the number of PCIe tags allotted to this interface is only one (inside the MCDMA bridge).
   - The connection to the HIP reconfiguration interface allows for updating the Type1 configuration space fields such as Primary, Secondary and Subordinate Bus numbers as well as Memory ranges to support different addressing schemes, i.e., Route by ID or Route by Address. PCIe root port configuration and status register accesses for IRQ and error status are also done via the same path.
- Transfer of large memory transactions between the SoC's H2F AXI4 interface and the PCIe endpoint occurs via the Bursting AXI-MM Slave (BAS) interface on the MCDMA bridge. This interface theoretically supports 64 outstanding read transactions. 
- MSI/MSI-X interrupts from the PCIe endpoint are handled through the Bursting AXI-MM Master (BAM) interface on the bridge IP.
- The MSI Ordering module captures MSI/MSI-X interrupts coming from a PCIe Endpoint and forwards them to the host's interrupt controller (GIC) only after the preceding data writes have actually completed at the destination. This prevents the interrupt from reaching the HPS before the DMA data has landed in memory.
- The bridge IP also supports memory requests (Read/Write) initiated by the endpoint (DMA bus mastering) targeting System Memory. These transactions are routed via the HPS's FPGA-to-HPS (F2H) AXI4 interface as shown in the diagram.

## Project Details

- **Family**: Agilex 5
- **Quartus Version**: 26.1
- **Development Kit**: Agilex 5 FPGA E-Series 065B Modular Development Kit MK-A5E065BB32AEA
- **Device Part**: A5ED065BB32AE4S
- **Category**: HPS, PCIe
- **Source**: GitHub
- **Design Support**: Simulation, Compile/Timing, Hardware
- **URL**: https://github.com/altera-fpga/agilex5-ed-pcie-rp/tree/rel/26.1
- **Design Package**: a5ed065b-modular-devkit-pcie-rp-gen4x4.zip

## Build Steps

 1. Compile design and generate configuration file:

    ```
    cd syn/g4x4
	quartus_sh --flow compile top
    ```
## Programming Files Generation Steps

 1. The hex file containing the U-Boot SPL, u-boot-spl-dtb.hex, can be found in:
    src/sw/artifacts/26.1/u-boot-spl-dtb.hex

 2. Generate `top.{core,hps}.rbf` including U-Boot SPL:

    ```
    cd syn/g4x4
    quartus_pfg -c -o hps=on -o hps_path=u-boot-spl-dtb.hex output_files/top.sof output_files/top.rbf
    ```
   
   To integrate the generated `top.{core,hps}.rbf` into the yocto build, please to refer to [sw/README.md](../../sw/README.md).

## Steps to Migrate Design from Gen4x4 to Gen3x4

 - Open Quartus Project (<root_dir>/applications.fpga.soc.agilex5-ed-pcie-rp/src/hw/a5e065bb32aea_mdk/syn/g4x4/top.qpf)
 - Open Platform Designer (../../src/g4x4/qsys_top/qsys_top.qsys)
 - Right click on pcie_clk_rst_subsys_0, and "Drill into Subsystem"
 - The following table lists parameter changes required for existing IPs in pcie_clk_rst_subsys_0:

   | **IP Instance Name** | **Parameter Name** | **Parameter Value** |
   | -------------------- | ------------------ | ------------------- |
   | iopll_0 | Desired Frequency (under outclk1 section) | 125.0 |

 - Move up one level of hierarchy, and right click on pcie_subsys_0, and "Drill into Subsystem"
 - The following table lists parameter changes required for existing IPs in pcie_subsys_0:

   | **IP Instance Name** | **Parameter Name** | **Parameter Value** |
   | -------------------- | ------------------ | ------------------- |
   | h2f_addr_expander | Datapath Width | 128 |
   | h2f_addr_expander | Slave Word Address Width |	24 |
   | h2f_avmm_cdc | Data width | 128 |
   | config_timeout_0 | WDATA_WIDTH | 128 |
   | config_timeout_0 | RDATA_WIDTH | 128 |
   | intel_pcie_gts | Hard IP Mode | "Gen3 x4 Interface 128 bit" |
   | intel_pcie_gts | PLD clock frequency | 250MHz |
   | pcie_gts_mcdma | PCIe Mode | "Gen3 1x4" |
   | bam_axi_bridge | Data Width | 128 |
   | addr_filter | AXIMM_WDATA_WIDTH | 128 |
   | addr_filter | AXIMM_RDATA_WIDTH | 128 |

 - Add Avalon Memory Mapped Pipeline Bridge Intel FPGA IP (addr_filter_avmm_bridge) with the following parameter settings and connections:

   | **Parameter Name** | **Parameter Value** |
   | ------------------ | ------------------- |
   | Data width | 128 |
   | Address width | 64 |
   | Maximum burst size (words) | 16 |

   | **Source Interface** | **Sink Interface** | **Action** |
   | -------------------- | ------------------ | ------------------- |
   | addr_filter.egr_axi | f2h_avmm_cdc.s0 | Disconnect |
   | addr_filter.egr_axi | addr_filter_avmm_bridge.s0 | Connect |
   | pcie_clock_bridge.out_clk | addr_filter_avmm_bridge.clk | Connect |
   | pcie_reset_bridge.out_reset | addr_filter_avmm_bridge.reset | Connect |
   | addr_filter_avmm_bridge.m0 | f2h_avmm_cdc.s0 | Connect |

 - Click on the addr_filter instance and click on the Domains tab.
	- Select addr_filter.egr_axi
	- Under Interconnect Parameters in the Domain tab, set Burst adapter implementation to Per-burst type converter.
 - Click on System at the top left -> Show System with Platform Design Interconnect. In the Memory-Mapped Interconnect:
	-Select mm_interconnect_5 from the drop down and enable "Add all pipelines"
	-Close Window.
 - Click on System at the top left -> Show System with Platform Design Interconnect. In the Memory-Mapped Interconnect:
	-Select mm_interconnect_17 from the drop down and enable "Add all pipelines"
	-Close Window.
 - Move up hierarchy, Sync System Infos, and Generate HDL.
 - Compile Quartus project.

