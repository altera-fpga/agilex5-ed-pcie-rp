//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2021 Intel Corporation.
//
//****************************************************************************
// Derive channel and width from hps_emif_topology



module top (
//Additional refclk_bti to preserve Etile XCVR
// Clock and Reset
input    wire          fpga_clk_100,

//HPS
// HPS EMIF
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
input    wire          fpga_reset_n,

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
output   wire          hip_serial_tx_p_out3
);

wire                   system_clk_100;
wire                   ninit_done;
wire                   fpga_reset_n_debounced_wire;
reg                    fpga_reset_n_debounced;
wire                   system_reset;
wire                   h2f_reset;
wire                   o_pma_cpu_clk;
wire                   iopll_clk_100;
wire                   iopll_clk_250;
wire [31:0]            f2h_irq1_irq;


assign                combined_reset_n = fpga_reset_n & ~h2f_reset
& ~ninit_done;

altera_reset_synchronizer #(
    .ASYNC_RESET (1),
    .DEPTH       (2)
) sys_rst_inst (
    .reset_in  (~combined_reset_n),
    .clk       (system_clk_100),
    .reset_out (system_reset)
);
             
assign                 system_clk_100   = fpga_clk_100;

assign                 f2h_irq1_irq    = {32'b0};

// Qsys Top wrapper module
qsys_top_wrapper qsys_top_wrapper (
 .h2f_reset                       (h2f_reset)
,.ninit_done                      (ninit_done)

,.emif_hps_emif_mem_0_mem_ck_t     (emif_hps_emif_mem_0_mem_ck_t   ) 
,.emif_hps_emif_mem_0_mem_ck_c     (emif_hps_emif_mem_0_mem_ck_c   )
,.emif_hps_emif_mem_0_mem_a        (emif_hps_emif_mem_0_mem_a      )
,.emif_hps_emif_mem_0_mem_act_n    (emif_hps_emif_mem_0_mem_act_n  )
,.emif_hps_emif_mem_0_mem_ba       (emif_hps_emif_mem_0_mem_ba     )
,.emif_hps_emif_mem_0_mem_bg       (emif_hps_emif_mem_0_mem_bg     )
,.emif_hps_emif_mem_0_mem_cke      (emif_hps_emif_mem_0_mem_cke    )
,.emif_hps_emif_mem_0_mem_cs_n     (emif_hps_emif_mem_0_mem_cs_n   )
,.emif_hps_emif_mem_0_mem_odt      (emif_hps_emif_mem_0_mem_odt    )
,.emif_hps_emif_mem_0_mem_reset_n  (emif_hps_emif_mem_0_mem_reset_n)
,.emif_hps_emif_mem_0_mem_par      (emif_hps_emif_mem_0_mem_par    )
,.emif_hps_emif_mem_0_mem_alert_n  (emif_hps_emif_mem_0_mem_alert_n)
,.emif_hps_emif_oct_0_oct_rzqin    (emif_hps_emif_oct_0_oct_rzqin  )
,.emif_hps_emif_ref_clk_0_clk      (emif_hps_emif_ref_clk_0_clk    )
,.emif_hps_emif_mem_0_mem_dqs_t    (emif_hps_emif_mem_0_mem_dqs_t  )
,.emif_hps_emif_mem_0_mem_dqs_c    (emif_hps_emif_mem_0_mem_dqs_c  )
,.emif_hps_emif_mem_0_mem_dq       (emif_hps_emif_mem_0_mem_dq     )
,.hps_jtag_tck                     (hps_jtag_tck                   )
,.hps_jtag_tms                     (hps_jtag_tms                   )
,.hps_jtag_tdo                     (hps_jtag_tdo                   )
,.hps_jtag_tdi                     (hps_jtag_tdi                   )
,.hps_sdmmc_CCLK                   (hps_sdmmc_CCLK                 )
,.hps_sdmmc_CMD                    (hps_sdmmc_CMD                  )
,.hps_sdmmc_D0                     (hps_sdmmc_D0                   )
,.hps_sdmmc_D1                     (hps_sdmmc_D1                   )
,.hps_sdmmc_D2                     (hps_sdmmc_D2                   )
,.hps_sdmmc_D3                     (hps_sdmmc_D3                   )
,.hps_sdmmc_WPROT                  (hps_sdmmc_WPROT                )

,.usb31_io_vbus_det                    (usb31_io_vbus_det                  )
,.usb31_io_flt_bar                     (usb31_io_flt_bar                   )
,.usb31_io_usb_ctrl                    (usb31_io_usb_ctrl                  )
,.usb31_io_usb31_id                    (usb31_io_usb31_id                  )
,.usb31_phy_refclk_p_clk               (usb31_phy_refclk_p_clk             )
// ,.usb31_phy_refclk_p_clk(n)            (usb31_phy_refclk_p_clk(n)          )
,.usb31_phy_rx_serial_n_i_rx_serial_n  (usb31_phy_rx_serial_n_i_rx_serial_n)
,.usb31_phy_rx_serial_p_i_rx_serial_p  (usb31_phy_rx_serial_p_i_rx_serial_p)
,.usb31_phy_tx_serial_n_o_tx_serial_n  (usb31_phy_tx_serial_n_o_tx_serial_n)
,.usb31_phy_tx_serial_p_o_tx_serial_p  (usb31_phy_tx_serial_p_o_tx_serial_p)
,.hps_usb1_DATA0                       (hps_usb1_DATA0                     )
,.hps_usb1_DATA1                       (hps_usb1_DATA1                     )
,.hps_usb1_DATA2                       (hps_usb1_DATA2                     )
,.hps_usb1_DATA3                       (hps_usb1_DATA3                     )
,.hps_usb1_DATA4                       (hps_usb1_DATA4                     )
,.hps_usb1_DATA5                       (hps_usb1_DATA5                     )
,.hps_usb1_DATA6                       (hps_usb1_DATA6                     )
,.hps_usb1_DATA7                       (hps_usb1_DATA7                     )
,.hps_usb1_CLK                         (hps_usb1_CLK                       )
,.hps_usb1_STP                         (hps_usb1_STP                       )
,.hps_usb1_DIR                         (hps_usb1_DIR                       )
,.hps_usb1_NXT                         (hps_usb1_NXT                       )
,.hps_emac2_TX_CLK                     (hps_emac2_TX_CLK                   )
,.hps_emac2_RX_CLK                     (hps_emac2_RX_CLK                   )
,.hps_emac2_TX_CTL                     (hps_emac2_TX_CTL                   )
,.hps_emac2_RX_CTL                     (hps_emac2_RX_CTL                   )
,.hps_emac2_TXD0                       (hps_emac2_TXD0                     )
,.hps_emac2_TXD1                       (hps_emac2_TXD1                     )
,.hps_emac2_RXD0                       (hps_emac2_RXD0                     )
,.hps_emac2_RXD1                       (hps_emac2_RXD1                     )
,.hps_emac2_PPS                        (hps_emac2_PPS                      )
,.hps_emac2_PPS_TRIG                   (hps_emac2_PPS_TRIG                 )
,.hps_emac2_TXD2                       (hps_emac2_TXD2                     )
,.hps_emac2_TXD3                       (hps_emac2_TXD3                     )
,.hps_emac2_RXD2                       (hps_emac2_RXD2                     )
,.hps_emac2_RXD3                       (hps_emac2_RXD3                     )
,.hps_emac2_MDIO                       (hps_emac2_MDIO                     )
,.hps_emac2_MDC                        (hps_emac2_MDC                      )
,.hps_uart0_RX                         (hps_uart0_RX                       )
,.hps_uart0_TX                         (hps_uart0_TX                       )
,.hps_i3c1_SDA                         (hps_i3c1_SDA                       )
,.hps_i3c1_SCL                         (hps_i3c1_SCL                       )
,.hps_gpio0_io0                        (hps_gpio0_io0                      )
,.hps_gpio0_io1                        (hps_gpio0_io1                      )
,.hps_gpio0_io11                       (hps_gpio0_io11                     )
,.hps_gpio1_io3                        (hps_gpio1_io3                      )
,.hps_osc_clk                          (hps_osc_clk                        )
//,.fpga_reset_n                       (fpga_reset_n                       )

,.pin_perst_n   (pin_perst_n  )
,.pin_perst_n_1 (pin_perst_n_1)
                 
,.gts_refclk    (gts_refclk   )

,.hip_serial_rx_n_in0  (hip_serial_rx_n_in0 )
,.hip_serial_rx_n_in1  (hip_serial_rx_n_in1 )
,.hip_serial_rx_n_in2  (hip_serial_rx_n_in2 )
,.hip_serial_rx_n_in3  (hip_serial_rx_n_in3 )
,.hip_serial_rx_p_in0  (hip_serial_rx_p_in0 )
,.hip_serial_rx_p_in1  (hip_serial_rx_p_in1 )
,.hip_serial_rx_p_in2  (hip_serial_rx_p_in2 )
,.hip_serial_rx_p_in3  (hip_serial_rx_p_in3 )
,.hip_serial_tx_n_out0 (hip_serial_tx_n_out0)
,.hip_serial_tx_n_out1 (hip_serial_tx_n_out1)
,.hip_serial_tx_n_out2 (hip_serial_tx_n_out2)
,.hip_serial_tx_n_out3 (hip_serial_tx_n_out3)
,.hip_serial_tx_p_out0 (hip_serial_tx_p_out0)
,.hip_serial_tx_p_out1 (hip_serial_tx_p_out1)
,.hip_serial_tx_p_out2 (hip_serial_tx_p_out2)
,.hip_serial_tx_p_out3 (hip_serial_tx_p_out3)

,.system_reset (system_reset)
,.system_clk_100 (system_clk_100)

,.iopll_clk_100 (iopll_clk_100)

,.iopll_clk_250 (iopll_clk_250)
);

endmodule


