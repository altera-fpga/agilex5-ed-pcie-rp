module sysrp_h2f_axi_lw_bfm(svt_axi_if axi_if);

     `ifdef SM_X4 
        assign axi_if.common_aclk            =  sysrp_top_tb.PCIE_RP_DUT.iopll_clk_100;
     `endif  
     assign axi_if.master_if[0].aresetn   =  ~(sysrp_top_tb.reset); 
     
  initial  
   begin
      force  `H2F_TOP.subsys_hps_lwhps2fpga_awvalid  =  axi_if.master_if[0].awvalid;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_awaddr   =  axi_if.master_if[0].awaddr;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_awprot   =  axi_if.master_if[0].awprot;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_awid     =  axi_if.master_if[0].awid;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_awlen    =  axi_if.master_if[0].awlen;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_awsize   =  axi_if.master_if[0].awsize;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_awburst  =  axi_if.master_if[0].awburst;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_awlock   =  axi_if.master_if[0].awlock;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_awcache  =  axi_if.master_if[0].awcache;
      force  axi_if.master_if[0].awready             =  `H2F_TOP.subsys_hps_lwhps2fpga_awready;

      force  `H2F_TOP.subsys_hps_lwhps2fpga_wvalid   =  axi_if.master_if[0].wvalid;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_wdata    =  axi_if.master_if[0].wdata; 
      force  `H2F_TOP.subsys_hps_lwhps2fpga_wstrb    =  axi_if.master_if[0].wstrb; 
      force  `H2F_TOP.subsys_hps_lwhps2fpga_wlast    =  axi_if.master_if[0].wlast; 
      force  axi_if.master_if[0].wready              = `H2F_TOP.subsys_hps_lwhps2fpga_wready;

      force  `H2F_TOP.subsys_hps_lwhps2fpga_bready   =  axi_if.master_if[0].bready;
      force  axi_if.master_if[0].bresp               = `H2F_TOP.subsys_hps_lwhps2fpga_bresp;
      force  axi_if.master_if[0].bvalid              = `H2F_TOP.subsys_hps_lwhps2fpga_bvalid;
      force  axi_if.master_if[0].bid                 = `H2F_TOP.subsys_hps_lwhps2fpga_bid;

      force  `H2F_TOP.subsys_hps_lwhps2fpga_arvalid  =  axi_if.master_if[0].arvalid;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_araddr   =  axi_if.master_if[0].araddr;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_arprot   =  axi_if.master_if[0].arprot;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_arid     =  axi_if.master_if[0].arid;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_arlen    =  axi_if.master_if[0].arlen;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_arsize   =  axi_if.master_if[0].arsize;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_arburst  =  axi_if.master_if[0].arburst;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_arlock   =  axi_if.master_if[0].arlock;
      force  `H2F_TOP.subsys_hps_lwhps2fpga_arcache  =  axi_if.master_if[0].arcache;
      force  axi_if.master_if[0].arready             =  `H2F_TOP.subsys_hps_lwhps2fpga_arready;

      force  `H2F_TOP.subsys_hps_lwhps2fpga_rready   =  axi_if.master_if[0].rready;
      force  axi_if.master_if[0].rvalid              = `H2F_TOP.subsys_hps_lwhps2fpga_rvalid;
      force  axi_if.master_if[0].rdata               = `H2F_TOP.subsys_hps_lwhps2fpga_rdata;
      force  axi_if.master_if[0].rresp               = `H2F_TOP.subsys_hps_lwhps2fpga_rresp;
      force  axi_if.master_if[0].rid                 = `H2F_TOP.subsys_hps_lwhps2fpga_rid;
      force  axi_if.master_if[0].rlast               = `H2F_TOP.subsys_hps_lwhps2fpga_rlast;

 end

endmodule 

