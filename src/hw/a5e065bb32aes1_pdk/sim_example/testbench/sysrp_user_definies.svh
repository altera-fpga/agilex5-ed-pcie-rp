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
      force  axi_if.slave_if[0].awvalid          =   `H2F_TOP.``F2H_RTL_PORT``_awvalid ; \
      force  axi_if.slave_if[0].awaddr           =   `H2F_TOP.``F2H_RTL_PORT``_awaddr  ; \
      force  axi_if.slave_if[0].awprot           =   `H2F_TOP.``F2H_RTL_PORT``_awprot  ; \
      force  axi_if.slave_if[0].awid             =   `H2F_TOP.``F2H_RTL_PORT``_awid    ; \
      force  axi_if.slave_if[0].awlen            =   `H2F_TOP.``F2H_RTL_PORT``_awlen   ; \
      force  axi_if.slave_if[0].awsize           =   `H2F_TOP.``F2H_RTL_PORT``_awsize  ; \
      force  axi_if.slave_if[0].awburst          =   `H2F_TOP.``F2H_RTL_PORT``_awburst ; \
      force  axi_if.slave_if[0].awlock           =   `H2F_TOP.``F2H_RTL_PORT``_awlock  ; \
      force  axi_if.slave_if[0].awcache          =   `H2F_TOP.``F2H_RTL_PORT``_awcache ; \
      force  `H2F_TOP.``F2H_RTL_PORT``_awready   =    axi_if.slave_if[0].awready  ;\
\
      force  axi_if.slave_if[0].wvalid           =   `H2F_TOP.``F2H_RTL_PORT``_wvalid ;  \
      force  axi_if.slave_if[0].wdata            =   `H2F_TOP.``F2H_RTL_PORT``_wdata  ;  \
      force  axi_if.slave_if[0].wstrb            =   `H2F_TOP.``F2H_RTL_PORT``_wstrb  ;  \
      force  axi_if.slave_if[0].wlast            =   `H2F_TOP.``F2H_RTL_PORT``_wlast  ;  \
      force  `H2F_TOP.``F2H_RTL_PORT``_wready    =    axi_if.slave_if[0].wready  ; \
\
      force  axi_if.slave_if[0].bready           =    `H2F_TOP.``F2H_RTL_PORT``_bready ;\
      force  `H2F_TOP.``F2H_RTL_PORT``_bresp     =    axi_if.slave_if[0].bresp       ;  \
      force  `H2F_TOP.``F2H_RTL_PORT``_bvalid    =    axi_if.slave_if[0].bvalid      ; \
      force  `H2F_TOP.``F2H_RTL_PORT``_bid       =    axi_if.slave_if[0].bid         ; \
\
      force  axi_if.slave_if[0].arvalid          =    `H2F_TOP.``F2H_RTL_PORT``_arvalid ; \
      force  axi_if.slave_if[0].araddr           =    `H2F_TOP.``F2H_RTL_PORT``_araddr  ; \
      force  axi_if.slave_if[0].arprot           =    `H2F_TOP.``F2H_RTL_PORT``_arprot  ; \
      force  axi_if.slave_if[0].arid             =    `H2F_TOP.``F2H_RTL_PORT``_arid    ; \
      force  axi_if.slave_if[0].arlen            =    `H2F_TOP.``F2H_RTL_PORT``_arlen   ; \
      force  axi_if.slave_if[0].arsize           =    `H2F_TOP.``F2H_RTL_PORT``_arsize  ; \
      force  axi_if.slave_if[0].arburst          =    `H2F_TOP.``F2H_RTL_PORT``_arburst ; \
      force  axi_if.slave_if[0].arlock           =    `H2F_TOP.``F2H_RTL_PORT``_arlock  ; \
      force  axi_if.slave_if[0].arcache          =    `H2F_TOP.``F2H_RTL_PORT``_arcache ; \
      force  `H2F_TOP.``F2H_RTL_PORT``_arready   =     axi_if.slave_if[0].arready  ;\
\
      force  axi_if.slave_if[0].rready           =    `H2F_TOP.``F2H_RTL_PORT``_rready ;\
      force  `H2F_TOP.``F2H_RTL_PORT``_rvalid    =     axi_if.slave_if[0].rvalid ; \
      force  `H2F_TOP.``F2H_RTL_PORT``_rdata     =     axi_if.slave_if[0].rdata  ; \
      force  `H2F_TOP.``F2H_RTL_PORT``_rresp     =     axi_if.slave_if[0].rresp  ; \
      force  `H2F_TOP.``F2H_RTL_PORT``_rid       =     axi_if.slave_if[0].rid    ; \
      force  `H2F_TOP.``F2H_RTL_PORT``_rlast     =     axi_if.slave_if[0].rlast  ; \
