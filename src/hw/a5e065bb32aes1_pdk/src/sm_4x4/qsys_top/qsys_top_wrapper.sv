//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2021 Intel Corporation.
//
//****************************************************************************

module qsys_top_wrapper (
`ifdef SM_RP_SIM_ENABLE
// cache_coherency_translator interface
output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_wuser,
output wire   [10:0] altera_ace5lite_cache_coherency_translator_0_m0_awstashnid,
output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arsnoop,
output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awsnoop,
output wire   [31:0] altera_ace5lite_cache_coherency_translator_0_m0_wstrb,
input  wire          altera_ace5lite_cache_coherency_translator_0_m0_wready,
input  wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_rid,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_rready,
output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_awlen,
output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awqos,
output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arcache,
output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_arprot,
output wire  [255:0] altera_ace5lite_cache_coherency_translator_0_m0_wdata,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_arvalid,
output wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_arid,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_arlock,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_awlock,
input wire    [1:0]  altera_ace5lite_cache_coherency_translator_0_m0_bresp,
input wire           altera_ace5lite_cache_coherency_translator_0_m0_arready,
output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_arsize,
output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_awdomain,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_bready,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_wlast,
output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awregion,
input wire    [7:0]  altera_ace5lite_cache_coherency_translator_0_m0_buser,
input wire    [1:0]  altera_ace5lite_cache_coherency_translator_0_m0_rresp,
input wire           altera_ace5lite_cache_coherency_translator_0_m0_bvalid,
input wire    [7:0]  altera_ace5lite_cache_coherency_translator_0_m0_ruser,
output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_awburst,
output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arregion,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_awstashlpiden,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_awstashniden,
output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_arlen,
output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arqos,
output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_awuser,
output wire    [5:0] altera_ace5lite_cache_coherency_translator_0_m0_awatop,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_wvalid,
output wire   [35:0] altera_ace5lite_cache_coherency_translator_0_m0_araddr,
output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_awprot,
output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awcache,
output wire   [35:0] altera_ace5lite_cache_coherency_translator_0_m0_awaddr,
output wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_awstashlpid,
input wire  [255:0]  altera_ace5lite_cache_coherency_translator_0_m0_rdata,
input wire           altera_ace5lite_cache_coherency_translator_0_m0_awready,
output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_arburst,
input wire           altera_ace5lite_cache_coherency_translator_0_m0_rlast,
output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_ardomain,
output wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_awid,
input wire    [4:0]  altera_ace5lite_cache_coherency_translator_0_m0_bid,
output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_awsize,
output wire          altera_ace5lite_cache_coherency_translator_0_m0_awvalid,
input wire           altera_ace5lite_cache_coherency_translator_0_m0_rvalid,
output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_aruser,

//  hps2fpga interface
input wire    [1:0]  subsys_hps_hps2fpga_awburst,
input wire    [7:0]  subsys_hps_hps2fpga_arlen,
input wire   [15:0]  subsys_hps_hps2fpga_wstrb,
output wire          subsys_hps_hps2fpga_wready,
output wire    [3:0] subsys_hps_hps2fpga_rid,
input wire           subsys_hps_hps2fpga_rready,
input wire    [7:0]  subsys_hps_hps2fpga_awlen,
input wire    [3:0]  subsys_hps_hps2fpga_arcache,
input wire           subsys_hps_hps2fpga_wvalid,
input wire   [37:0]  subsys_hps_hps2fpga_araddr,
input wire    [2:0]  subsys_hps_hps2fpga_arprot,
input wire    [2:0]  subsys_hps_hps2fpga_awprot,
input wire  [127:0]  subsys_hps_hps2fpga_wdata,
input wire           subsys_hps_hps2fpga_arvalid,
input wire    [3:0]  subsys_hps_hps2fpga_awcache,
input wire    [3:0]  subsys_hps_hps2fpga_arid,
input wire           subsys_hps_hps2fpga_arlock,
input wire           subsys_hps_hps2fpga_awlock,
input wire   [37:0]  subsys_hps_hps2fpga_awaddr,
output wire    [1:0] subsys_hps_hps2fpga_bresp,
output wire          subsys_hps_hps2fpga_arready,
output wire  [127:0] subsys_hps_hps2fpga_rdata,
output wire          subsys_hps_hps2fpga_awready,
input wire    [1:0]  subsys_hps_hps2fpga_arburst,
input wire    [2:0]  subsys_hps_hps2fpga_arsize,
input wire           subsys_hps_hps2fpga_bready,
output wire          subsys_hps_hps2fpga_rlast,
input wire           subsys_hps_hps2fpga_wlast,
output wire    [1:0] subsys_hps_hps2fpga_rresp,
input wire    [3:0]  subsys_hps_hps2fpga_awid,
output wire    [3:0] subsys_hps_hps2fpga_bid,
output wire          subsys_hps_hps2fpga_bvalid,
input wire    [2:0]  subsys_hps_hps2fpga_awsize,
input wire           subsys_hps_hps2fpga_awvalid,
output wire          subsys_hps_hps2fpga_rvalid,

// lwhps2fpga interface
input wire    [1:0]  subsys_hps_lwhps2fpga_awburst,
input wire    [7:0]  subsys_hps_lwhps2fpga_arlen,
input wire    [3:0]  subsys_hps_lwhps2fpga_wstrb,
output wire          subsys_hps_lwhps2fpga_wready,
output wire    [3:0] subsys_hps_lwhps2fpga_rid,
input wire           subsys_hps_lwhps2fpga_rready,
input wire    [7:0]  subsys_hps_lwhps2fpga_awlen,
input wire    [3:0]  subsys_hps_lwhps2fpga_arcache,
input wire           subsys_hps_lwhps2fpga_wvalid,
input wire   [28:0]  subsys_hps_lwhps2fpga_araddr,
input wire    [2:0]  subsys_hps_lwhps2fpga_arprot,
input wire    [2:0]  subsys_hps_lwhps2fpga_awprot,
input wire   [31:0]  subsys_hps_lwhps2fpga_wdata,
input wire           subsys_hps_lwhps2fpga_arvalid,
input wire    [3:0]  subsys_hps_lwhps2fpga_awcache,
input wire    [3:0]  subsys_hps_lwhps2fpga_arid,
input wire           subsys_hps_lwhps2fpga_arlock,
input wire           subsys_hps_lwhps2fpga_awlock,
input wire   [28:0]  subsys_hps_lwhps2fpga_awaddr,
output wire    [1:0] subsys_hps_lwhps2fpga_bresp,
output wire          subsys_hps_lwhps2fpga_arready,
output wire   [31:0] subsys_hps_lwhps2fpga_rdata,
output wire          subsys_hps_lwhps2fpga_awready,
input wire    [1:0]  subsys_hps_lwhps2fpga_arburst,
input wire    [2:0]  subsys_hps_lwhps2fpga_arsize,
input wire           subsys_hps_lwhps2fpga_bready,
output wire          subsys_hps_lwhps2fpga_rlast,
input wire           subsys_hps_lwhps2fpga_wlast,
output wire    [1:0] subsys_hps_lwhps2fpga_rresp,
input wire    [3:0]  subsys_hps_lwhps2fpga_awid,
output wire    [3:0] subsys_hps_lwhps2fpga_bid,
output wire          subsys_hps_lwhps2fpga_bvalid,
input wire    [2:0]  subsys_hps_lwhps2fpga_awsize,
input wire           subsys_hps_lwhps2fpga_awvalid,
output wire          subsys_hps_lwhps2fpga_rvalid,

// subsys_hps_f2h_irq0 interface
output logic    [31:0]  subsys_hps_f2h_irq0_in_irq,
`endif

output   wire          h2f_reset,
output   wire          ninit_done,

output   wire          emif_hps_emif_mem_0_mem_ck_t, 
output   wire          emif_hps_emif_mem_0_mem_ck_c, 
output   wire [16:0]   emif_hps_emif_mem_0_mem_a, 
output   wire          emif_hps_emif_mem_0_mem_act_n,
output   wire [1:0]    emif_hps_emif_mem_0_mem_ba, 
output   wire [1:0]    emif_hps_emif_mem_0_mem_bg, 
output   wire          emif_hps_emif_mem_0_mem_cke,
output   wire          emif_hps_emif_mem_0_mem_cs_n,
output   wire          emif_hps_emif_mem_0_mem_odt,
output   wire          emif_hps_emif_mem_0_mem_reset_n,
output   wire          emif_hps_emif_mem_0_mem_par,
input    wire          emif_hps_emif_mem_0_mem_alert_n,
input    wire          emif_hps_emif_oct_0_oct_rzqin,
input    wire          emif_hps_emif_ref_clk_0_clk,
inout    wire [3:0]    emif_hps_emif_mem_0_mem_dqs_t,
inout    wire [3:0]    emif_hps_emif_mem_0_mem_dqs_c,
inout    wire [31:0]   emif_hps_emif_mem_0_mem_dq,
input    wire          hps_jtag_tck,
input    wire          hps_jtag_tms,
output   wire          hps_jtag_tdo,
input    wire          hps_jtag_tdi,
output   wire          hps_sdmmc_CCLK, 
inout    wire          hps_sdmmc_CMD,          
inout    wire          hps_sdmmc_D0,          
inout    wire          hps_sdmmc_D1,          
inout    wire          hps_sdmmc_D2,        
inout    wire          hps_sdmmc_D3,        
input    wire          hps_sdmmc_WPROT,

input    wire          usb31_io_vbus_det,                  
input    wire          usb31_io_flt_bar,                   
output   wire [1:0]    usb31_io_usb_ctrl,
input    wire          usb31_io_usb31_id,                  
input    wire          usb31_phy_refclk_p_clk,             
//input    wire          usb31_phy_refclk_p_clk(n),             
input    wire          usb31_phy_rx_serial_n_i_rx_serial_n,
input    wire          usb31_phy_rx_serial_p_i_rx_serial_p,
output   wire          usb31_phy_tx_serial_n_o_tx_serial_n,
output   wire          usb31_phy_tx_serial_p_o_tx_serial_p,
inout    wire          hps_usb1_DATA0,         
inout    wire          hps_usb1_DATA1,      
inout    wire          hps_usb1_DATA2,        
inout    wire          hps_usb1_DATA3,       
inout    wire          hps_usb1_DATA4,        
inout    wire          hps_usb1_DATA5,      
inout    wire          hps_usb1_DATA6,      
inout    wire          hps_usb1_DATA7,         
input    wire          hps_usb1_CLK,         
output   wire          hps_usb1_STP,       
input    wire          hps_usb1_DIR,        
input    wire          hps_usb1_NXT, 
output   wire          hps_emac2_TX_CLK,       
input    wire          hps_emac2_RX_CLK,      
output   wire          hps_emac2_TX_CTL,
input    wire          hps_emac2_RX_CTL,      
output   wire          hps_emac2_TXD0,       
output   wire          hps_emac2_TXD1,
input    wire          hps_emac2_RXD0,     
input    wire          hps_emac2_RXD1, 
output   wire          hps_emac2_PPS,    
input    wire          hps_emac2_PPS_TRIG,
output   wire          hps_emac2_TXD2,        
output   wire          hps_emac2_TXD3,
input    wire          hps_emac2_RXD2,        
input    wire          hps_emac2_RXD3,
inout    wire          hps_emac2_MDIO,         
output   wire          hps_emac2_MDC,
input    wire          hps_uart0_RX,       
output   wire          hps_uart0_TX, 
inout    wire          hps_i3c1_SDA,        
inout    wire          hps_i3c1_SCL, 
inout    wire          hps_gpio0_io0,
inout    wire          hps_gpio0_io1,
inout    wire          hps_gpio0_io11,
inout    wire          hps_gpio1_io3,
input    wire          hps_osc_clk,
// input    wire          fpga_reset_n,

input    wire          pin_perst_n,
input    wire          pin_perst_n_1,
// input    wire          pcie_refclk,
input    wire          gts_refclk,

input    wire          hip_serial_rx_n_in0, 
input    wire          hip_serial_rx_n_in1, 
input    wire          hip_serial_rx_n_in2, 
input    wire          hip_serial_rx_n_in3, 
input    wire          hip_serial_rx_p_in0, 
input    wire          hip_serial_rx_p_in1, 
input    wire          hip_serial_rx_p_in2, 
input    wire          hip_serial_rx_p_in3, 
output   wire          hip_serial_tx_n_out0,
output   wire          hip_serial_tx_n_out1,
output   wire          hip_serial_tx_n_out2,
output   wire          hip_serial_tx_n_out3,
output   wire          hip_serial_tx_p_out0,
output   wire          hip_serial_tx_p_out1,
output   wire          hip_serial_tx_p_out2,
output   wire          hip_serial_tx_p_out3,

input    wire          system_reset,
input    wire          system_clk_100,

output   wire          iopll_clk_250,
output   wire          iopll_clk_100

);

logic pcie_subsys_0_intel_pcie_gts_p0_reset_status_n_reset_n, pcie_ss_rst_n, rst_n_100, rst_250,
  usb_gts_rst_o_pma_cu_clk_clk, pcie_gts_rst_o_pma_cu_clk_clk, syspll_inst_o_pll_lock_o_pll_lock, 
  syspll_inst_o_syspll_c0_clk, system_clk_250, hip_status_dl_up, 
  hip_status_suprise_down_err, hip_status_link_up, hip_irq_int_status, h2f_warm_reset_handshake_reset_req, 
  h2f_warm_reset_handshake_reset_ack, pll_locked, csr_axi_st_rst, csr_axi_lite_rst,
  coreclk_out, gts_p0_subsystem_warm_rst_ack_n_subsystem_warm_rst_ack_n,
  gts_p0_subsystem_cold_rst_ack_n_subsystem_cold_rst_ack_n, gts_p0_initiate_warmrst_req_initiate_warmrst_req,
  gts_p0_initiate_rst_req_rdy_initiate_rst_req_rdy, rx_st_tvalid, rx_st_tready, rx_st_tlast,
  pcie_subsys_0_msi_to_gic_interrupt_sender_irq, hip_irq_int_status_reg, pcie_subsys_0_msi_to_gic_interrupt_sender_irq_reg,
  all_one_cnt, all_one_cnt_sync, hip_irq_int_status_clk_100, pcie_subsys_0_msi_to_gic_interrupt_sender_irq_clk_100,
  pll_locked_rst_100, pll_locked_rst_250, pcie_subsys_0_msi_to_gic_interrupt_sender_irq_c1;
wire [5:0]   hip_status_ltssm_state;

wire [255:0] rx_st_tdata;
wire [31:0] rx_st_tkeep;
logic [31:0] sender_irq;

always_ff @(posedge iopll_clk_250) begin
  pcie_subsys_0_msi_to_gic_interrupt_sender_irq_c1 <= pcie_subsys_0_msi_to_gic_interrupt_sender_irq;
end

altera_std_synchronizer_nocut #(
   .depth (3)
  ,.rst_value (0)
 ) pcie_subsys_0_msi_to_gic_interrupt_sender_irq_synchronizer (
   .clk     (iopll_clk_100)
  ,.reset_n (rst_n_100)
  ,.din     (pcie_subsys_0_msi_to_gic_interrupt_sender_irq_c1)
  ,.dout    (pcie_subsys_0_msi_to_gic_interrupt_sender_irq_clk_100)
 );

altera_std_synchronizer_nocut #(
   .depth (3)
  ,.rst_value (0)
 ) hip_irq_int_status_synchronizer (
   .clk     (iopll_clk_100)
  ,.reset_n (rst_n_100)
  ,.din     (hip_irq_int_status)
  ,.dout    (hip_irq_int_status_clk_100)
 );

always_comb begin
  sender_irq = '0;
  // sender_irq[2] = pcie_subsys_0_msi_to_gic_interrupt_sender_irq;
  sender_irq[2] = pcie_subsys_0_msi_to_gic_interrupt_sender_irq_clk_100;
  // sender_irq[3] = hip_irq_int_status;
  sender_irq[3] = hip_irq_int_status_clk_100;

  `ifdef SM_RP_SIM_ENABLE
    subsys_hps_f2h_irq0_in_irq = sender_irq; // output to TB
  `endif
end

rst_ctrl rst_ctrl_0 (
     // inputs
	.clk_sys              (coreclk_out),                       
	.clk_100m             (iopll_clk_100),                                       
	.pcie_reset_status    (~pcie_subsys_0_intel_pcie_gts_p0_reset_status_n_reset_n), 
	.pcie_cold_rst_ack_n  (gts_p0_subsystem_cold_rst_ack_n_subsystem_cold_rst_ack_n), 
	.pcie_warm_rst_ack_n  (gts_p0_subsystem_warm_rst_ack_n_subsystem_warm_rst_ack_n), 
	.pll_locked_i         (pll_locked),
	.initiate_warmrst_req (gts_p0_initiate_warmrst_req_initiate_warmrst_req),         
	.ninit_done           (ninit_done),                                

     // outputs
	.initiate_rst_req_rdy (gts_p0_initiate_rst_req_rdy_initiate_rst_req_rdy),    
	.rst_n_sys            (pcie_ss_rst_n),                               
	.rst_n_100m           (rst_n_100),                              
	.pwr_good_n           (),                                       
	.pcie_cold_rst_n      (),                                       
	.pcie_warm_rst_n      (),                                       
    .csr_axi_st_rst       (csr_axi_st_rst),      // csr soft rst (bypass reset handshakes)
    .csr_axi_lite_rst     (csr_axi_lite_rst)    // csr soft rst (bypass reset handshakes)
);

altera_reset_synchronizer #(
    .ASYNC_RESET (1),
    .DEPTH       (3)
) rst_250_sync (
    .reset_in  (~pcie_ss_rst_n),
    .clk       (iopll_clk_250),
    .reset_out (rst_250)
);

altera_reset_synchronizer #(
    .ASYNC_RESET (1),
    .DEPTH       (3)
) pll_lock_100_sync (
    .reset_in  (~pll_locked),
    .clk       (iopll_clk_100),
    .reset_out (pll_locked_rst_100)
);

altera_reset_synchronizer #(
    .ASYNC_RESET (1),
    .DEPTH       (3)
) pll_lock_250_sync (
    .reset_in  (~pll_locked),
    .clk       (iopll_clk_250),
    .reset_out (pll_locked_rst_250)
);

qsys_top soc_inst (
`ifdef SM_RP_SIM_ENABLE
// cache_coherency_translator interface
.altera_ace5lite_cache_coherency_translator_0_m0_wuser         (altera_ace5lite_cache_coherency_translator_0_m0_wuser        ),
.altera_ace5lite_cache_coherency_translator_0_m0_awstashnid    (altera_ace5lite_cache_coherency_translator_0_m0_awstashnid   ),
.altera_ace5lite_cache_coherency_translator_0_m0_arsnoop       (altera_ace5lite_cache_coherency_translator_0_m0_arsnoop      ),
.altera_ace5lite_cache_coherency_translator_0_m0_awsnoop       (altera_ace5lite_cache_coherency_translator_0_m0_awsnoop      ),
.altera_ace5lite_cache_coherency_translator_0_m0_wstrb         (altera_ace5lite_cache_coherency_translator_0_m0_wstrb        ),
.altera_ace5lite_cache_coherency_translator_0_m0_wready        (altera_ace5lite_cache_coherency_translator_0_m0_wready       ),
.altera_ace5lite_cache_coherency_translator_0_m0_rid           (altera_ace5lite_cache_coherency_translator_0_m0_rid          ),
.altera_ace5lite_cache_coherency_translator_0_m0_rready        (altera_ace5lite_cache_coherency_translator_0_m0_rready       ),
.altera_ace5lite_cache_coherency_translator_0_m0_awlen         (altera_ace5lite_cache_coherency_translator_0_m0_awlen        ),
.altera_ace5lite_cache_coherency_translator_0_m0_awqos         (altera_ace5lite_cache_coherency_translator_0_m0_awqos        ),
.altera_ace5lite_cache_coherency_translator_0_m0_arcache       (altera_ace5lite_cache_coherency_translator_0_m0_arcache      ),
.altera_ace5lite_cache_coherency_translator_0_m0_arprot        (altera_ace5lite_cache_coherency_translator_0_m0_arprot       ),
.altera_ace5lite_cache_coherency_translator_0_m0_wdata         (altera_ace5lite_cache_coherency_translator_0_m0_wdata        ),
.altera_ace5lite_cache_coherency_translator_0_m0_arvalid       (altera_ace5lite_cache_coherency_translator_0_m0_arvalid      ),
.altera_ace5lite_cache_coherency_translator_0_m0_arid          (altera_ace5lite_cache_coherency_translator_0_m0_arid         ),
.altera_ace5lite_cache_coherency_translator_0_m0_arlock        (altera_ace5lite_cache_coherency_translator_0_m0_arlock       ),
.altera_ace5lite_cache_coherency_translator_0_m0_awlock        (altera_ace5lite_cache_coherency_translator_0_m0_awlock       ),
.altera_ace5lite_cache_coherency_translator_0_m0_bresp         (altera_ace5lite_cache_coherency_translator_0_m0_bresp        ),
.altera_ace5lite_cache_coherency_translator_0_m0_arready       (altera_ace5lite_cache_coherency_translator_0_m0_arready      ),
.altera_ace5lite_cache_coherency_translator_0_m0_arsize        (altera_ace5lite_cache_coherency_translator_0_m0_arsize       ),
.altera_ace5lite_cache_coherency_translator_0_m0_awdomain      (altera_ace5lite_cache_coherency_translator_0_m0_awdomain     ),
.altera_ace5lite_cache_coherency_translator_0_m0_bready        (altera_ace5lite_cache_coherency_translator_0_m0_bready       ),
.altera_ace5lite_cache_coherency_translator_0_m0_wlast         (altera_ace5lite_cache_coherency_translator_0_m0_wlast        ),
.altera_ace5lite_cache_coherency_translator_0_m0_awregion      (altera_ace5lite_cache_coherency_translator_0_m0_awregion     ),
.altera_ace5lite_cache_coherency_translator_0_m0_buser         (altera_ace5lite_cache_coherency_translator_0_m0_buser        ),
.altera_ace5lite_cache_coherency_translator_0_m0_rresp         (altera_ace5lite_cache_coherency_translator_0_m0_rresp        ),
.altera_ace5lite_cache_coherency_translator_0_m0_bvalid        (altera_ace5lite_cache_coherency_translator_0_m0_bvalid       ),
.altera_ace5lite_cache_coherency_translator_0_m0_ruser         (altera_ace5lite_cache_coherency_translator_0_m0_ruser        ),
.altera_ace5lite_cache_coherency_translator_0_m0_awburst       (altera_ace5lite_cache_coherency_translator_0_m0_awburst      ),
.altera_ace5lite_cache_coherency_translator_0_m0_arregion      (altera_ace5lite_cache_coherency_translator_0_m0_arregion     ),
.altera_ace5lite_cache_coherency_translator_0_m0_awstashlpiden (altera_ace5lite_cache_coherency_translator_0_m0_awstashlpiden),
.altera_ace5lite_cache_coherency_translator_0_m0_awstashniden  (altera_ace5lite_cache_coherency_translator_0_m0_awstashniden ),
.altera_ace5lite_cache_coherency_translator_0_m0_arlen         (altera_ace5lite_cache_coherency_translator_0_m0_arlen        ),
.altera_ace5lite_cache_coherency_translator_0_m0_arqos         (altera_ace5lite_cache_coherency_translator_0_m0_arqos        ),
.altera_ace5lite_cache_coherency_translator_0_m0_awuser        (altera_ace5lite_cache_coherency_translator_0_m0_awuser       ),
.altera_ace5lite_cache_coherency_translator_0_m0_awatop        (altera_ace5lite_cache_coherency_translator_0_m0_awatop       ),
.altera_ace5lite_cache_coherency_translator_0_m0_wvalid        (altera_ace5lite_cache_coherency_translator_0_m0_wvalid       ),
.altera_ace5lite_cache_coherency_translator_0_m0_araddr        (altera_ace5lite_cache_coherency_translator_0_m0_araddr       ),
.altera_ace5lite_cache_coherency_translator_0_m0_awprot        (altera_ace5lite_cache_coherency_translator_0_m0_awprot       ),
.altera_ace5lite_cache_coherency_translator_0_m0_awcache       (altera_ace5lite_cache_coherency_translator_0_m0_awcache      ),
.altera_ace5lite_cache_coherency_translator_0_m0_awaddr        (altera_ace5lite_cache_coherency_translator_0_m0_awaddr       ),
.altera_ace5lite_cache_coherency_translator_0_m0_awstashlpid   (altera_ace5lite_cache_coherency_translator_0_m0_awstashlpid  ),
.altera_ace5lite_cache_coherency_translator_0_m0_rdata         (altera_ace5lite_cache_coherency_translator_0_m0_rdata        ),
.altera_ace5lite_cache_coherency_translator_0_m0_awready       (altera_ace5lite_cache_coherency_translator_0_m0_awready      ),
.altera_ace5lite_cache_coherency_translator_0_m0_arburst       (altera_ace5lite_cache_coherency_translator_0_m0_arburst      ),
.altera_ace5lite_cache_coherency_translator_0_m0_rlast         (altera_ace5lite_cache_coherency_translator_0_m0_rlast        ),
.altera_ace5lite_cache_coherency_translator_0_m0_ardomain      (altera_ace5lite_cache_coherency_translator_0_m0_ardomain     ),
.altera_ace5lite_cache_coherency_translator_0_m0_awid          (altera_ace5lite_cache_coherency_translator_0_m0_awid         ),
.altera_ace5lite_cache_coherency_translator_0_m0_bid           (altera_ace5lite_cache_coherency_translator_0_m0_bid          ),
.altera_ace5lite_cache_coherency_translator_0_m0_awsize        (altera_ace5lite_cache_coherency_translator_0_m0_awsize       ),
.altera_ace5lite_cache_coherency_translator_0_m0_awvalid       (altera_ace5lite_cache_coherency_translator_0_m0_awvalid      ),
.altera_ace5lite_cache_coherency_translator_0_m0_rvalid        (altera_ace5lite_cache_coherency_translator_0_m0_rvalid       ),
.altera_ace5lite_cache_coherency_translator_0_m0_aruser        (altera_ace5lite_cache_coherency_translator_0_m0_aruser       ),

//  hps2fpga interface
.subsys_hps_hps2fpga_awburst (subsys_hps_hps2fpga_awburst),
.subsys_hps_hps2fpga_arlen   (subsys_hps_hps2fpga_arlen  ),
.subsys_hps_hps2fpga_wstrb   (subsys_hps_hps2fpga_wstrb  ),
.subsys_hps_hps2fpga_wready  (subsys_hps_hps2fpga_wready ),
.subsys_hps_hps2fpga_rid     (subsys_hps_hps2fpga_rid    ),
.subsys_hps_hps2fpga_rready  (subsys_hps_hps2fpga_rready ),
.subsys_hps_hps2fpga_awlen   (subsys_hps_hps2fpga_awlen  ),
.subsys_hps_hps2fpga_arcache (subsys_hps_hps2fpga_arcache),
.subsys_hps_hps2fpga_wvalid  (subsys_hps_hps2fpga_wvalid ),
.subsys_hps_hps2fpga_araddr  (subsys_hps_hps2fpga_araddr ),
.subsys_hps_hps2fpga_arprot  (subsys_hps_hps2fpga_arprot ),
.subsys_hps_hps2fpga_awprot  (subsys_hps_hps2fpga_awprot ),
.subsys_hps_hps2fpga_wdata   (subsys_hps_hps2fpga_wdata  ),
.subsys_hps_hps2fpga_arvalid (subsys_hps_hps2fpga_arvalid),
.subsys_hps_hps2fpga_awcache (subsys_hps_hps2fpga_awcache),
.subsys_hps_hps2fpga_arid    (subsys_hps_hps2fpga_arid   ),
.subsys_hps_hps2fpga_arlock  (subsys_hps_hps2fpga_arlock ),
.subsys_hps_hps2fpga_awlock  (subsys_hps_hps2fpga_awlock ),
.subsys_hps_hps2fpga_awaddr  (subsys_hps_hps2fpga_awaddr ),
.subsys_hps_hps2fpga_bresp   (subsys_hps_hps2fpga_bresp  ),
.subsys_hps_hps2fpga_arready (subsys_hps_hps2fpga_arready),
.subsys_hps_hps2fpga_rdata   (subsys_hps_hps2fpga_rdata  ),
.subsys_hps_hps2fpga_awready (subsys_hps_hps2fpga_awready),
.subsys_hps_hps2fpga_arburst (subsys_hps_hps2fpga_arburst),
.subsys_hps_hps2fpga_arsize  (subsys_hps_hps2fpga_arsize ),
.subsys_hps_hps2fpga_bready  (subsys_hps_hps2fpga_bready ),
.subsys_hps_hps2fpga_rlast   (subsys_hps_hps2fpga_rlast  ),
.subsys_hps_hps2fpga_wlast   (subsys_hps_hps2fpga_wlast  ),
.subsys_hps_hps2fpga_rresp   (subsys_hps_hps2fpga_rresp  ),
.subsys_hps_hps2fpga_awid    (subsys_hps_hps2fpga_awid   ),
.subsys_hps_hps2fpga_bid     (subsys_hps_hps2fpga_bid    ),
.subsys_hps_hps2fpga_bvalid  (subsys_hps_hps2fpga_bvalid ),
.subsys_hps_hps2fpga_awsize  (subsys_hps_hps2fpga_awsize ),
.subsys_hps_hps2fpga_awvalid (subsys_hps_hps2fpga_awvalid),
.subsys_hps_hps2fpga_rvalid  (subsys_hps_hps2fpga_rvalid ),

// lwhps2fpga interface
.subsys_hps_lwhps2fpga_awburst (subsys_hps_lwhps2fpga_awburst),
.subsys_hps_lwhps2fpga_arlen   (subsys_hps_lwhps2fpga_arlen  ),
.subsys_hps_lwhps2fpga_wstrb   (subsys_hps_lwhps2fpga_wstrb  ),
.subsys_hps_lwhps2fpga_wready  (subsys_hps_lwhps2fpga_wready ),
.subsys_hps_lwhps2fpga_rid     (subsys_hps_lwhps2fpga_rid    ),
.subsys_hps_lwhps2fpga_rready  (subsys_hps_lwhps2fpga_rready ),
.subsys_hps_lwhps2fpga_awlen   (subsys_hps_lwhps2fpga_awlen  ),
.subsys_hps_lwhps2fpga_arcache (subsys_hps_lwhps2fpga_arcache),
.subsys_hps_lwhps2fpga_wvalid  (subsys_hps_lwhps2fpga_wvalid ),
.subsys_hps_lwhps2fpga_araddr  (subsys_hps_lwhps2fpga_araddr ),
.subsys_hps_lwhps2fpga_arprot  (subsys_hps_lwhps2fpga_arprot ),
.subsys_hps_lwhps2fpga_awprot  (subsys_hps_lwhps2fpga_awprot ),
.subsys_hps_lwhps2fpga_wdata   (subsys_hps_lwhps2fpga_wdata  ),
.subsys_hps_lwhps2fpga_arvalid (subsys_hps_lwhps2fpga_arvalid),
.subsys_hps_lwhps2fpga_awcache (subsys_hps_lwhps2fpga_awcache),
.subsys_hps_lwhps2fpga_arid    (subsys_hps_lwhps2fpga_arid   ),
.subsys_hps_lwhps2fpga_arlock  (subsys_hps_lwhps2fpga_arlock ),
.subsys_hps_lwhps2fpga_awlock  (subsys_hps_lwhps2fpga_awlock ),
.subsys_hps_lwhps2fpga_awaddr  (subsys_hps_lwhps2fpga_awaddr ),
.subsys_hps_lwhps2fpga_bresp   (subsys_hps_lwhps2fpga_bresp  ),
.subsys_hps_lwhps2fpga_arready (subsys_hps_lwhps2fpga_arready),
.subsys_hps_lwhps2fpga_rdata   (subsys_hps_lwhps2fpga_rdata  ),
.subsys_hps_lwhps2fpga_awready (subsys_hps_lwhps2fpga_awready),
.subsys_hps_lwhps2fpga_arburst (subsys_hps_lwhps2fpga_arburst),
.subsys_hps_lwhps2fpga_arsize  (subsys_hps_lwhps2fpga_arsize ),
.subsys_hps_lwhps2fpga_bready  (subsys_hps_lwhps2fpga_bready ),
.subsys_hps_lwhps2fpga_rlast   (subsys_hps_lwhps2fpga_rlast  ),
.subsys_hps_lwhps2fpga_wlast   (subsys_hps_lwhps2fpga_wlast  ),
.subsys_hps_lwhps2fpga_rresp   (subsys_hps_lwhps2fpga_rresp  ),
.subsys_hps_lwhps2fpga_awid    (subsys_hps_lwhps2fpga_awid   ),
.subsys_hps_lwhps2fpga_bid     (subsys_hps_lwhps2fpga_bid    ),
.subsys_hps_lwhps2fpga_bvalid  (subsys_hps_lwhps2fpga_bvalid ),
.subsys_hps_lwhps2fpga_awsize  (subsys_hps_lwhps2fpga_awsize ),
.subsys_hps_lwhps2fpga_awvalid (subsys_hps_lwhps2fpga_awvalid),
.subsys_hps_lwhps2fpga_rvalid  (subsys_hps_lwhps2fpga_rvalid ),


// .subsys_hps_f2h_irq0_in_irq  (subsys_hps_f2h_irq0_in_irq ),

`endif
// clock & reset outputs
 .clk_100_out_clk_clk (iopll_clk_100)
,.clk_250_out_clk_clk (iopll_clk_250)
,.pcie_gts_rst_o_shoreline_refclk_fail_stat_shoreline_refclk_fail_stat ()
,.usb_gts_rst_o_pma_cu_clk_clk (usb_gts_rst_o_pma_cu_clk_clk)
,.usb_gts_rst_o_shoreline_refclk_fail_stat_shoreline_refclk_fail_stat ()
,.user_rst_clkgate_0_ninit_done_reset (ninit_done)
,.pcie_clk_rst_subsys_0_iopll_0_locked_export (pll_locked)
,.pcie_clk_rst_subsys_0_reset_bridge_h2f_reset_in_reset_reset (system_reset)
,.pcie_subsys_0_config_timeout_0_csr_soft_rst_csr_axi_st_rst   (csr_axi_st_rst)
,.pcie_subsys_0_config_timeout_0_csr_soft_rst_csr_axi_lite_rst (csr_axi_lite_rst)
,.pcie_subsys_0_intel_pcie_gts_p0_coreclkout_hip_toapp_clk (coreclk_out)
,.pcie_subsys_0_intel_pcie_gts_p0_pin_perst_n_reset_n ()
,.pcie_subsys_0_intel_pcie_gts_p0_reset_status_n_reset_n (pcie_subsys_0_intel_pcie_gts_p0_reset_status_n_reset_n)
,.subsys_hps_h2f_reset_reset (h2f_reset)
,.h2f_warm_reset_handshake_reset_req ()

// GTS rst sequence interface
,.pcie_subsys_0_intel_pcie_gts_p0_subsystem_rst_req_subsystem_rst_req ('0)
,.pcie_subsys_0_intel_pcie_gts_p0_subsystem_rst_rdy_subsystem_rst_rdy ()
,.pcie_subsys_0_intel_pcie_gts_p0_subsystem_cold_rst_n_reset_n (pcie_subsys_0_intel_pcie_gts_p0_reset_status_n_reset_n)
,.pcie_subsys_0_intel_pcie_gts_p0_subsystem_warm_rst_n_reset_n (pcie_subsys_0_intel_pcie_gts_p0_reset_status_n_reset_n)
,.pcie_subsys_0_intel_pcie_gts_p0_initiate_rst_req_rdy_initiate_rst_req_rdy (gts_p0_initiate_rst_req_rdy_initiate_rst_req_rdy)

// reset controller outputs
,.pcie_subsys_0_intel_pcie_gts_p0_initiate_warmrst_req_initiate_warmrst_req (gts_p0_initiate_warmrst_req_initiate_warmrst_req) 
,.pcie_subsys_0_intel_pcie_gts_p0_subsystem_cold_rst_ack_n_subsystem_cold_rst_ack_n (gts_p0_subsystem_cold_rst_ack_n_subsystem_cold_rst_ack_n) 
,.pcie_subsys_0_intel_pcie_gts_p0_subsystem_warm_rst_ack_n_subsystem_warm_rst_ack_n (gts_p0_subsystem_warm_rst_ack_n_subsystem_warm_rst_ack_n) 

// clock & reset inputs
,.pcie_clock_bridge_in_clk_clk (coreclk_out)
,.pcie_gts_rst_i_refclk_bus_out_refclk_bus_out (gts_refclk)
,.pcie_reset_bridge_in_reset_reset (!pcie_ss_rst_n) // from reset controller
,.rst_100_in_reset_reset_n (rst_n_100) // from reset controller
,.system_reset_bridge_100_in_reset_reset (pll_locked_rst_100)
,.system_reset_bridge_250_in_reset_reset (pll_locked_rst_250)
,.subsys_hps_usb31_phy_pma_cpu_clk_clk (usb_gts_rst_o_pma_cu_clk_clk)
,.pcie_clk_rst_subsys_0_intel_systemclk_gts_0_refclk_xcvr_clk (gts_refclk)
,.pcie_clk_rst_subsys_0_iopll_0_refclk_clk (system_clk_100)
,.pcie_clk_rst_subsys_0_reset_bridge_250_in_reset_reset (rst_250) // from reset sync
,.pcie_subsys_0_intel_pcie_gts_refclk0_clk (gts_refclk)
,.pcie_subsys_0_intel_pcie_gts_p0_pin_perst_n_i_reset_n (pin_perst_n)
,.pcie_subsys_0_intel_pcie_gts_p0_pin_perst_n_1_i_reset_n (pin_perst_n_1)
,.pcie_subsys_0_intel_pcie_gts_ninit_done_reset (ninit_done)
,.h2f_warm_reset_handshake_reset_ack ('0)

// config_timeout inputs
,.pcie_subsys_0_config_timeout_0_hip_status_link_up (hip_status_link_up)       
,.pcie_subsys_0_config_timeout_0_hip_status_dl_up   (hip_status_dl_up)            
,.pcie_subsys_0_config_timeout_0_hip_status_suprise_down_err (hip_status_suprise_down_err)
,.pcie_subsys_0_config_timeout_0_hip_status_ltssm_state      (hip_status_ltssm_state)  

// hip_serial_rx inputs
,.pcie_subsys_0_intel_pcie_gts_hip_serial_rx_n_in0 (hip_serial_rx_n_in0)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_rx_p_in0 (hip_serial_rx_p_in0)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_rx_n_in1 (hip_serial_rx_n_in1)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_rx_p_in1 (hip_serial_rx_p_in1)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_rx_n_in2 (hip_serial_rx_n_in2)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_rx_p_in2 (hip_serial_rx_p_in2)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_rx_n_in3 (hip_serial_rx_n_in3)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_rx_p_in3 (hip_serial_rx_p_in3)

// hip_serial_tx outputs
,.pcie_subsys_0_intel_pcie_gts_hip_serial_tx_n_out0 (hip_serial_tx_n_out0)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_tx_p_out0 (hip_serial_tx_p_out0)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_tx_n_out1 (hip_serial_tx_n_out1)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_tx_p_out1 (hip_serial_tx_p_out1)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_tx_n_out2 (hip_serial_tx_n_out2)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_tx_p_out2 (hip_serial_tx_p_out2)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_tx_n_out3 (hip_serial_tx_n_out3)
,.pcie_subsys_0_intel_pcie_gts_hip_serial_tx_p_out3 (hip_serial_tx_p_out3)

// rx_st interface
,.pcie_subsys_0_intel_pcie_gts_p0_st_rx_tvalid (rx_st_tvalid)
,.pcie_subsys_0_intel_pcie_gts_p0_st_rx_tready (rx_st_tready)
,.pcie_subsys_0_intel_pcie_gts_p0_st_rx_tdata  (rx_st_tdata)
,.pcie_subsys_0_intel_pcie_gts_p0_st_rx_tkeep  (rx_st_tkeep)
,.pcie_subsys_0_intel_pcie_gts_p0_st_rx_tlast  (rx_st_tlast)

,.pcie_subsys_0_pcie_gts_mcdma_ss_rx_st_tvalid (rx_st_tvalid)                                                 
,.pcie_subsys_0_pcie_gts_mcdma_ss_rx_st_tready (rx_st_tready)                                                 
,.pcie_subsys_0_pcie_gts_mcdma_ss_rx_st_tdata (rx_st_tdata)                                                  
,.pcie_subsys_0_pcie_gts_mcdma_ss_rx_st_tkeep (rx_st_tkeep)                                                 
,.pcie_subsys_0_pcie_gts_mcdma_ss_rx_st_tlast (rx_st_tlast)                                                            

// ctrlshadow outputs
,.pcie_subsys_0_intel_pcie_gts_p0_st_ctrlshadow_tvalid ()              
,.pcie_subsys_0_intel_pcie_gts_p0_st_ctrlshadow_tdata ()               

// gts hip status outputs
,.pcie_subsys_0_intel_pcie_gts_p0_ss_app_serr_ss_app_serr (hip_status_suprise_down_err)            
,.pcie_subsys_0_intel_pcie_gts_p0_ss_app_dlup_ss_app_dlup (hip_status_dl_up)           
,.pcie_subsys_0_intel_pcie_gts_p0_ss_app_linkup_ss_app_linkup (hip_status_link_up)        
,.pcie_subsys_0_intel_pcie_gts_p0_ss_app_int_status_ss_app_int_status (hip_irq_int_status)
,.pcie_subsys_0_intel_pcie_gts_p0_ss_app_ltssmstate_ss_app_ltssmstate (hip_status_ltssm_state)

// cii interface
,.pcie_subsys_0_pcie_gts_mcdma_p0_st_ciireq_tvalid ('0)
,.pcie_subsys_0_pcie_gts_mcdma_p0_st_ciireq_tdata ('0)
,.pcie_subsys_0_pcie_gts_mcdma_p0_st_ciireq_tready ()
,.pcie_subsys_0_pcie_gts_mcdma_p0_st_ciiresp_tvalid ()
,.pcie_subsys_0_pcie_gts_mcdma_p0_st_ciiresp_tdata ()

// mcdma err interface
,.pcie_subsys_0_pcie_gts_mcdma_ss_app_err_tvalid ()
,.pcie_subsys_0_pcie_gts_mcdma_ss_app_err_tdata ()
,.pcie_subsys_0_pcie_gts_mcdma_ss_app_err_tlast ()
,.pcie_subsys_0_pcie_gts_mcdma_app_ss_st_err_tuser_error_type_app_ss_st_err_tuser_error_type ()
,.pcie_subsys_0_pcie_gts_mcdma_ss_app_err_tready ('1)

// irq interface
,.pcie_subsys_0_msi_to_gic_interrupt_sender_irq (pcie_subsys_0_msi_to_gic_interrupt_sender_irq)

,.subsys_periph_interrupt_latency_counter_irq_irq (sender_irq)
,.subsys_hps_f2h_irq0_in_irq (sender_irq)

// misc interfaces
,.emif_hps_emif_mem_ck_0_mem_ck_t           (emif_hps_emif_mem_0_mem_ck_t)
,.emif_hps_emif_mem_ck_0_mem_ck_c           (emif_hps_emif_mem_0_mem_ck_c)
,.emif_hps_emif_mem_0_mem_a                 (emif_hps_emif_mem_0_mem_a)
,.emif_hps_emif_mem_0_mem_act_n             (emif_hps_emif_mem_0_mem_act_n)
,.emif_hps_emif_mem_0_mem_ba                (emif_hps_emif_mem_0_mem_ba)
,.emif_hps_emif_mem_0_mem_bg                (emif_hps_emif_mem_0_mem_bg)
,.emif_hps_emif_mem_0_mem_cke               (emif_hps_emif_mem_0_mem_cke)
,.emif_hps_emif_mem_0_mem_cs_n              (emif_hps_emif_mem_0_mem_cs_n)
,.emif_hps_emif_mem_0_mem_odt               (emif_hps_emif_mem_0_mem_odt)
,.emif_hps_emif_mem_reset_n_mem_reset_n     (emif_hps_emif_mem_0_mem_reset_n)
,.emif_hps_emif_mem_0_mem_par               (emif_hps_emif_mem_0_mem_par)
,.emif_hps_emif_mem_0_mem_alert_n           (emif_hps_emif_mem_0_mem_alert_n)
,.emif_hps_emif_mem_0_mem_dqs_t             (emif_hps_emif_mem_0_mem_dqs_t)
,.emif_hps_emif_mem_0_mem_dqs_c             (emif_hps_emif_mem_0_mem_dqs_c)
,.emif_hps_emif_mem_0_mem_dq                (emif_hps_emif_mem_0_mem_dq)
,.emif_hps_emif_oct_0_oct_rzqin             (emif_hps_emif_oct_0_oct_rzqin)
,.emif_hps_emif_ref_clk_0_clk               (emif_hps_emif_ref_clk_0_clk)
,.hps_io_jtag_tck                           (hps_jtag_tck)                
,.hps_io_jtag_tms                           (hps_jtag_tms)                
,.hps_io_jtag_tdo                           (hps_jtag_tdo)                 
,.hps_io_jtag_tdi                           (hps_jtag_tdi)    
,.hps_io_emac2_tx_clk                       (hps_emac2_TX_CLK)      
,.hps_io_emac2_rx_clk                       (hps_emac2_RX_CLK)  
,.hps_io_emac2_tx_ctl                       (hps_emac2_TX_CTL)     
,.hps_io_emac2_rx_ctl                       (hps_emac2_RX_CTL)  
,.hps_io_emac2_txd0                         (hps_emac2_TXD0)        
,.hps_io_emac2_txd1                         (hps_emac2_TXD1)  
,.hps_io_emac2_rxd0                         (hps_emac2_RXD0)   
,.hps_io_emac2_rxd1                         (hps_emac2_RXD1)     
,.hps_io_emac2_pps                          (hps_emac2_PPS)      
,.hps_io_emac2_pps_trig                     (hps_emac2_PPS_TRIG) 
,.hps_io_emac2_txd2                         (hps_emac2_TXD2)      
,.hps_io_emac2_txd3                         (hps_emac2_TXD3)  
,.hps_io_emac2_rxd2                         (hps_emac2_RXD2)     
,.hps_io_emac2_rxd3                         (hps_emac2_RXD3)   
,.hps_io_mdio2_mdio                         (hps_emac2_MDIO)  
,.hps_io_mdio2_mdc                          (hps_emac2_MDC)  
,.hps_io_sdmmc_cclk                         (hps_sdmmc_CCLK)   
,.hps_io_sdmmc_cmd                          (hps_sdmmc_CMD) 
,.hps_io_sdmmc_data0                        (hps_sdmmc_D0)          
,.hps_io_sdmmc_data1                        (hps_sdmmc_D1)          
,.hps_io_sdmmc_data2                        (hps_sdmmc_D2)         
,.hps_io_sdmmc_data3                        (hps_sdmmc_D3)        
,.hps_io_sdmmc_wprot                        (hps_sdmmc_WPROT)
,.hps_io_i3c1_sda                           (hps_i3c1_SDA)     
,.hps_io_i3c1_scl                           (hps_i3c1_SCL)
,.hps_io_uart0_rx                           (hps_uart0_RX)          
,.hps_io_uart0_tx                           (hps_uart0_TX) 
,.usb31_io_vbus_det                         (usb31_io_vbus_det) 
,.usb31_io_flt_bar                          (usb31_io_flt_bar)                   
,.usb31_io_usb_ctrl                         (usb31_io_usb_ctrl)
,.usb31_io_usb31_id                         (usb31_io_usb31_id)                  
,.subsys_hps_f2h_irq1_in_irq                ('0)                  
,.usb31_phy_refclk_p_clk                    (usb31_phy_refclk_p_clk)                      
,.usb31_phy_rx_serial_n_i_rx_serial_n       (usb31_phy_rx_serial_n_i_rx_serial_n)
,.usb31_phy_rx_serial_p_i_rx_serial_p       (usb31_phy_rx_serial_p_i_rx_serial_p)
,.usb31_phy_tx_serial_n_o_tx_serial_n       (usb31_phy_tx_serial_n_o_tx_serial_n)
,.usb31_phy_tx_serial_p_o_tx_serial_p       (usb31_phy_tx_serial_p_o_tx_serial_p)
// ,.usb31_phy_pma_cpu_clk_clk                 (usb_gts_rst_o_pma_cu_clk_clk)
,.hps_io_usb1_clk                           (hps_usb1_CLK) 
,.hps_io_usb1_stp                           (hps_usb1_STP) 
,.hps_io_usb1_dir                           (hps_usb1_DIR)
,.hps_io_usb1_nxt                           (hps_usb1_NXT)
,.hps_io_usb1_data0                         (hps_usb1_DATA0)
,.hps_io_usb1_data1                         (hps_usb1_DATA1) 
,.hps_io_usb1_data2                         (hps_usb1_DATA2) 
,.hps_io_usb1_data3                         (hps_usb1_DATA3) 
,.hps_io_usb1_data4                         (hps_usb1_DATA4) 
,.hps_io_usb1_data5                         (hps_usb1_DATA5)
,.hps_io_usb1_data6                         (hps_usb1_DATA6) 
,.hps_io_usb1_data7                         (hps_usb1_DATA7)
,.hps_io_gpio0                              (hps_gpio0_io0)
,.hps_io_gpio1                              (hps_gpio0_io1)
,.hps_io_gpio11                             (hps_gpio0_io11)
,.hps_io_gpio27                             (hps_gpio1_io3)
,.hps_io_hps_osc_clk                        (hps_osc_clk)

// msi_ordering interface
,.pcie_subsys_0_msi_ordering_csr_vector_addr_csr_vector_addr (36'h9_FFFF_F000)

);

endmodule
