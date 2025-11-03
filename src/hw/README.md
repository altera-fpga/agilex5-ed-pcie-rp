# Agilex™ 5 PCIe Root Port System Example Design Build Scripts

This directory contains the Quartus Project for the Agilex™ 5 PCIe Root Port System Example Design.

# Dependency

- Quartus® Prime 25.1
- Supported Board:
  - [Agilex™ 5 FPGA E-Series 065B Premium Development Kit](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/a5e065b-premium.html)

# Build Steps

 1. Compile design and generate configuration file:

    ```
    cd a5e065bb32aes1_pdk/syn/sm_4x4
	quartus_sh --flow compile top
    ```
# Programming Files Generation Steps

 1. The hex file containing the U-Boot SPL, u-boot-spl-dtb.hex, can be found in
    the output directory of the yocto build:
        src/sw/agilex5_dk_a5e065bb32aes1-rped-images/u-boot-agilex5-socdk-rped-atf

 2. Generate `agilex5_dk_a5e065bb32aes1_rped_ghrd.{core,hps}.rbf` including U-Boot SPL:

    ```
    cd a5e065bb32aes1_pdk/syn/sm_4x4
    quartus_pfg -c -o hps=on -o hps_path=u-boot-spl-dtb.hex output_files/agilex5_dk_a5e065bb32aes1_rped_ghrd.sof output_files/agilex5_dk_a5e065bb32aes1_rped_ghrd.rbf
    ```

# Steps to Migrate Design from Gen4x4 to Gen3x4
 _Note: To change QSF OPN setting to -6s device, replace: set_global_assignment -name DEVICE A5ED065BB32AE4SR0 with set_global_assignment -name DEVICE A5ED065BB32AE6SR0_
 
 - Open Quartus Project (<root_dir>/applications.fpga.soc.agilex5-ed-pcie-rp/src/hw/a5e065bb32aes1_pdk/syn/sm_4x4/top.qpf)
 - Open Platform Designer (../../src/sm_4x4/qsys_top/qsys_top.qsys)
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



