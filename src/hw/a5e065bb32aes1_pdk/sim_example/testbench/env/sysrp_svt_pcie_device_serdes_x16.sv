//----------------------------------------------------------------
// This file shows the wiring for a standard serdes interface
//----------------------------------------------------------------

  wire  root0_tx_datap_0;
  wire  root0_tx_datan_0;
  wire  root0_tx_datap_1;
  wire  root0_tx_datan_1;
  wire  root0_tx_datap_2;
  wire  root0_tx_datan_2;
  wire  root0_tx_datap_3;
  wire  root0_tx_datan_3;
  wire  root0_tx_datap_4;
  wire  root0_tx_datan_4;
  wire  root0_tx_datap_5;
  wire  root0_tx_datan_5;
  wire  root0_tx_datap_6;
  wire  root0_tx_datan_6;
  wire  root0_tx_datap_7;
  wire  root0_tx_datan_7;
  wire  root0_tx_datap_8;
  wire  root0_tx_datan_8;
  wire  root0_tx_datap_9;
  wire  root0_tx_datan_9;
  wire  root0_tx_datap_10;
  wire  root0_tx_datan_10;
  wire  root0_tx_datap_11;
  wire  root0_tx_datan_11;
  wire  root0_tx_datap_12;
  wire  root0_tx_datan_12;
  wire  root0_tx_datap_13;
  wire  root0_tx_datan_13;
  wire  root0_tx_datap_14;
  wire  root0_tx_datan_14;
  wire  root0_tx_datap_15;
  wire  root0_tx_datan_15;

  wire  endpoint0_tx_datap_0;
  wire  endpoint0_tx_datan_0;
  wire  endpoint0_tx_datap_1;
  wire  endpoint0_tx_datan_1;
  wire  endpoint0_tx_datap_2;
  wire  endpoint0_tx_datan_2;
  wire  endpoint0_tx_datap_3;
  wire  endpoint0_tx_datan_3;
  wire  endpoint0_tx_datap_4;
  wire  endpoint0_tx_datan_4;
  wire  endpoint0_tx_datap_5;
  wire  endpoint0_tx_datan_5;
  wire  endpoint0_tx_datap_6;
  wire  endpoint0_tx_datan_6;
  wire  endpoint0_tx_datap_7;
  wire  endpoint0_tx_datan_7;
  wire  endpoint0_tx_datan_8;
  wire  endpoint0_tx_datap_9;
  wire  endpoint0_tx_datan_9;
  wire  endpoint0_tx_datap_10;
  wire  endpoint0_tx_datan_10;
  wire  endpoint0_tx_datap_11;
  wire  endpoint0_tx_datan_11;
  wire  endpoint0_tx_datap_12;
  wire  endpoint0_tx_datan_12;
  wire  endpoint0_tx_datap_13;
  wire  endpoint0_tx_datan_13;
  wire  endpoint0_tx_datap_14;
  wire  endpoint0_tx_datan_14;
  wire  endpoint0_tx_datap_15;
  wire  endpoint0_tx_datan_15;


`ifdef SM_X4
    pciesvc_device_serdes_x4_model #(.DISPLAY_NAME("endpoint0.")) endpoint0(.reset             (reset),
                              .rx_datap_0(root0_tx_datap_0),
                              .rx_datan_0(root0_tx_datan_0),
                              .rx_datap_1(root0_tx_datap_1),
                              .rx_datan_1(root0_tx_datan_1),
                              .rx_datap_2(root0_tx_datap_2),
                              .rx_datan_2(root0_tx_datan_2),
                              .rx_datap_3(root0_tx_datap_3),
                              .rx_datan_3(root0_tx_datan_3),

                              .tx_datap_0(endpoint0_tx_datap_0),
                              .tx_datan_0(endpoint0_tx_datan_0),
                              .tx_datap_1(endpoint0_tx_datap_1),
                              .tx_datan_1(endpoint0_tx_datan_1),
                              .tx_datap_2(endpoint0_tx_datap_2),
                              .tx_datan_2(endpoint0_tx_datan_2),
                              .tx_datap_3(endpoint0_tx_datap_3),
                              .tx_datan_3(endpoint0_tx_datan_3)
                             );

  defparam sysrp_top_tb.endpoint0.port0.serdes0.ALLOW_RECOVERED_CLK_WIDTH_ADJUSTMENTS = 1;
  defparam sysrp_top_tb.endpoint0.port0.serdes0.CLK_TOLERANCE = 0.100000;
  defparam sysrp_top_tb.endpoint0.port0.serdes1.ALLOW_RECOVERED_CLK_WIDTH_ADJUSTMENTS = 1;
  defparam sysrp_top_tb.endpoint0.port0.serdes1.CLK_TOLERANCE = 0.100000;
  defparam sysrp_top_tb.endpoint0.port0.serdes2.ALLOW_RECOVERED_CLK_WIDTH_ADJUSTMENTS = 1;
  defparam sysrp_top_tb.endpoint0.port0.serdes2.CLK_TOLERANCE = 0.100000;
  defparam sysrp_top_tb.endpoint0.port0.serdes3.ALLOW_RECOVERED_CLK_WIDTH_ADJUSTMENTS = 1;
  defparam sysrp_top_tb.endpoint0.port0.serdes3.CLK_TOLERANCE = 0.100000;

   qsys_top_wrapper PCIE_RP_DUT ( 
			 .emif_hps_emif_mem_0_mem_ck_t              (), 
                         .emif_hps_emif_mem_0_mem_ck_c              (), 
                         .emif_hps_emif_mem_0_mem_a                 (), 
                         .emif_hps_emif_mem_0_mem_act_n             (),
                         .emif_hps_emif_mem_0_mem_ba                (), 
                         .emif_hps_emif_mem_0_mem_bg                (), 
                         .emif_hps_emif_mem_0_mem_cke               (),
                         .emif_hps_emif_mem_0_mem_cs_n              (),
                         .emif_hps_emif_mem_0_mem_odt               (),
                         .emif_hps_emif_mem_0_mem_reset_n           (),
                         .emif_hps_emif_mem_0_mem_par               (),
                         .emif_hps_emif_mem_0_mem_alert_n           (),
                         .emif_hps_emif_oct_0_oct_rzqin             (0),
                         .emif_hps_emif_ref_clk_0_clk               (clk_100mhz),
                         .emif_hps_emif_mem_0_mem_dqs_t             (),
                         .emif_hps_emif_mem_0_mem_dqs_c             (),
                         .emif_hps_emif_mem_0_mem_dq                (),
                         .hps_jtag_tck                              (0),
                         .hps_jtag_tms                              (0),
                         .hps_jtag_tdo                              (),
                         .hps_jtag_tdi                              (0),
                         .hps_sdmmc_CCLK                            (), 
                         .hps_sdmmc_CMD                             (),          
                         .hps_sdmmc_D0                              (),          
                         .hps_sdmmc_D1                              (),          
                         .hps_sdmmc_D2                              (),        
                         .hps_sdmmc_D3                              (),        
                         .hps_sdmmc_WPROT                           (),
                         .usb31_io_vbus_det                         (0),                   
                         .usb31_io_flt_bar                          (0),                   
                         .usb31_io_usb_ctrl                         (),  
                         .usb31_io_usb31_id                         (0),                 
                         .usb31_phy_refclk_p_clk                    (0),             
                         .usb31_phy_rx_serial_n_i_rx_serial_n       (0), 
                         .usb31_phy_rx_serial_p_i_rx_serial_p       (0), 
                         .usb31_phy_tx_serial_n_o_tx_serial_n       (),  
                         .usb31_phy_tx_serial_p_o_tx_serial_p       (),  
                         .hps_usb1_DATA0                            (),         
                         .hps_usb1_DATA1                            (),      
                         .hps_usb1_DATA2                            (),        
                         .hps_usb1_DATA3                            (),       
                         .hps_usb1_DATA4                            (),        
                         .hps_usb1_DATA5                            (),      
                         .hps_usb1_DATA6                            (),      
                         .hps_usb1_DATA7                            (),         
                         .hps_usb1_CLK                              (clk_100mhz),         
                         .hps_usb1_STP                              (),       
                         .hps_usb1_DIR                              (0),        
                         .hps_usb1_NXT                              (0), 
                         .hps_emac2_TX_CLK                          (),       
                         .hps_emac2_RX_CLK                          (clk_100mhz),      
                         .hps_emac2_TX_CTL                          (),
                         .hps_emac2_RX_CTL                          (0),      
                         .hps_emac2_TXD0                            (),       
                         .hps_emac2_TXD1                            (),
                         .hps_emac2_RXD0                            (0),     
                         .hps_emac2_RXD1                            (0), 
                         .hps_emac2_PPS                             (),    
                         .hps_emac2_PPS_TRIG                        (),
                         .hps_emac2_TXD2                            (),        
                         .hps_emac2_TXD3                            (),
                         .hps_emac2_RXD2                            (0),        
                         .hps_emac2_RXD3                            (0),
                         .hps_emac2_MDIO                            (),         
                         .hps_emac2_MDC                             (),
                         .hps_uart0_RX                              (0),       
                         .hps_uart0_TX                              (), 
                         .hps_i3c1_SDA                              (),        
                         .hps_i3c1_SCL                              (), 
                         .hps_gpio0_io0                             (),
                         .hps_gpio0_io1                             (),
                         .hps_gpio0_io11                            (),
                         .hps_gpio1_io3                             (),
                         .hps_osc_clk                               (clk),                             
                         // input    wire          fpga_reset_n,
                         .pin_perst_n                               (~reset),
                         .pin_perst_n_1                             (~reset), 
                         .gts_refclk                                (clk_100mhz),
                         .hip_serial_rx_n_in0                       (endpoint0_tx_datan_0), 
                         .hip_serial_rx_n_in1                       (endpoint0_tx_datan_1), 
                         .hip_serial_rx_n_in2                       (endpoint0_tx_datan_2), 
                         .hip_serial_rx_n_in3                       (endpoint0_tx_datan_3), 
                         .hip_serial_rx_p_in0                       (endpoint0_tx_datap_0), 
                         .hip_serial_rx_p_in1                       (endpoint0_tx_datap_1), 
                         .hip_serial_rx_p_in2                       (endpoint0_tx_datap_2), 
                         .hip_serial_rx_p_in3                       (endpoint0_tx_datap_3), 
                         .hip_serial_tx_n_out0                      (root0_tx_datan_0),
                         .hip_serial_tx_n_out1                      (root0_tx_datan_1),
                         .hip_serial_tx_n_out2                      (root0_tx_datan_2),
                         .hip_serial_tx_n_out3                      (root0_tx_datan_3),
                         .hip_serial_tx_p_out0                      (root0_tx_datap_0),
                         .hip_serial_tx_p_out1                      (root0_tx_datap_1),
                         .hip_serial_tx_p_out2                      (root0_tx_datap_2),
                         .hip_serial_tx_p_out3                      (root0_tx_datap_3),
                         .subsys_hps_lwhps2fpga_awburst             (), //Note: connection in sysrp_h2f_axi_lw_bfm.sv  
                         .subsys_hps_lwhps2fpga_arlen               (), 
                         .subsys_hps_lwhps2fpga_wstrb               (), 
                         .subsys_hps_lwhps2fpga_wready              (),
                         .subsys_hps_lwhps2fpga_rid                 (),  
                         .subsys_hps_lwhps2fpga_rready              (),
                         .subsys_hps_lwhps2fpga_awlen               (), 
                         .subsys_hps_lwhps2fpga_arcache             (), 
                         .subsys_hps_lwhps2fpga_wvalid              (), 
                         .subsys_hps_lwhps2fpga_araddr              (), 
                         .subsys_hps_lwhps2fpga_arprot              (), 
                         .subsys_hps_lwhps2fpga_awprot              (), 
                         .subsys_hps_lwhps2fpga_wdata               (), 
                         .subsys_hps_lwhps2fpga_arvalid             (), 
                         .subsys_hps_lwhps2fpga_awcache             (),  
                         .subsys_hps_lwhps2fpga_arid                (), 
                         .subsys_hps_lwhps2fpga_arlock              (),   
                         .subsys_hps_lwhps2fpga_awlock              (), 
                         .subsys_hps_lwhps2fpga_awaddr              (),  
			 .subsys_hps_lwhps2fpga_bresp               (),
			 .subsys_hps_lwhps2fpga_arready             (),
			 .subsys_hps_lwhps2fpga_rdata               (),
			 .subsys_hps_lwhps2fpga_awready             (),
			 .subsys_hps_lwhps2fpga_arburst             (),
			 .subsys_hps_lwhps2fpga_arsize              (),
			 .subsys_hps_lwhps2fpga_bready              (),
			 .subsys_hps_lwhps2fpga_rlast               (),
			 .subsys_hps_lwhps2fpga_wlast               (),
			 .subsys_hps_lwhps2fpga_rresp               (),
			 .subsys_hps_lwhps2fpga_awid                (),
			 .subsys_hps_lwhps2fpga_bid                 (),
			 .subsys_hps_lwhps2fpga_bvalid              (),
			 .subsys_hps_lwhps2fpga_awsize              (),
			 .subsys_hps_lwhps2fpga_awvalid             (),
			 .subsys_hps_lwhps2fpga_rvalid              (), //End
			 .subsys_hps_f2h_irq0_in_irq                (), 
                         .altera_ace5lite_cache_coherency_translator_0_m0_wuser            (), //Note: connection in sysrp_h2f_axi_bfm.sv
                         .altera_ace5lite_cache_coherency_translator_0_m0_awstashnid       (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arsnoop          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awsnoop          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_wstrb            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_wready           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_rid              (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_rready           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awlen            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awqos            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arcache          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arprot           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_wdata            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arvalid          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arid             (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arlock           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awlock           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_bresp            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arready          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arsize           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awdomain         (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_bready           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_wlast            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awregion         (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_buser            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_rresp            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_bvalid           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_ruser            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awburst          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arregion         (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awstashlpiden    (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awstashniden     (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arlen            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arqos            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awuser           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awatop           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_wvalid           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_araddr           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awprot           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awcache          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awaddr           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awstashlpid      (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_rdata            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awready          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_arburst          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_rlast            (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_ardomain         (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awid             (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_bid              (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awsize           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_awvalid          (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_rvalid           (),
                         .altera_ace5lite_cache_coherency_translator_0_m0_aruser           (), //end
                         .subsys_hps_hps2fpga_awid                                         (), //Note: connection in sysrp_user_definies.svh and sysrp_h2f_axi_lw_bfm
                         .subsys_hps_hps2fpga_awaddr                                       (),           
                         .subsys_hps_hps2fpga_awlen                                        (),          
                         .subsys_hps_hps2fpga_awsize                                       (),                               
                         .subsys_hps_hps2fpga_awburst                                      (),                             
                         .subsys_hps_hps2fpga_awlock                                       (),                             
                         .subsys_hps_hps2fpga_awcache                                      (),                           
                         .subsys_hps_hps2fpga_awprot                                       (),                           
                         .subsys_hps_hps2fpga_awvalid                                      (),                         
                         .subsys_hps_hps2fpga_awready                                      (),                        
                         .subsys_hps_hps2fpga_wdata                                        (),                         
                         .subsys_hps_hps2fpga_wstrb                                        (),                        
                         .subsys_hps_hps2fpga_wlast                                        (),                       
                         .subsys_hps_hps2fpga_wvalid                                       (),                     
                         .subsys_hps_hps2fpga_wready                                       (),                    
                         .subsys_hps_hps2fpga_bid                                          (),                      
                         .subsys_hps_hps2fpga_bresp                                        (),                   
                         .subsys_hps_hps2fpga_bvalid                                       (),                 
                         .subsys_hps_hps2fpga_bready                                       (),                
                         .subsys_hps_hps2fpga_arid                                         (),                             
                         .subsys_hps_hps2fpga_araddr                                       (),                          
                         .subsys_hps_hps2fpga_arlen                                        (),                          
                         .subsys_hps_hps2fpga_arsize                                       (),                        
                         .subsys_hps_hps2fpga_arburst                                      (),                      
                         .subsys_hps_hps2fpga_arlock                                       (),                      
                         .subsys_hps_hps2fpga_arcache                                      (),                    
                         .subsys_hps_hps2fpga_arprot                                       (),                    
                         .subsys_hps_hps2fpga_arvalid                                      (),                  
                         .subsys_hps_hps2fpga_arready                                      (),                 
                         .subsys_hps_hps2fpga_rid                                          (),                    
                         .subsys_hps_hps2fpga_rdata                                        (),                 
                         .subsys_hps_hps2fpga_rresp                                        (),                
                         .subsys_hps_hps2fpga_rlast                                        (),               
                         .subsys_hps_hps2fpga_rvalid                                       (),             
                         .subsys_hps_hps2fpga_rready                                       (), //End sysrp_h2f_axi_lw_bfm        
			 .system_reset                                                     (reset),
			 .system_clk_100                                                   (clk_100mhz),
			 .iopll_clk_100                                                    (),
                         .iopll_clk_250                                                    ()
        );

 `endif	

