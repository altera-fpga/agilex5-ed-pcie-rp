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

# Design Verification Steps
 1. Run sanity test:

    ```
    cd a5e065bb32aes1_pdk/verification/scripts/itf
    arc shell osc_dv/2021WW37 vcs-vcsmx-lic/vrtn-dev,synopsys_dc/R-2020.09-SP3,acdskit-rtl/24.3,avalon_vip/13.1/1,devmain/1.0,devacds/23.4,synopsys_vip_common/vip_Q-2020.03A,p4/psgeng,perl/5.8.8,testutils/23.4,regutils/23.4,itf/23.4,altuvm/0.9p8,synopsys_verdi/R-2020.12-SP2,vcs/R-2020.12-SP2-6,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr,easic_etools/13.3,cygwin/2.9.0
    export REG_LOCAL_ROOT_DIR_PATH=<WORKING_DIRECTORY>/applications.fpga.soc.agilex5-ed-pcie-rp/src/hw/a5e065bb32aes1_pdk/verification
    reg_exe --localr --testname=sysrp_sanity_test --seed=1 --dump_on=1 --uvm_verbosity=HIGH
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

 - Add Avalon Memory Mapped Pipeline Bridge Intel FPGA IP (bam_avmm_bridge) with the following parameter settings and connections: 

   | **Parameter Name** | **Parameter Value** |
   | ------------------ | ------------------- |
   | Data width | 128 |
   | Address width | 64 |
   | Maximum burst size (words) | 16 |

   | **Source Interface** | **Sink Interface** | **Action** |
   | -------------------- | ------------------ | ------------------- |
   | bam_axi_bridge.m0 | ready_latency_0_ocm_avmm_bridge.s0 | Disconnect |
   | bam_axi_bridge.m0 | ready_latency_avmm_bridge_2g.s0 | Disconnect |
   | bam_axi_bridge.m0 | ready_latency_avmm_bridge_6g.s0 | Disconnect |
   | bam_axi_bridge.m0 | ready_latency_msi_to_gic_avmm_bridge.s0 | Disconnect |
   | pcie_clock_bridge.out_clk | bam_avmm_bridge.clk | Connect |
   | pcie_reset_bridge.out_reset | bam_avmm_bridge.reset | Connect |
   | bam_axi_bridge.m0 | bam_avmm_bridge.s0 | Connect |
   | bam_avmm_bridge.m0 | ready_latency_0_ocm_avmm_bridge.s0 | Connect |
   | bam_avmm_bridge.m0 | ready_latency_avmm_bridge_2g.s0 | Connect |
   | bam_avmm_bridge.m0 | ready_latency_avmm_bridge_6g.s0 | Connect |

 - Add Avalon Memory Mapped Clock Crossing Bridge Intel FPGA IP (msi_to_gic_avmm_cdc) with the following parameter settings and connections:

   | **Parameter Name** | **Parameter Value** |
   | ------------------ | ------------------- |
   | Address width | 7 |

   | **Source Interface** | **Sink Interface** | **Action** |
   | -------------------- | ------------------ | ------------------- |
   | clk_100.out_clk | msi_to_gic_avmm_cdc.m0_clk | Connect |
   | rst_100.out_reset | msi_to_gic_avmm_cdc.m0_reset | Connect |
   | pcie_clock_bridge.out_clk | msi_to_gic_avmm_cdc.s0_clk | Connect |
   | pcie_reset_bridge.out_reset | msi_to_gic_avmm_cdc.s0_reset | Connect |
   | bam_avmm_bridge.m0 | msi_to_gic_avmm_cdc.s0 | Connect |
   | msi_to_gic_avmm_cdc.m0 | - | Export from pcie_subsys.qsys and qsys_top.qsys |

 - Update ready_latency_msi_to_gic_avmm_bridge with the connections:

   | **Source Interface** | **Sink Interface** | **Action** |
   | -------------------- | ------------------ | ------------------- |
   | pcie_clock_bridge.out_clk | ready_latency_msi_to_gic_avmm_bridge .clk | Disconnect |
   | clk_100.out_clk | ready_latency_msi_to_gic_avmm_bridge .clk | Connect |
   | pcie_reset_bridge.out_reset | ready_latency_msi_to_gic_avmm_bridge .reset | Disconnect |
   | rst_100.out_reset | ready_latency_msi_to_gic_avmm_bridge .reset | Connect |
   | - | ready_latency_msi_to_gic_avmm_bridge.s0 | Export from pcie_subsys.qsys and qsys_top.qsys |

 - Update msi_to_gic_vector_avmm_cdc with the following connections:

   | **Source Interface** | **Sink Interface** | **Action** |
   | -------------------- | ------------------ | ------------------- |
   | msi_to_gic_vector_avmm_cdc.m0 | msi_to_gic.vector_slave | Disconnect  |
   | msi_to_gic_vector_avmm_cdc.m0 | - | Export from pcie_subsys.qsys and qsys_top.qsys |
   | h2f_lw_axi_bridge.m0 | msi_to_gic_vector_avmm_cdc.s0 | Disconnect |
   | - | msi_to_gic_vector_avmm_cdc.s0 | Export from pcie_subsys.qsys and qsys_top.qsys |

 - Update msi_to_gic_csr_avmm_cdc with the following connections:

   | **Source Interface** | **Sink Interface** | **Action** |
   | -------------------- | ------------------ | ------------------- |
   | msi_to_gic_csr_avmm_cdc.m0 | msi_to_gic.csr | Disconnect |
   | msi_to_gic_csr_avmm_cdc.m0 | - | Export from pcie_subsys.qsys and qsys_top.qsys |
   | h2f_lw_axi_bridge.m0 | msi_to_gic_csr_avmm_cdc.s0 | Disconnect |
   | - | msi_to_gic_csr_avmm_cdc.s0 | Export from pcie_subsys.qsys and qsys_top.qsys |

 - Update msi_to_gic with the following connections:

   | **Source Interface** | **Sink Interface** | **Action** |
   | -------------------- | ------------------ | ------------------- |
   | pcie_clock_bridge.out_clk | msi_to_gic.clock | Disconnect |
   | clk_100.out_clk | msi_to_gic.clock | Connect |
   | pcie_reset_bridge.out_reset | msi_to_gic.reset | Disconnect |
   | rst_100.out_reset | msi_to_gic.reset | Connect |

 - Update h2f_lw_axi_bridge with the following connections:

   | **Source Interface** | **Sink Interface** | **Action** |
   | -------------------- | ------------------ | ------------------- |
   | h2f_lw_axi_bridge.m0 | performance_counter_0.control_slave | Disconnect |
   | h2f_lw_axi_bridge.m0 | msi_to_gic.csr | Connect |
   | h2f_lw_axi_bridge.m0 | msi_to_gic.vector_slave | Connect |

 - Add Avalon Memory Mapped Clock Crossing Bridge Intel FPGA IP (perf_cnt_avmm_cdc) with the following parameter settings and connections:

   | **Parameter Name** | **Parameter Value** |
   | ------------------ | ------------------- |
   | Address width | 5 |

   | **Source Interface** | **Sink Interface** | **Action** |
   | -------------------- | ------------------ | ------------------- |
   | pcie_reset_bridge.out_clk | perf_cnt_avmm_cdc.m0_clk | Connect |
   | pcie_reset_bridge.out_reset | perf_cnt_avmm_cdc.m0_reset | Connect |
   | clk_100.out_clk | perf_cnt_avmm_cdc.s0_clock | Connect |
   | rst_100.out_reset | perf_cnt_avmm_cdc s0_reset | Connect |
   | h2f_lw_axi_bridge.m0 | perf_cnt_avmm_cdc.s0 | Connect |
   | perf_cnt_avmm_cdc.m0 | performance_counter_0.control_slave | Connect |

 - In Address Map tab, update the starting Base Address according to the following table:

   | **Source Interface** | **Sink (Subordinate) Interface** | **Starting Base Address** |
   | -------------------- | ------------------ | ------------------- |
   | h2f_lw_axi_bridge.m0 | msi_to_gic.vector_slave | 0x8000 |
   | h2f_lw_axi_bridge.m0 | msi_to_gic.csr | 0x8080 |
   | h2f_lw_axi_bridge.m0 | perf_cnt_avmm_cdc.s0 | 0x80a0 |
   | perf_cnt_avmm_cdc.m0 | performance_counter_0.control_slave | 0x0 |
   | bam_avmm_bridge.m0 | msi_to_gic_avmm_cdc.s0 | 0x2001_8000 |

 - Click on the bam_axi_bridge instance and click on the Domains tab.
	- Select bam_axi_bridge.m0
	- Under Interconnect Parameters in the Domain tab, set Burst adapter implementation to Per-burst type converter.
 - Click on System at the top left -> Show System with Platform Design Interconnect. In the Memory-Mapped Interconnect:
	-Select mm_interconnect_12 from the drop down and enable "Add all pipelines"
	-Close Window.
 - Move up hierarchy, Sync System Infos, and Generate HDL.
 - Edit <root_dir>/applications.fpga.soc.agilex5-ed-pcie-rp/src/hw/a5e065bb32aes1_pdk/src/sm_4x4/qsys_top/qsys_top_wrapper.sv with the following steps below.
	- Add the following logic declarations:
      ```
      logic pcie_subsys_0_msi_to_gic_avmm_cdc_m0_waitrequest, pcie_subsys_0_msi_to_gic_avmm_cdc_m0_write, 
         pcie_subsys_0_msi_to_gic_avmm_cdc_m0_read, pcie_subsys_0_msi_to_gic_avmm_cdc_m0_readdatavalid,
         pipeline_stages_m0_avmm_waitrequest, pipeline_stages_m0_avmm_readdatavalid, pipeline_stages_m0_avmm_write,
         pipeline_stages_m0_avmm_read, pcie_subsys_0_msi_to_gic_avmm_cdc_m0_burstcount, pipeline_stages_m0_avmm_burstcnt;
      logic [31:0] pcie_subsys_0_msi_to_gic_avmm_cdc_m0_readdata, pcie_subsys_0_msi_to_gic_avmm_cdc_m0_writedata,
        pipeline_stages_m0_avmm_readdata, pipeline_stages_m0_avmm_writedata;  
      logic [6:0] pcie_subsys_0_msi_to_gic_avmm_cdc_m0_address, pipeline_stages_m0_avmm_address;
      logic [3:0] pcie_subsys_0_msi_to_gic_avmm_cdc_m0_byteenable, pipeline_stages_m0_avmm_byteenable;
      ```
    - Instantiate the pipeline_stages module in qsys_top_wrapper:
      ```
      pipeline_stages #(
        .F2H_ADDR_WIDTH (7),
        .F2H_DATA_WIDTH (32), 
        .PIPE_STAGES    (1024)
        ) pipeline_stages_inst (
    	.clk                   (iopll_clk_100),
    	.rst_n                 (rst_n_100),
    						
    	.s0_avmm_write         (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_write),
        .s0_avmm_read          (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_read),
        .s0_avmm_address       (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_address),
        .s0_avmm_byteenable    (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_byteenable),
        .s0_avmm_writedata     (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_writedata),
        .s0_avmm_burstcnt      (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_burstcount),
        .s0_avmm_readdatavalid (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_readdatavalid),
        .s0_avmm_readdata      (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_readdata), 
        .s0_avmm_waitrequest   (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_waitrequest),
    
        .m0_avmm_write         (pipeline_stages_m0_avmm_write),
        .m0_avmm_read          (pipeline_stages_m0_avmm_read),
        .m0_avmm_address       (pipeline_stages_m0_avmm_address),
        .m0_avmm_byteenable    (pipeline_stages_m0_avmm_byteenable),
        .m0_avmm_writedata     (pipeline_stages_m0_avmm_writedata),
        .m0_avmm_burstcnt      (pipeline_stages_m0_avmm_burstcnt),
        .m0_avmm_readdatavalid (pipeline_stages_m0_avmm_readdatavalid),
        .m0_avmm_readdata      (pipeline_stages_m0_avmm_readdata),
        .m0_avmm_waitrequest   (pipeline_stages_m0_avmm_waitrequest) );
      ```
    - Add the following connections to the qsys_top (soc_inst) instance:
      ```
      // connect to pipeline_stages input interface
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_waitrequest   (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_waitrequest),
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_readdata      (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_readdata),
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_readdatavalid (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_readdatavalid),
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_burstcount    (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_burstcount), 
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_writedata     (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_writedata),
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_address       (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_address),
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_write         (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_write),
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_read          (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_read),
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_byteenable    (pcie_subsys_0_msi_to_gic_avmm_cdc_m0_byteenable), 
      .pcie_subsys_0_msi_to_gic_avmm_cdc_m0_debugaccess   (), // unused
      
      // connect to pipeline_stages output interface
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_waitrequest   (pipeline_stages_m0_avmm_waitrequest),
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_readdata      (pipeline_stages_m0_avmm_readdata),
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_readdatavalid (pipeline_stages_m0_avmm_readdatavalid),
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_burstcount    (pipeline_stages_m0_avmm_burstcnt),
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_writedata     (pipeline_stages_m0_avmm_writedata),
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_address       (pipeline_stages_m0_avmm_address),
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_write         (pipeline_stages_m0_avmm_write),
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_read          (pipeline_stages_m0_avmm_read),
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_byteenable    (pipeline_stages_m0_avmm_byteenable),
      .pcie_subsys_0_ready_latency_msi_to_gic_avmm_bridge_s0_debugaccess   (1'h0),
      // drive unused ports
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_s0_burstcount ('0),
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_s0_writedata ('0),
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_s0_address ('0),
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_s0_write ('0),
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_s0_read ('0),
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_s0_byteenable ('0),
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_s0_debugaccess ('0),
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_m0_waitrequest ('0),
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_m0_readdata ('0),
      .pcie_subsys_0_msi_to_gic_vector_avmm_cdc_m0_readdatavalid ('0),
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_s0_burstcount('0),    
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_s0_writedata('0),     
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_s0_address('0),       
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_s0_write('0),         
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_s0_read('0),          
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_s0_byteenable('0),    
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_s0_debugaccess('0),   
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_m0_waitrequest('0),   
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_m0_readdata('0),      
      .pcie_subsys_0_msi_to_gic_csr_avmm_cdc_m0_readdatavalid('0),
      ```
    - Compile Quartus project.



