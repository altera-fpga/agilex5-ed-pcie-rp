//************************************************************************************************
// Copyright (C) 2025 - 2025 Altera Corporation
//
// This code and the related documents are Altera copyrighted materials and your use 
// of them is governed by the express license under which they were provided to you ("License"). 
// This code and the related documents are provided as is, with no express or implied 
// warranties other than those that are expressly stated in the License.
//***********************************************************************************************

/**
 * Abstract:
 * Top-level PCIE device SerDes interface SystemVerilog testbench.
 * It instantiates PCIE Device models and the interconnect wrapper for SerDes 
 * interface.  Clock generation is also  done in the same file.  It includes 
 * each test file and initiates the UVM phase manager by calling run_test().
 */

`timescale 1 ns/1 fs

`include "svt_axi.uvm.pkg"
`include "uvm_pkg.sv"
`include "svt_pcie.uvm.pkg"

/** Defines required for PCIE SVC */
`define EXPERTIO_PCIESVC_GLOBAL_SHADOW_PATH  sysrp_top_tb.global_shadow0
`define SVC_RANDOM_SEED_SCOPE                sysrp_top_tb.global_random_seed 

//=======================================================================
module sysrp_top_tb;

  timeunit 1ns;
  timeprecision 1fs;
  parameter simulation_cycle_100mhz  = 10;
  parameter simulation_cycle_1000mhz = 1;
  parameter simulation_cycle_250mhz  = 4;
  integer random_delay;

  /** Import UVM Package */
   import uvm_pkg::*;
  `include "uvm_macros.svh"
  import svt_uvm_pkg::*;
  import svt_axi_uvm_pkg::*;

  /** Include PCIE VIP UVM Packages */
  `include "import_pcie_svt_uvm_pkgs.svi"

  /** Include Util parms */
  `include "svc_util_parms.v"

  /** Include the PCIE Device basic ENV */
  `include "sysrp_pcie_device_basic_env.sv"
  `include "sysrp_sequence_lib.svh"
  `include "sysrp_test_package.sv"

  /** Signal to generate the reset */
  bit reset,clk_100mhz,clk_250mhz,clk_1000mhz,ninit_done,pin_perst_reset,ptile_rst_src;
  bit[3:0] tb_pin_perst_reset;
  int bam_finish_from_top_tb;
  int bas_finish_from_top_tb;

  /** PCIE Device instantiation model showing interface / wiring between 2 PCIE Devices */
  `include "sysrp_svt_pcie_device_serdes_x16.sv"
  svt_axi_if axi_lw_if();
  svt_axi_if axi_if();

  /** Global random seed */
  int unsigned global_random_seed;

  sysrp_h2f_axi_lw_bfm h2f_axi_lw_bfm_INST(axi_lw_if);
  sysrp_h2f_axi_bfm h2f_axi_bfm_INST(axi_if);

  // -----------------------------------------------------------------------------
  /** Instantiate Global Memory Shadow */
  // -----------------------------------------------------------------------------
  pciesvc_global_shadow #( .DISPLAY_NAME( "global_shadow0." ) ) global_shadow0();

  // -----------------------------------------------------------------------------
  /** Set up the Global random seed */
  // -----------------------------------------------------------------------------
  `ifndef SVC_RANDOM_BY_THREAD
    initial
      begin : L_RandSeed
  `ifdef SVC_RANDOM_SEED
        global_random_seed = `SVC_RANDOM_SEED ;
  `else
        global_random_seed = 0;
  `endif
      `uvm_info("top_test",$psprintf("Global random seed being set to %0d", global_random_seed), UVM_LOW);
    end
  `endif

  // -----------------------------------------------------------------------------
  /** Optionally dump the sim variable for waveform display */
  // -----------------------------------------------------------------------------

/*   `ifdef WAVES_FSDB
   initial begin
      $fsdbDumpfile("sysrp_top_tb");
      $fsdbDumpvars;
   end
   `elsif WAVES_VCD
   initial begin
      $dumpvars;
   end
   `elsif WAVES
   initial begin
      $vcdpluson;
      $vcdplusmemon;
   end
   `endif
*/

 `ifdef DUMP
   initial begin
      `uvm_info("top_test",$psprintf("VPD will be created as DUMP=1 is passed"), UVM_LOW);
      $vcdpluson;
      $vcdplusmemon;
   end
 `endif

 /** Testbench 100mhz Clock Generator */
  initial begin
    clk_100mhz = 0 ;
    forever begin
      #(simulation_cycle_100mhz/2)
        clk_100mhz = ~clk_100mhz ;
    end
  end

 /** Testbench 250mhz Clock Generator */
  initial begin
    clk_250mhz = 0 ;
    forever begin
      #(simulation_cycle_250mhz/2)
        clk_250mhz = ~clk_250mhz ;
    end
  end

/** Testbench 1000mhz Clock Generator */
  initial begin
    clk_1000mhz = 0 ;
    forever begin
      //#(simulation_cycle_1000mhz/2)
      #500ps clk_1000mhz = ~clk_1000mhz ;
    end
  end

  initial begin
    ninit_done = 1'b1;
    #40us;
    ninit_done = 1'b0;
  end

   initial begin
    ptile_rst_src=1'b1; #210ns; 
    ptile_rst_src=1'b0; #800ns;
    ptile_rst_src=1'b1;
    random_delay=$urandom_range(1000,5000);
  end

  assign tb_pin_perst_reset = 4'hF;
  assign pin_perst_reset = ptile_rst_src & (&tb_pin_perst_reset);

  // -----------------------------------------------------------------------------
  /**
   *  Setup the reset.
   */
  // -----------------------------------------------------------------------------
  initial begin
    $timeformat(-12,2, " ps", 8);
    sysrp_top_tb.reset = 1;
    #1us;
    sysrp_top_tb.reset = 0;
  end

  // -----------------------------------------------------------------------------
  /** UVM test phase initiator */
  // -----------------------------------------------------------------------------
  initial begin
     uvm_config_db#(svt_axi_vif)::set(uvm_root::get(), "uvm_test_top.env.axi_system_env", "vif", axi_lw_if);
     uvm_config_db#(svt_axi_vif)::set(uvm_root::get(), "uvm_test_top.env.axi_h2f_system_env", "vif", axi_if);
     run_test();
  end

   `define SM_DWC_CORE sysrp_top_tb.PCIE_RP_DUT.soc_inst.pcie_subsys_0.intel_pcie_gts.intel_pcie_gts_0.gen_sm_qhip.u_sm_qhip.sm_pcie_hal_top_inst.pcie_hal_top.pcie_phip_hal_ctrltop_x4.pcie_phip_hal_ctrltop.phip_pcie_ctrltop_x4.sf_rtl_ncrypt_inst.sf_rtl_inst.u_core4
  
  initial begin
    wait(sysrp_top_tb.reset==0);
    uvm_config_db #(int)::get(null, "", "bam_finish_from_top_tb", bam_finish_from_top_tb);
    uvm_config_db #(int)::get(null, "", "bas_finish_from_top_tb", bas_finish_from_top_tb);
    `uvm_info("body", $sformatf("bam_finish_from_top_tb = %d bas_finish_from_top_tb = %d", bam_finish_from_top_tb,bas_finish_from_top_tb), UVM_LOW); 

    force `SM_DWC_CORE.u_ip.u_dwc.u_DWC_pcie_core.u_cdm.u_cdm_pl_reg.pl_reg_27[6:5] = 2'b00;
    force `SM_DWC_CORE.u_ip.u_dwc.diag_ctrl_bus[2] = 1'b1;
    force `SM_DWC_CORE.u_ip.u_dwc.u_DWC_pcie_core.u_cx_pl.u_smlh.u_smlh_ltssm.cfg_gen3_eq_phase23_disable = 1'b1;
    force `SM_DWC_CORE.u_ip.u_dwc.u_DWC_pcie_core.u_cx_pl.u_smlh.u_smlh_ltssm.cfg_gen4_eq_phase23_disable = 1'b1;

  end 

endmodule : sysrp_top_tb
