module sysrp_h2f_axi_bfm(svt_axi_if axi_if);

    `ifdef  SM_X4
        assign axi_if.common_aclk            =  sysrp_top_tb.PCIE_RP_DUT.iopll_clk_250;
     `endif  
     assign axi_if.master_if[0].aresetn   =  ~(sysrp_top_tb.reset); 
     assign axi_if.slave_if[0].aresetn    =  ~(sysrp_top_tb.reset); 
     
     //==============================
     // HOST to FPGA forces
     //==============================

     assign `H2F_TOP.subsys_hps_hps2fpga_awvalid  =  axi_if.master_if[0].awvalid;
     assign `H2F_TOP.subsys_hps_hps2fpga_awaddr   =  axi_if.master_if[0].awaddr;
     assign `H2F_TOP.subsys_hps_hps2fpga_awprot   =  axi_if.master_if[0].awprot;
     assign `H2F_TOP.subsys_hps_hps2fpga_awid     =  axi_if.master_if[0].awid;
     assign `H2F_TOP.subsys_hps_hps2fpga_awlen    =  axi_if.master_if[0].awlen;
     assign `H2F_TOP.subsys_hps_hps2fpga_awsize   =  axi_if.master_if[0].awsize;
     assign `H2F_TOP.subsys_hps_hps2fpga_awburst  =  axi_if.master_if[0].awburst;
     assign `H2F_TOP.subsys_hps_hps2fpga_awlock   =  axi_if.master_if[0].awlock;
     assign `H2F_TOP.subsys_hps_hps2fpga_awcache  =  axi_if.master_if[0].awcache;
     assign  axi_if.master_if[0].awready          =  `H2F_TOP.subsys_hps_hps2fpga_awready;

     assign `H2F_TOP.subsys_hps_hps2fpga_wvalid   =  axi_if.master_if[0].wvalid;
     assign `H2F_TOP.subsys_hps_hps2fpga_wdata    =  axi_if.master_if[0].wdata; 
     assign `H2F_TOP.subsys_hps_hps2fpga_wstrb    =  axi_if.master_if[0].wstrb; 
     assign `H2F_TOP.subsys_hps_hps2fpga_wlast    =  axi_if.master_if[0].wlast; 
     assign  axi_if.master_if[0].wready           = `H2F_TOP.subsys_hps_hps2fpga_wready;

     assign `H2F_TOP.subsys_hps_hps2fpga_bready   =  axi_if.master_if[0].bready;
     assign  axi_if.master_if[0].bresp             = `H2F_TOP.subsys_hps_hps2fpga_bresp;
     assign  axi_if.master_if[0].bvalid            = `H2F_TOP.subsys_hps_hps2fpga_bvalid;
     assign  axi_if.master_if[0].bid               = `H2F_TOP.subsys_hps_hps2fpga_bid;

     assign `H2F_TOP.subsys_hps_hps2fpga_arvalid  =  axi_if.master_if[0].arvalid;
     assign `H2F_TOP.subsys_hps_hps2fpga_araddr   =  axi_if.master_if[0].araddr;
     assign `H2F_TOP.subsys_hps_hps2fpga_arprot   =  axi_if.master_if[0].arprot;
     assign `H2F_TOP.subsys_hps_hps2fpga_arid     =  axi_if.master_if[0].arid;
     assign `H2F_TOP.subsys_hps_hps2fpga_arlen    =  axi_if.master_if[0].arlen;
     assign `H2F_TOP.subsys_hps_hps2fpga_arsize   =  axi_if.master_if[0].arsize;
     assign `H2F_TOP.subsys_hps_hps2fpga_arburst  =  axi_if.master_if[0].arburst;
     assign `H2F_TOP.subsys_hps_hps2fpga_arlock   =  axi_if.master_if[0].arlock;
     assign `H2F_TOP.subsys_hps_hps2fpga_arcache  =  axi_if.master_if[0].arcache;
     assign  axi_if.master_if[0].arready           =  `H2F_TOP.subsys_hps_hps2fpga_arready;

     assign `H2F_TOP.subsys_hps_hps2fpga_rready   =  axi_if.master_if[0].rready;
     assign  axi_if.master_if[0].rvalid                  = `H2F_TOP.subsys_hps_hps2fpga_rvalid;
     assign  axi_if.master_if[0].rdata                   = `H2F_TOP.subsys_hps_hps2fpga_rdata;
     assign  axi_if.master_if[0].rresp                   = `H2F_TOP.subsys_hps_hps2fpga_rresp;
     assign  axi_if.master_if[0].rid                     = `H2F_TOP.subsys_hps_hps2fpga_rid;
     assign  axi_if.master_if[0].rlast                   = `H2F_TOP.subsys_hps_hps2fpga_rlast;

      //==============================
      // FPGA to HOST forces
      //==============================
      `ifdef SM_X4
         `f2h_slave_connection(altera_ace5lite_cache_coherency_translator_0_m0);
      `endif   

endmodule 

