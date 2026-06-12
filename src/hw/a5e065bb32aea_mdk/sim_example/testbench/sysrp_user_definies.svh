//-----------------------------------------------------------------------
`ifndef SYSRP_ED_MCDMA_PATH
   `ifdef SM_X4
      `define SYSRP_ED_MCDMA_PATH sysrp_top_tb.PCIE_RP_DUT.soc_inst.pcie_subsys_0
   `endif
`endif

`ifndef PCIE_LINK_UP_O
  `ifdef SM_X4
     `define PCIE_LINK_UP_O   intel_pcie_gts_p0_ss_app_linkup_ss_app_linkup
  `endif
`endif

`ifndef H2F_TOP
  `ifdef SM_X4
     `define H2F_TOP sysrp_top_tb.PCIE_RP_DUT  
  `endif 
`endif  

`ifndef PCIE_SUBSYS
  `ifdef SM_X4
     `define PCIE_SUBSYS `H2F_TOP.soc_inst.pcie_subsys_0
  `endif
`endif

`define f2h_slave_connection(F2H_RTL_PORT)\
      assign  axi_if.slave_if[0].awvalid          =   `H2F_TOP.``F2H_RTL_PORT``_awvalid ; \
      assign  axi_if.slave_if[0].awaddr           =   `H2F_TOP.``F2H_RTL_PORT``_awaddr  ; \
      assign  axi_if.slave_if[0].awprot           =   `H2F_TOP.``F2H_RTL_PORT``_awprot  ; \
      assign  axi_if.slave_if[0].awid             =   `H2F_TOP.``F2H_RTL_PORT``_awid    ; \
      assign  axi_if.slave_if[0].awlen            =   `H2F_TOP.``F2H_RTL_PORT``_awlen   ; \
      assign  axi_if.slave_if[0].awsize           =   `H2F_TOP.``F2H_RTL_PORT``_awsize  ; \
      assign  axi_if.slave_if[0].awburst          =   `H2F_TOP.``F2H_RTL_PORT``_awburst ; \
      assign  axi_if.slave_if[0].awlock           =   `H2F_TOP.``F2H_RTL_PORT``_awlock  ; \
      assign  axi_if.slave_if[0].awcache          =   `H2F_TOP.``F2H_RTL_PORT``_awcache ; \
      assign  `H2F_TOP.``F2H_RTL_PORT``_awready   =    axi_if.slave_if[0].awready  ;\
\
      assign  axi_if.slave_if[0].wvalid           =   `H2F_TOP.``F2H_RTL_PORT``_wvalid ;  \
      assign  axi_if.slave_if[0].wdata            =   `H2F_TOP.``F2H_RTL_PORT``_wdata  ;  \
      assign  axi_if.slave_if[0].wstrb            =   `H2F_TOP.``F2H_RTL_PORT``_wstrb  ;  \
      assign  axi_if.slave_if[0].wlast            =   `H2F_TOP.``F2H_RTL_PORT``_wlast  ;  \
      assign  `H2F_TOP.``F2H_RTL_PORT``_wready    =    axi_if.slave_if[0].wready  ; \
\
      assign  axi_if.slave_if[0].bready           =    `H2F_TOP.``F2H_RTL_PORT``_bready ;\
      assign  `H2F_TOP.``F2H_RTL_PORT``_bresp     =    axi_if.slave_if[0].bresp       ;  \
      assign  `H2F_TOP.``F2H_RTL_PORT``_bvalid    =    axi_if.slave_if[0].bvalid      ; \
      assign  `H2F_TOP.``F2H_RTL_PORT``_bid       =    axi_if.slave_if[0].bid         ; \
\
      assign  axi_if.slave_if[0].arvalid          =    `H2F_TOP.``F2H_RTL_PORT``_arvalid ; \
      assign  axi_if.slave_if[0].araddr           =    `H2F_TOP.``F2H_RTL_PORT``_araddr  ; \
      assign  axi_if.slave_if[0].arprot           =    `H2F_TOP.``F2H_RTL_PORT``_arprot  ; \
      assign  axi_if.slave_if[0].arid             =    `H2F_TOP.``F2H_RTL_PORT``_arid    ; \
      assign  axi_if.slave_if[0].arlen            =    `H2F_TOP.``F2H_RTL_PORT``_arlen   ; \
      assign  axi_if.slave_if[0].arsize           =    `H2F_TOP.``F2H_RTL_PORT``_arsize  ; \
      assign  axi_if.slave_if[0].arburst          =    `H2F_TOP.``F2H_RTL_PORT``_arburst ; \
      assign  axi_if.slave_if[0].arlock           =    `H2F_TOP.``F2H_RTL_PORT``_arlock  ; \
      assign  axi_if.slave_if[0].arcache          =    `H2F_TOP.``F2H_RTL_PORT``_arcache ; \
      assign  `H2F_TOP.``F2H_RTL_PORT``_arready   =     axi_if.slave_if[0].arready  ;\
\
      assign  axi_if.slave_if[0].rready           =    `H2F_TOP.``F2H_RTL_PORT``_rready ;\
      assign  `H2F_TOP.``F2H_RTL_PORT``_rvalid    =     axi_if.slave_if[0].rvalid ; \
      assign  `H2F_TOP.``F2H_RTL_PORT``_rdata     =     axi_if.slave_if[0].rdata  ; \
      assign  `H2F_TOP.``F2H_RTL_PORT``_rresp     =     axi_if.slave_if[0].rresp  ; \
      assign  `H2F_TOP.``F2H_RTL_PORT``_rid       =     axi_if.slave_if[0].rid    ; \
      assign  `H2F_TOP.``F2H_RTL_PORT``_rlast     =     axi_if.slave_if[0].rlast  ; \
