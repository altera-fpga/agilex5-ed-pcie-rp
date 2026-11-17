//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2021 Intel Corporation.
//
//****************************************************************************

//----------------------------------------------------------------
// Project Name: P_tile_rp
// Module Name : configuration_timeout.v
// Author : 
// Description : When the response is not received for Config requests which are non-Posted by default,
// there should be some timer counters to terminate the ongoing transaction and assert a response or 
// create an interrupt to inform HPS
//----------------------------------------------------------------
 
`timescale 1 ns / 1 ps

module configuration_timeout # (
    parameter ADDR_WIDTH         = 14,
    parameter DATA_WIDTH         = 32,
	 parameter RESP_WIDTH         = 2,
    parameter SLAVE_ERROR        = 2'b10, // Error from an endpoint slave. Indicates an unsuccessful transaction.
	 parameter REG_WIDTH          = 32,
	 parameter CSR_ADDR_WIDTH     = 8,
    parameter CSR_DATA_WIDTH     = 32,
	parameter LTSSM_STATE_WIDTH  = 6,
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
    input logic 						clk_i,
    input logic 						rstn_i,
 
    //snoop interface
    input logic 						cs_snoop_waitrequest_i,    //  waitrequest signal from cs interface snooped by this logic
	 input logic 						cs_snoop_readdatavalid_i,  //  readdatavalid signal from cs interface snooped by this logic
	 input logic 						cs_snoop_writerespvalid_i, //  writerespvalid signal from cs interface snooped by this logic
	 input logic 					   cs_snoop_read_i,           //  read signal towards cs interface snooped by this logic
	 input logic 						cs_snoop_write_i,          //  write signal towards cs interface snooped by this logic
	 input logic [ADDR_WIDTH-1:0] cs_snoop_address_i,        //  address signal towards cs interface snooped by this logic
	 input logic [RESP_WIDTH-1:0] cs_snoop_resp_i,           //  resp signal from cs interface snooped by this logic
	 
	 output logic 						cs_snoop_readdatavalid_o,  // readdatavalid signal from this logic to MUX logic
    output logic [DATA_WIDTH-1:0]cs_snoop_readdata_o,       // readdata signal from this logic to MUX logic                           
	 output logic [RESP_WIDTH-1:0]cs_snoop_resp_o,           // resp signal from this logic to MUX logic
	 output logic 						cs_snoop_writerespvalid_o, // writerespvalid signal from this logic to MUX logic
	 output logic 						mux_sel,                   // mux_sel signal from this logic to MUX logic
	 
	 //csr interface
	 input  logic [CSR_ADDR_WIDTH-1:0]  csr_address_i,  		//  address signal from h2f_lw interface
	 input  logic 							   csr_read_i,          //  read signal from h2f_lw interface 
	 input  logic							   csr_write_i,         //  write signal from h2f_lw interface 
	 input  logic [CSR_DATA_WIDTH-1:0]  csr_writedata_i,		//  writedata signal from h2f_lw interface 
	 input  logic 							   csr_burstcount_i,    //  burstcount signal towards h2f_lw interface
	 input  logic [CSR_DATA_WIDTH/8-1:0]csr_byteenable_i,    //  byeenable signal towards h2f_lw interface
	 input  logic 								csr_debugaccess_i,   //  debugaccess signal towards h2f_lw interface
	 output logic 								csr_readdatavalid_o, //  readdatavalid signal towards h2f_lw interface
	 output logic [CSR_DATA_WIDTH-1:0] 	csr_readdata_o, 		//  readdata signal towards h2f_lw interface
	 output logic 								csr_waitrequest_o,   //  waitrequest signal from h2f_lw interface 

	 
	 input logic 								hip_status_linkup,   //  hip_status_sideband signals from P_tile ip
	 input logic 								hip_status_dl_up,
	 input logic 								hip_status_surprise_down_err,
	 input logic [LTSSM_STATE_WIDTH-1:0]hip_status_ltssm_state,

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

     output logic csr_axi_st_rst,
     output logic csr_axi_lite_rst
    );
	 
	  logic [REG_WIDTH-1:0] timeout_reg, timeout_latched, wr_bas_to_count, rd_bas_to_count,
        timeout_mmclk;
	  logic                 mode_enable;     // signal to enable mode under non reset cdn. 
                                            // If this signal is absent, mode will be in read state under reset cdn.	 
														  
	  
	  logic [REG_WIDTH-1:0] count, wr_bas_count,
        rd_bas_count;                       // count has a maximum value of 50,00,000.So 23 bits are needed.Signal will 
                                            // increments upto TIME_OUT until response didn't come
	  logic req_pending_flag;                // asserts whenever read or write request comes and deasserts when it's response comes. 
	  logic mode_wr_not_read;                // signal which indicates read/write operation
	  logic count_equal_tc;                  // signal loads 1 when count reaches timeout
	  logic timeout, wr_bas_timeout, rd_bas_timeout;
	  
      logic [$clog2(H2F_BAS_OUTSTANDING_PKT)-1:0] wr_bas_outstanding, rd_bas_outstanding; //  [PD] check width
      logic wr_bas_pending, wr_bas_pending_sync, rd_bas_pending, rd_bas_pending_sync,
        load_timeout, load_timeout_sync, detect_timeout_mmclk, 
        axi_mm_nonzero_resp, detect_axi_mm_nonzero_resp, detect_axi_mm_nonzero_resp_latched,
        detect_axi_mm_nonzero_resp_clk_i;
      logic [3:0] load_cnt, extend_timeout_cnt, axi_mm_nonzero_cnt;
		logic unused_overf;

      // ---------------------------------------------------------------
      // HPS to Configuration Timeout responder snoop interface

    always@(posedge axi_mm_clk) begin
      if (axi_mm_rst)
        axi_mm_nonzero_resp <= '0;
      else begin
        if (cfgto2bas_axi_mm_bvalid  & cfgto2bas_axi_mm_bready
            & (cfgto2bas_axi_mm_bresp != '0)
            )
          axi_mm_nonzero_resp <= '1;
        else if (cfgto2bas_axi_mm_rvalid  & cfgto2bas_axi_mm_rready
            & (cfgto2bas_axi_mm_rresp != '0)
            )
          axi_mm_nonzero_resp <= '1;
        else         
          axi_mm_nonzero_resp <= '0;
      end // else
    end // always@(posedge axi_mm_clk)

    always@(posedge axi_mm_clk) begin
      if (axi_mm_rst) begin
        axi_mm_nonzero_cnt <= '0;
		  unused_overf <= '0;
      end else begin
        if (axi_mm_nonzero_resp)
          {unused_overf, axi_mm_nonzero_cnt} <= axi_mm_nonzero_cnt + 'h1;
        else if (axi_mm_nonzero_cnt != '0)
          {unused_overf, axi_mm_nonzero_cnt} <= axi_mm_nonzero_cnt + 'h1;
       
        if (axi_mm_nonzero_resp)
          detect_axi_mm_nonzero_resp_latched <= axi_mm_nonzero_resp;
        else if (axi_mm_nonzero_cnt == '0)
          detect_axi_mm_nonzero_resp_latched <= '0;
		end
    end

     altera_std_synchronizer_nocut #(
        .depth (3)
       ,.rst_value (0)
      ) detect_axi_mm_nonzero_resp_synchronizer (
        .clk     (clk_i)
       ,.reset_n (rstn_i)
       ,.din     (detect_axi_mm_nonzero_resp_latched)
       ,.dout    (detect_axi_mm_nonzero_resp_clk_i)
      );

      // pass through
    always_comb begin
      cfgto2bas_axi_mm_awvalid = hps2cfgto_axi_mm_awvalid;   
      hps2cfgto_axi_mm_awready = cfgto2bas_axi_mm_awready;
      cfgto2bas_axi_mm_awid    = hps2cfgto_axi_mm_awid;      
      cfgto2bas_axi_mm_awaddr  = hps2cfgto_axi_mm_awaddr;    
      cfgto2bas_axi_mm_awuser  = hps2cfgto_axi_mm_awuser;    
      cfgto2bas_axi_mm_awlen   = hps2cfgto_axi_mm_awlen;     
      cfgto2bas_axi_mm_awsize  = hps2cfgto_axi_mm_awsize;    
      cfgto2bas_axi_mm_awburst = hps2cfgto_axi_mm_awburst;   
      cfgto2bas_axi_mm_awprot  = hps2cfgto_axi_mm_awprot;    
      cfgto2bas_axi_mm_awlock  = hps2cfgto_axi_mm_awlock;    
      cfgto2bas_axi_mm_wvalid  = hps2cfgto_axi_mm_wvalid;    
      cfgto2bas_axi_mm_wlast   = hps2cfgto_axi_mm_wlast;     
      hps2cfgto_axi_mm_wready  = cfgto2bas_axi_mm_wready;    
      cfgto2bas_axi_mm_wdata   = hps2cfgto_axi_mm_wdata;     
      cfgto2bas_axi_mm_wstrb   = hps2cfgto_axi_mm_wstrb;     
      hps2cfgto_axi_mm_bvalid  =  cfgto2bas_axi_mm_bvalid;    
      cfgto2bas_axi_mm_bready  = hps2cfgto_axi_mm_bready;    
      hps2cfgto_axi_mm_bid     = cfgto2bas_axi_mm_bid   ;    
      hps2cfgto_axi_mm_bresp   = cfgto2bas_axi_mm_bresp ;    
      cfgto2bas_axi_mm_arvalid = hps2cfgto_axi_mm_arvalid;   
      hps2cfgto_axi_mm_arready = cfgto2bas_axi_mm_arready;   
      cfgto2bas_axi_mm_arid    = hps2cfgto_axi_mm_arid;      
      cfgto2bas_axi_mm_araddr  = hps2cfgto_axi_mm_araddr;    
      cfgto2bas_axi_mm_aruser  = hps2cfgto_axi_mm_aruser;    
      cfgto2bas_axi_mm_arlen   = hps2cfgto_axi_mm_arlen;     
      cfgto2bas_axi_mm_arsize  = hps2cfgto_axi_mm_arsize;    
      cfgto2bas_axi_mm_arburst = hps2cfgto_axi_mm_arburst;   
      cfgto2bas_axi_mm_arprot  = hps2cfgto_axi_mm_arprot;    
      cfgto2bas_axi_mm_arlock  = hps2cfgto_axi_mm_arlock;    
      hps2cfgto_axi_mm_rvalid  = cfgto2bas_axi_mm_rvalid;    
      hps2cfgto_axi_mm_rlast   = cfgto2bas_axi_mm_rlast ;    
      cfgto2bas_axi_mm_rready  = hps2cfgto_axi_mm_rready;
      hps2cfgto_axi_mm_rid     = cfgto2bas_axi_mm_rid;       
      hps2cfgto_axi_mm_rdata   = cfgto2bas_axi_mm_rdata;    
      hps2cfgto_axi_mm_rresp   = cfgto2bas_axi_mm_rresp;     
    end
 
      // ---------------------------------------------------------------
      // cs snoop interface

      // disable timeout
	  // assign count_equal_tc   = (count==timeout_reg)?1:0;	

	  assign count_equal_tc = '0;	
   
      // This block determines read or write mode	

	  always@(posedge clk_i) begin  
		if (~rstn_i) begin
	         mode_wr_not_read             <= 0; //In reset cdn, mode should not be in read or write mode
				mode_enable                  <= 0; // A variable called mode_enable will be 0 in reset cdn, and will be 1 in non reset cdn.
      end else if (cs_snoop_read_i && ~cs_snoop_waitrequest_i) begin
		      mode_wr_not_read             <= 0;
				mode_enable                  <= 1;
	   end else if (cs_snoop_write_i && ~cs_snoop_waitrequest_i) begin   // check addrtess is needed in cdn
		      mode_wr_not_read             <= 1;
				mode_enable                  <= 1;
	   end end
		
// This block asserts a req_pending_flag whenever read or write request comes 
// and deasserts when it's response comes.

	 always@(posedge clk_i) begin  
		if (~rstn_i)
				req_pending_flag              <= 0; 
	   else if((cs_snoop_read_i || cs_snoop_write_i) && ~cs_snoop_address_i[13])
		      req_pending_flag              <= 1;
	   else if(cs_snoop_readdatavalid_i || cs_snoop_writerespvalid_i)
		      req_pending_flag              <= 0;
	   else if(count_equal_tc)
		      req_pending_flag              <= 0;
	 end
	 
// This block increments a counter when req_pending_flag signal is high and 
// will reset to zero when read or write response comes. 
 
     /*
	 always@(posedge clk_i) begin
		if (~rstn_i) begin
		      count             <= 'b0;     
		end else if(count_equal_tc) begin
		      count             <= 'b0;
      end else if(cs_snoop_readdatavalid_i || cs_snoop_writerespvalid_i)begin
		      count             <= 'b0;
		end else if(req_pending_flag && ~(cs_snoop_read_i || cs_snoop_write_i))begin 
		      count             <= count+1;
		end else begin
		      count             <= 'b0;
	 end end
	 */

    assign count = '0;

// This block gives out read signals and write signals based on mode.
 
	 always@(posedge clk_i) begin
		if (~rstn_i) begin
            cs_snoop_readdata_o        <= {DATA_WIDTH{1'b0}};
            cs_snoop_resp_o            <= 2'b00;
            cs_snoop_readdatavalid_o   <= 0;
				cs_snoop_writerespvalid_o  <= 0;
				timeout                    <= 0;
				mux_sel                    <= 0; 
		end else if (count_equal_tc & ~mode_wr_not_read & mode_enable ) begin // When response of read didn't happen 
		      cs_snoop_readdata_o        <= {DATA_WIDTH{1'b0}};
		      cs_snoop_resp_o            <= 2'b00; 
            cs_snoop_readdatavalid_o   <= 1;  
				timeout                    <= 1;
	         mux_sel                    <= 1;	
      end else if (count_equal_tc & mode_wr_not_read & mode_enable ) begin // When response of write didn't happen 
		      cs_snoop_resp_o            <= 2'b00;
            cs_snoop_readdatavalid_o   <= 0;   
            cs_snoop_writerespvalid_o  <= 1;	
				timeout                    <= 1;        // timeout will be set if timeout happens. Used to set error status reg value
				mux_sel                    <= 1;
	   end else begin // response of read or write came 
		      cs_snoop_readdata_o        <= {DATA_WIDTH{1'b0}};
            cs_snoop_resp_o            <= 2'b00;
            cs_snoop_readdatavalid_o   <= 0;
				cs_snoop_writerespvalid_o  <= 0;
				timeout                    <= 0;
       		mux_sel                    <= 0; 
		end end
		
 csr_register # ( .CSR_ADDR_WIDTH(CSR_ADDR_WIDTH)
 ) csr (.clk_i(clk_i),
                   .rstn_i(rstn_i),
                   .hip_status_linkup(hip_status_linkup),
                   .hip_status_dl_up (hip_status_dl_up),
						 .hip_status_surprise_down_err(hip_status_surprise_down_err),
						 .hip_status_ltssm_state(hip_status_ltssm_state),
						 .csr_address_i(csr_address_i),
						 .csr_read_i(csr_read_i),
						 .csr_write_i(csr_write_i),
						 .csr_writedata_i(csr_writedata_i),
						 .csr_readdatavalid_o(csr_readdatavalid_o),
						 .csr_readdata_o(csr_readdata_o),
						 .csr_burstcount_i(csr_burstcount_i),
						 .csr_byteenable_i(csr_byteenable_i),
						 .csr_waitrequest_o(csr_waitrequest_o),
				       .csr_debugaccess_i(csr_debugaccess_i),
						 .timeout_reg(timeout_reg),
						 .timeout(timeout),
                         .bas_timeout (1'h0),
                         .bas_ur_ca_error (detect_axi_mm_nonzero_resp_clk_i),
						 .csr_axi_st_rst(csr_axi_st_rst),
						 .csr_axi_lite_rst(csr_axi_lite_rst),
						 .cs_snoop_resp_i(cs_snoop_resp_i));
endmodule
