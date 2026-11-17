//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2021 Intel Corporation.
//
//****************************************************************************

//----------------------------------------------------------------
// Project Name: P_tile_rp
// Module Name : configuration_timeout_top.v
// Author : anilatho 
// Description : A file that includes config timeout and mux.
//----------------------------------------------------------------
 

`timescale 1 ns / 1 ps

module configuration_timeout_top # (
    parameter ADDR_WIDTH            = 14,
    parameter DATA_WIDTH            = 32,
	parameter RESP_WIDTH            = 2,
    parameter CSR_ADDR_WIDTH        = 8,
    parameter CSR_DATA_WIDTH        = 32,	 
	parameter CSR_BYTE_ENABLE_WIDTH = 4,
	parameter LTSSM_STATE_WIDTH     = 6,
    parameter AWID_WIDTH            = 4,
    parameter AWADDR_WIDTH          = 64,
    parameter AWUSER_WIDTH          = 16,
    parameter AWLEN_WIDTH           = 8,
    parameter WDATA_WIDTH           = 256,
    parameter BID_WIDTH             = 4,
    parameter ARID_WIDTH            = 4,
    parameter ARADDR_WIDTH          = 64,
    parameter ARUSER_WIDTH          = 16,
    parameter ARLEN_WIDTH           = 8,
    parameter RID_WIDTH             = 4,
    parameter RDATA_WIDTH           = 256,
    parameter H2F_BAS_OUTSTANDING_PKT = 32
    ) 
    (
    input logic  						 			clk_i,
    input logic  						 			rstn_i,
	 input logic  						 			cs_waitrequest_i,     // waitrequest 	 signal from P_tile_ip
	 input logic  						 			cs_readdatavalid_i,   // readdatavalid signal from P_tile_ip
	 input logic  						 			cs_writerespvalid_i,  // writerespvalid signal from P_tile_ip
    input logic [DATA_WIDTH-1:0]  			cs_readdata_i,        // readdata 		 signal from P_tile_ip                    
	 input logic [RESP_WIDTH-1:0]  			cs_resp_i,            // response 		 signal from P_tile_ip
	 
	 output logic[ADDR_WIDTH-1:0]  			cs_address_o,         // address 		 signal to   P_tile_ip
	 output logic[DATA_WIDTH-1:0]  			cs_writedata_o,       // writedata  	 signal to   P_tile_ip
	 output logic 						 			cs_read_o,            // read        	 signal to   P_tile_ip
	 output logic 						 			cs_write_o,           // write      	 signal to   P_tile_ip
	 output logic 						 			cs_burstcount_o,      // burst count   signal to   P_tile_ip 
	 output logic[DATA_WIDTH/8-1:0]			cs_byteenable_o,      // byteenable    signal to   P_tile_ip 
	 // output logic 					    			cs_debugaccess_o,     // debugaccess   signal to   P_tile_ip 
	 
	 input logic [ADDR_WIDTH-1:0]  			hps_address_i,        // address 		 signal from CS bridge
	 input logic [DATA_WIDTH-1:0]  			hps_writedata_i,      // writedata     signal from CS bridge
	 input logic  						 			hps_read_i,           // read    		 signal from CS bridge
	 input logic  						 			hps_write_i,          // write   		 signal from CS bridge
	 input logic  						 			hps_burstcount_i,     // burstcount    signal from CS bridge, it's size is 1 since the path is lightweight
	 input logic [DATA_WIDTH/8-1:0]			hps_byteenable_i,     // byteenable 	 signal from CS bridge
	 // input logic  						 			hps_debugaccess_i,    // debugaccess 	 signal from CS bridge
	 
    output logic 						 			hps_waitrequest_o,    // waitrequest 	  signal to   CS bridge
	 output logic 					    			hps_readdatavalid_o,  // readdatavalid  signal to   CS bridge
	 output logic 						 			hps_writerespvalid_o, // writerespvalid signal to   CS bridge
	 output logic [DATA_WIDTH-1:0] 			hps_readdata_o,       // readdata       signal to   CS bridge
	 output logic [RESP_WIDTH-1:0] 			hps_resp_o,           // resp           signal to   CS bridge
	 
	 // csr interface from hps_lwh2f
	 
	 input logic [CSR_ADDR_WIDTH-1:0]  		 csr_address_i,     // address     signal from h2f_lw interface
	 input logic 							 		 csr_read_i,        // read        signal from h2f_lw interface 
	 input logic 								 	 csr_write_i,       // write       signal from h2f_lw interface 
	 input logic [CSR_DATA_WIDTH-1:0] 		 csr_writedata_i,   // writedata   signal from h2f_lw interface 
	 input logic 							 		 csr_burstcount_i,  // burstcount  signal from h2f_lw interface
	 input logic [CSR_DATA_WIDTH/8-1:0]     csr_byteenable_i,  // byeenable   signal from h2f_lw interface
	 input logic 									 csr_debugaccess_i, // debugaccess signal from h2f_lw interface
	 output logic 									 csr_readdatavalid_o,//readdatavalid signal from h2f_lw interface
	 output logic [CSR_DATA_WIDTH-1:0] 		 csr_readdata_o,    // readdata    signal from h2f_lw interface
	 output logic 									 csr_waitrequest_o,  //waitrequest signal to   h2f_lw interface 

     // AXI-MM clk/rst
     input logic                       axi_mm_clk,
     input logic                       axi_mm_rst,

     // HPS to Configuration Timeout responder interface
     input logic                       hps2cfgto_axi_mm_awvalid,         
     output logic                      hps2cfgto_axi_mm_awready,         
     input logic [AWID_WIDTH-1:0]      hps2cfgto_axi_mm_awid,            
     input logic [AWADDR_WIDTH-1:0]    hps2cfgto_axi_mm_awaddr,          
     input logic [AWUSER_WIDTH-1:0]    hps2cfgto_axi_mm_awuser,          
     input logic [AWLEN_WIDTH-1:0]     hps2cfgto_axi_mm_awlen,           
     input logic [2:0]                 hps2cfgto_axi_mm_awsize,          
     input logic [1:0]                 hps2cfgto_axi_mm_awburst,         
     input logic [2:0]                 hps2cfgto_axi_mm_awprot,          
     input logic                       hps2cfgto_axi_mm_awlock,          
     input logic                       hps2cfgto_axi_mm_wvalid,          
     input logic                       hps2cfgto_axi_mm_wlast,           
     output logic                      hps2cfgto_axi_mm_wready,          
     input logic [WDATA_WIDTH-1:0]     hps2cfgto_axi_mm_wdata,           
     input logic [(WDATA_WIDTH/8)-1:0] hps2cfgto_axi_mm_wstrb,           
     output logic                      hps2cfgto_axi_mm_bvalid,          
     input logic                       hps2cfgto_axi_mm_bready,          
     output logic [BID_WIDTH-1:0]      hps2cfgto_axi_mm_bid,             
     output logic [1:0]                hps2cfgto_axi_mm_bresp,           
     input logic                       hps2cfgto_axi_mm_arvalid,         
     output logic                      hps2cfgto_axi_mm_arready,         
     input logic [ARID_WIDTH-1:0]      hps2cfgto_axi_mm_arid,            
     input logic [ARADDR_WIDTH-1:0]    hps2cfgto_axi_mm_araddr,          
     input logic [ARUSER_WIDTH-1:0]    hps2cfgto_axi_mm_aruser,          
     input logic [ARLEN_WIDTH-1:0]     hps2cfgto_axi_mm_arlen,           
     input logic [2:0]                 hps2cfgto_axi_mm_arsize,          
     input logic [1:0]                 hps2cfgto_axi_mm_arburst,         
     input logic [2:0]                 hps2cfgto_axi_mm_arprot,          
     input logic                       hps2cfgto_axi_mm_arlock,          
     output logic                      hps2cfgto_axi_mm_rvalid,          
     output logic                      hps2cfgto_axi_mm_rlast,           
     input logic                       hps2cfgto_axi_mm_rready,          
     output logic [RID_WIDTH-1:0]      hps2cfgto_axi_mm_rid,             
     output logic [RDATA_WIDTH-1:0]    hps2cfgto_axi_mm_rdata,           
     output logic [1:0]                hps2cfgto_axi_mm_rresp,    

     // Configuration Timeout to BAS initiator interface
     output logic                       cfgto2bas_axi_mm_awvalid,         
     input logic                        cfgto2bas_axi_mm_awready,         
     output logic [AWID_WIDTH-1:0]      cfgto2bas_axi_mm_awid,            
     output logic [AWADDR_WIDTH-1:0]    cfgto2bas_axi_mm_awaddr,          
     output logic [AWUSER_WIDTH-1:0]    cfgto2bas_axi_mm_awuser,          
     output logic [AWLEN_WIDTH-1:0]     cfgto2bas_axi_mm_awlen,           
     output logic [2:0]                 cfgto2bas_axi_mm_awsize,          
     output logic [1:0]                 cfgto2bas_axi_mm_awburst,         
     output logic [2:0]                 cfgto2bas_axi_mm_awprot,          
     output logic                       cfgto2bas_axi_mm_awlock,          
     output logic                       cfgto2bas_axi_mm_wvalid,          
     output logic                       cfgto2bas_axi_mm_wlast,           
     input logic                        cfgto2bas_axi_mm_wready,          
     output logic [WDATA_WIDTH-1:0]     cfgto2bas_axi_mm_wdata,           
     output logic [(WDATA_WIDTH/8)-1:0] cfgto2bas_axi_mm_wstrb,           
     input logic                        cfgto2bas_axi_mm_bvalid,          
     output logic                       cfgto2bas_axi_mm_bready,          
     input logic [BID_WIDTH-1:0]        cfgto2bas_axi_mm_bid,             
     input logic [1:0]                  cfgto2bas_axi_mm_bresp,           
     output logic                       cfgto2bas_axi_mm_arvalid,         
     input logic                        cfgto2bas_axi_mm_arready,         
     output logic [ARID_WIDTH-1:0]      cfgto2bas_axi_mm_arid,            
     output logic [ARADDR_WIDTH-1:0]    cfgto2bas_axi_mm_araddr,          
     output logic [ARUSER_WIDTH-1:0]    cfgto2bas_axi_mm_aruser,          
     output logic [ARLEN_WIDTH-1:0]     cfgto2bas_axi_mm_arlen,           
     output logic [2:0]                 cfgto2bas_axi_mm_arsize,          
     output logic [1:0]                 cfgto2bas_axi_mm_arburst,         
     output logic [2:0]                 cfgto2bas_axi_mm_arprot,          
     output logic                       cfgto2bas_axi_mm_arlock,          
     input logic                        cfgto2bas_axi_mm_rvalid,          
     input logic                        cfgto2bas_axi_mm_rlast,           
     output logic                       cfgto2bas_axi_mm_rready,          
     input logic [RID_WIDTH-1:0]        cfgto2bas_axi_mm_rid,             
     input logic [RDATA_WIDTH-1:0]      cfgto2bas_axi_mm_rdata,           
     input logic [1:0]                  cfgto2bas_axi_mm_rresp,        

	 // hip status sideband interface
	 input logic 						   hip_status_linkup,                
	 input logic 						   hip_status_dl_up,
	 input logic 						   hip_status_surprise_down_err,
	 input logic [LTSSM_STATE_WIDTH-1:0]   hip_status_ltssm_state,

     // reset from csr
     output logic csr_axi_st_rst,
     output logic csr_axi_lite_rst
	 );
	 
	 logic 						select;
	 logic 						cs_snoop_readdatavalid_o;          // readdatavalid from config_timeout module
	 logic [DATA_WIDTH-1:0] cs_snoop_readdata_o;               // readdata      from config_timeout module
	 logic [RESP_WIDTH-1:0] cs_snoop_resp_o;                   // response      from config_timeout module
	 logic 						cs_snoop_writerespvalid_o;
	 logic                  cs_snoop_readdatavalid_i;
	 logic                  cs_snoop_writerespvalid_i;
	 logic                  cs_snoop_waitrequest_i;
	 logic 						cs_snoop_read_i;
	 logic 						cs_snoop_write_i;
	 logic [ADDR_WIDTH-1:0] cs_snoop_address_i;
	 
	 // pass through logic from CS bridge to P_tile ip
	 assign hps_waitrequest_o = cs_waitrequest_i;
	 assign cs_address_o      = hps_address_i;
	 assign cs_writedata_o    = hps_writedata_i;
	 assign cs_read_o         = hps_read_i;
	 assign cs_write_o        = hps_write_i;
	 assign cs_burstcount_o   = hps_burstcount_i;
	 assign cs_byteenable_o   = hps_byteenable_i;
	 // assign cs_debugaccess_o  = hps_debugaccess_i;
	 
	 configuration_timeout #( .CSR_ADDR_WIDTH(CSR_ADDR_WIDTH)
	                     ) u0 (.clk_i(clk_i), 
	                           .rstn_i(rstn_i),
										.cs_snoop_resp_i(cs_resp_i), 
										.cs_snoop_waitrequest_i(cs_waitrequest_i), 
										.cs_snoop_readdatavalid_i(cs_readdatavalid_i),
										.cs_snoop_writerespvalid_i(cs_writerespvalid_i),
										.cs_snoop_read_i(hps_read_i),
										.cs_snoop_write_i(hps_write_i),
										.cs_snoop_address_i(hps_address_i),
										.cs_snoop_readdatavalid_o(cs_snoop_readdatavalid_o),
										.cs_snoop_readdata_o(cs_snoop_readdata_o),                             
										.cs_snoop_resp_o(cs_snoop_resp_o),
										.cs_snoop_writerespvalid_o(cs_snoop_writerespvalid_o),	
										.mux_sel(select),
										.csr_address_i(csr_address_i),
										.csr_read_i(csr_read_i),
										.csr_write_i(csr_write_i),
										.csr_writedata_i(csr_writedata_i),
										.csr_readdatavalid_o(csr_readdatavalid_o),
										.csr_readdata_o(csr_readdata_o),
										.csr_burstcount_i(csr_burstcount_i),
						            .csr_byteenable_i(csr_byteenable_i),
										.csr_debugaccess_i(csr_debugaccess_i),
										.csr_waitrequest_o(csr_waitrequest_o),

                                         .axi_mm_clk     (axi_mm_clk    ), 
                                         .axi_mm_rst     (axi_mm_rst    ),

                                         .hps2cfgto_axi_mm_awvalid (hps2cfgto_axi_mm_awvalid),
                                         .hps2cfgto_axi_mm_awready (hps2cfgto_axi_mm_awready),
                                         .hps2cfgto_axi_mm_awid    (hps2cfgto_axi_mm_awid   ),
                                         .hps2cfgto_axi_mm_awaddr  (hps2cfgto_axi_mm_awaddr ),
                                         .hps2cfgto_axi_mm_awuser  (hps2cfgto_axi_mm_awuser ),
                                         .hps2cfgto_axi_mm_awlen   (hps2cfgto_axi_mm_awlen  ),
                                         .hps2cfgto_axi_mm_awsize  (hps2cfgto_axi_mm_awsize ),
                                         .hps2cfgto_axi_mm_awburst (hps2cfgto_axi_mm_awburst),
                                         .hps2cfgto_axi_mm_awprot  (hps2cfgto_axi_mm_awprot ),
                                         .hps2cfgto_axi_mm_awlock  (hps2cfgto_axi_mm_awlock ),
                                         .hps2cfgto_axi_mm_wvalid  (hps2cfgto_axi_mm_wvalid ),
                                         .hps2cfgto_axi_mm_wlast   (hps2cfgto_axi_mm_wlast  ),
                                         .hps2cfgto_axi_mm_wready  (hps2cfgto_axi_mm_wready ),
                                         .hps2cfgto_axi_mm_wdata   (hps2cfgto_axi_mm_wdata  ),
                                         .hps2cfgto_axi_mm_wstrb   (hps2cfgto_axi_mm_wstrb  ),
                                         .hps2cfgto_axi_mm_bvalid  (hps2cfgto_axi_mm_bvalid ),
                                         .hps2cfgto_axi_mm_bready  (hps2cfgto_axi_mm_bready ),
                                         .hps2cfgto_axi_mm_bid     (hps2cfgto_axi_mm_bid    ),
                                         .hps2cfgto_axi_mm_bresp   (hps2cfgto_axi_mm_bresp  ),
                                         .hps2cfgto_axi_mm_arvalid (hps2cfgto_axi_mm_arvalid),
                                         .hps2cfgto_axi_mm_arready (hps2cfgto_axi_mm_arready),
                                         .hps2cfgto_axi_mm_arid    (hps2cfgto_axi_mm_arid   ),
                                         .hps2cfgto_axi_mm_araddr  (hps2cfgto_axi_mm_araddr ),
                                         .hps2cfgto_axi_mm_aruser  (hps2cfgto_axi_mm_aruser ),
                                         .hps2cfgto_axi_mm_arlen   (hps2cfgto_axi_mm_arlen  ),
                                         .hps2cfgto_axi_mm_arsize  (hps2cfgto_axi_mm_arsize ),
                                         .hps2cfgto_axi_mm_arburst (hps2cfgto_axi_mm_arburst),
                                         .hps2cfgto_axi_mm_arprot  (hps2cfgto_axi_mm_arprot ),
                                         .hps2cfgto_axi_mm_arlock  (hps2cfgto_axi_mm_arlock ),
                                         .hps2cfgto_axi_mm_rvalid  (hps2cfgto_axi_mm_rvalid ),
                                         .hps2cfgto_axi_mm_rlast   (hps2cfgto_axi_mm_rlast  ),
                                         .hps2cfgto_axi_mm_rready  (hps2cfgto_axi_mm_rready ),
                                         .hps2cfgto_axi_mm_rid     (hps2cfgto_axi_mm_rid    ),
                                         .hps2cfgto_axi_mm_rdata   (hps2cfgto_axi_mm_rdata  ),
                                         .hps2cfgto_axi_mm_rresp   (hps2cfgto_axi_mm_rresp  ),

                                         .cfgto2bas_axi_mm_awvalid (cfgto2bas_axi_mm_awvalid),
                                         .cfgto2bas_axi_mm_awready (cfgto2bas_axi_mm_awready),
                                         .cfgto2bas_axi_mm_awid    (cfgto2bas_axi_mm_awid   ),
                                         .cfgto2bas_axi_mm_awaddr  (cfgto2bas_axi_mm_awaddr ),
                                         .cfgto2bas_axi_mm_awuser  (cfgto2bas_axi_mm_awuser ),
                                         .cfgto2bas_axi_mm_awlen   (cfgto2bas_axi_mm_awlen  ),
                                         .cfgto2bas_axi_mm_awsize  (cfgto2bas_axi_mm_awsize ),
                                         .cfgto2bas_axi_mm_awburst (cfgto2bas_axi_mm_awburst),
                                         .cfgto2bas_axi_mm_awprot  (cfgto2bas_axi_mm_awprot ),
                                         .cfgto2bas_axi_mm_awlock  (cfgto2bas_axi_mm_awlock ),
                                         .cfgto2bas_axi_mm_wvalid  (cfgto2bas_axi_mm_wvalid ),
                                         .cfgto2bas_axi_mm_wlast   (cfgto2bas_axi_mm_wlast  ),
                                         .cfgto2bas_axi_mm_wready  (cfgto2bas_axi_mm_wready ),
                                         .cfgto2bas_axi_mm_wdata   (cfgto2bas_axi_mm_wdata  ),
                                         .cfgto2bas_axi_mm_wstrb   (cfgto2bas_axi_mm_wstrb  ),
                                         .cfgto2bas_axi_mm_bvalid  (cfgto2bas_axi_mm_bvalid ),
                                         .cfgto2bas_axi_mm_bready  (cfgto2bas_axi_mm_bready ),
                                         .cfgto2bas_axi_mm_bid     (cfgto2bas_axi_mm_bid    ),
                                         .cfgto2bas_axi_mm_bresp   (cfgto2bas_axi_mm_bresp  ),
                                         .cfgto2bas_axi_mm_arvalid (cfgto2bas_axi_mm_arvalid),
                                         .cfgto2bas_axi_mm_arready (cfgto2bas_axi_mm_arready),
                                         .cfgto2bas_axi_mm_arid    (cfgto2bas_axi_mm_arid   ),
                                         .cfgto2bas_axi_mm_araddr  (cfgto2bas_axi_mm_araddr ),
                                         .cfgto2bas_axi_mm_aruser  (cfgto2bas_axi_mm_aruser ),
                                         .cfgto2bas_axi_mm_arlen   (cfgto2bas_axi_mm_arlen  ),
                                         .cfgto2bas_axi_mm_arsize  (cfgto2bas_axi_mm_arsize ),
                                         .cfgto2bas_axi_mm_arburst (cfgto2bas_axi_mm_arburst),
                                         .cfgto2bas_axi_mm_arprot  (cfgto2bas_axi_mm_arprot ),
                                         .cfgto2bas_axi_mm_arlock  (cfgto2bas_axi_mm_arlock ),
                                         .cfgto2bas_axi_mm_rvalid  (cfgto2bas_axi_mm_rvalid ),
                                         .cfgto2bas_axi_mm_rlast   (cfgto2bas_axi_mm_rlast  ),
                                         .cfgto2bas_axi_mm_rready  (cfgto2bas_axi_mm_rready ),
                                         .cfgto2bas_axi_mm_rid     (cfgto2bas_axi_mm_rid    ),
                                         .cfgto2bas_axi_mm_rdata   (cfgto2bas_axi_mm_rdata  ),
                                         .cfgto2bas_axi_mm_rresp   (cfgto2bas_axi_mm_rresp  ),
										 .hip_status_linkup(hip_status_linkup),
										 .hip_status_dl_up(hip_status_dl_up),
										 .hip_status_surprise_down_err(hip_status_surprise_down_err),
										 .hip_status_ltssm_state(hip_status_ltssm_state),
						                 .csr_axi_st_rst(csr_axi_st_rst),
						                 .csr_axi_lite_rst(csr_axi_lite_rst)

);
										
	 multiplexer m0 (.clk_i(clk_i), 
	         .rstn_i(rstn_i),  
	         .cs_readdatavalid_i(cs_readdatavalid_i),
				.cs_writerespvalid_i(cs_writerespvalid_i),
				.cs_readdata_i(cs_readdata_i),                             
				// .cs_resp_i(cs_resp_i), 
				.cs_resp_i(2'h0), // always OK resp 
				.config_readdatavalid_i(cs_snoop_readdatavalid_o),
				.config_writerespvalid_i(cs_snoop_writerespvalid_o),
				.config_readdata_i(cs_snoop_readdata_o),                             
				.config_resp_i(cs_snoop_resp_o),
				.select(select),
				.hps_readdatavalid_o(hps_readdatavalid_o),
				.hps_writerespvalid_o(hps_writerespvalid_o),
				.hps_readdata_o(hps_readdata_o),
				.hps_resp_o(hps_resp_o)
	 );									
										
endmodule								
										
