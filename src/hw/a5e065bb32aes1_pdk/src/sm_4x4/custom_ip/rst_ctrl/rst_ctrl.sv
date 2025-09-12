//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2021 Intel Corporation.
//
//****************************************************************************

// Copyright 2020 Intel Corporation.
//
// THIS SOFTWARE MAY CONTAIN PREPRODUCTION CODE AND IS PROVIDED BY THE
// COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Description
//-----------------------------------------------------------------------------
//
//   System reset controller
//
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Module ports
//-----------------------------------------------------------------------------

module rst_ctrl #(
   parameter  HIP_COM = "HIP_NATIVE"
)
(
   input    clk_sys,             // Global clock
   input    clk_100m,            // Clock 100 MHz
   input    pcie_reset_status,   // PCIe SRC reset status
   input    pcie_cold_rst_ack_n, // PCIe cold reset ack (active low)
   input    pcie_warm_rst_ack_n, // PCIe warm reset ack (active low),
   input    pll_locked_i,
   input    initiate_warmrst_req,
   output   initiate_rst_req_rdy,

   input    csr_axi_st_rst,      // csr soft rst (bypass reset handshakes)
   input    csr_axi_lite_rst,    // csr soft rst (bypass reset handshakes)

   input    ninit_done,          // FPGA initialization done (active low)
   output   pll_locked_o,
   output   rst_n_sys,           // System reset synchronous to clk_sys 
   output   rst_n_100m,          // System reset synchronous to clk_100m
   output   pwr_good_n,          // Hardware reset synchronous to clk_sys
   output   pcie_cold_rst_n,     // PCIe cold reset synchronous to clk_sys
   output   pcie_warm_rst_n      // PCIe warm reset synchronous to clk_sys
);

//--------------------------------------------------------------------------
// Reset inputs 
//--------------------------------------------------------------------------
wire  rst_n, rst_n_sync, rst_n_sys_i, rst_n_100m_i;
wire  npor;
logic pll_locked;
logic pll_locked_sys, pll_locked_100m, pll_locked_sys_sync, pll_locked_100m_sync;

assign pll_locked_o = pll_locked_i;

generate
   if (HIP_COM == "HIP_NATIVE") begin
      assign pll_locked = 1'b1;
      assign rst_n_sys_i = npor && pll_locked && ~pcie_reset_status;
      assign rst_n_100m_i = npor && pll_locked && ~pcie_reset_status;
      // assign pll_locked_sys = pll_locked;
   end else begin
      // assign pll_locked = pll_locked_i;

      altera_std_synchronizer clk_sys_pll_locked   ( .clk(clk_sys),     .reset_n(1'b1), .din(pll_locked_i), .dout(pll_locked_sys_sync) );

      always_ff@(posedge clk_sys)
      begin
            pll_locked_sys <= (pll_locked_sys_sync === 1'b1) ? 1'b1 : 1'b0;
      end

      altera_std_synchronizer clk_100m_pll_locked   ( .clk(clk_100m),     .reset_n(1'b1), .din(pll_locked_i), .dout(pll_locked_100m_sync) );

      always_ff@(posedge clk_100m)
      begin
            pll_locked_100m <= (pll_locked_100m_sync === 1'b1) ? 1'b1 : 1'b0;
      end

      assign rst_n_sys_i = npor && pll_locked_sys && ~pcie_reset_status;
      assign rst_n_100m_i = npor && pll_locked_100m && ~pcie_reset_status;
   end
endgenerate


assign initiate_rst_req_rdy = initiate_warmrst_req;

assign npor  = ~ninit_done; 
// assign rst_n = npor && pll_locked && ~pcie_reset_status;

fim_resync #(
   .SYNC_CHAIN_LENGTH(3),
   .WIDTH(1),
   .INIT_VALUE(0),
   .NO_CUT(1)
) rst_in_resync (
   .clk   (clk_sys),
   .reset (~rst_n_sys_i),
   .d     (1'b1),
   .q     (rst_n_sync)
);

// Configuration reset release IP
// reset release IP used in HWT
//`ifdef SIM_MODE
//   assign ninit_done = 1'b0;
//`else
//   cfg_mon cfg_mon (
//      .ninit_done (ninit_done)
//   );
//`endif

//--------------------------------------------------------------------------
// PCIe reset control
//--------------------------------------------------------------------------
logic pcie_cold_rst_ack_n_sync;
logic pcie_warm_rst_ack_n_sync;
logic pcie_rst_ack;
logic pcie_rst_release;
logic pcie_rst_n;
logic fim_rst_n;

`ifdef INCLUDE_PCIE_SS
   fim_resync #(
      .SYNC_CHAIN_LENGTH(3),
      .WIDTH(2),
      .INIT_VALUE(0),
      .NO_CUT(1)
   ) pcie_cold_rst_ack_sync (
      .clk   (clk_sys),
      .reset (1'b0),
      .d     ({pcie_cold_rst_ack_n, pcie_warm_rst_ack_n}),
      .q     ({pcie_cold_rst_ack_n_sync, pcie_warm_rst_ack_n_sync})
   );
`else
   assign pcie_cold_rst_ack_n_sync = pcie_rst_n;
   assign pcie_warm_rst_ack_n_sync = pcie_rst_n;
`endif

assign pcie_rst_ack = (~pcie_cold_rst_ack_n_sync && ~pcie_warm_rst_ack_n_sync);
assign pcie_rst_release = (pcie_rst_n && pcie_cold_rst_ack_n_sync && pcie_warm_rst_ack_n_sync);

//------------------
// PCIe reset
//    Activate PCIe cold/warm reset when reset input is active
//    Wait for PCIe cold/warm reset ack
//    Release PCIe cold/warm reset
//------------------
always_ff @(posedge clk_sys) begin
   if (~rst_n_sync) begin
      pcie_rst_n <= 1'b0;
   end else begin
     if (~pcie_rst_n && pcie_rst_ack) begin
         pcie_rst_n <= 1'b1;
     end
   end
end
//------------------
// FIM reset
//    Activate FIM reset when reset input is active
//    Wait for PCIe reset to be released
//    Release FIM reset
//------------------
always_ff @(posedge clk_sys) begin
   if (~rst_n_sync) begin
      fim_rst_n  <= 1'b0;
   end else begin
      if (~fim_rst_n && pcie_rst_release) begin
         fim_rst_n <= 1'b1;
      end
   end
end

//--------------------------------------------------------------------------
// Reset output
//--------------------------------------------------------------------------

// PCIe cold/warm reset
assign pcie_cold_rst_n = pcie_rst_n;
assign pcie_warm_rst_n = pcie_rst_n;

// FIM reset synchronous to clk_sys
fim_resync #(
   .SYNC_CHAIN_LENGTH(3),
   .WIDTH(1),
   .INIT_VALUE(0),
   .NO_CUT(1)
) rst_clk_sys_resync (
   .clk   (clk_sys),
   .reset (~rst_n_sys_i | ~fim_rst_n | csr_axi_st_rst),
   .d     (1'b1),
   .q     (rst_n_sys)
);

// FIM reset synchronous to clk_100m 
fim_resync #(
   .SYNC_CHAIN_LENGTH(3),
   .WIDTH(1),
   .INIT_VALUE(0),
   .NO_CUT(1)
) rst_clk100m_resync (
   .clk   (clk_100m),
   .reset (~rst_n_100m_i | ~fim_rst_n | csr_axi_lite_rst),
   .d     (1'b1),
   .q     (rst_n_100m)
);

// fim_resync #(
//    .SYNC_CHAIN_LENGTH(3),
//    .WIDTH(1),
//    .INIT_VALUE(0),
//    .NO_CUT(1)
// ) pwr_good_n_resync (
//    .clk   (clk_sys),
//    .reset (~pll_locked_sys | ninit_done),
//    .d     (1'b1),
//    .q     (pwr_good_n)
// );

endmodule
