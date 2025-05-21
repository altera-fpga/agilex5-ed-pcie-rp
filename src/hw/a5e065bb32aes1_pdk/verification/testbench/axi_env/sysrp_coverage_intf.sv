// Description
//-----------------------------------------------------------------------------
//
//  Coverage Interface for PMCI_SS
//
//-----------------------------------------------------------------------------

interface sysrp_coverage_if;

`define TOP sysrp_top_tb
   
covergroup BAS_RP_to_EP @(posedge `SYSRP_ED_MCDMA_PATH.app_clk);

`ifdef PTILE_4X4
  BAS_TX_BURST_COUNT : coverpoint `SYSRP_ED_MCDMA_PATH.p2_bas_burstcount_i[3:0] iff (`SYSRP_ED_MCDMA_PATH.p2_bas_write_i == 1) {bins bas_rp_to_ep_burst_count[] = {[1:8]};}
  
  BAS_TX_BYTE_ENABLE : coverpoint `SYSRP_ED_MCDMA_PATH.p2_bas_byteenable_i[63:0] iff (`SYSRP_ED_MCDMA_PATH.p2_bas_write_i == 1) {bins bas_rp_to_ep_byteenable[] = {'h0000_0000_0000_ffff,'h0000_0000_ffff_ffff,'h0000_ffff_ffff_ffff,'hffff_ffff_ffff_ffff,'hffff_ffff_ffff_fff0,'hffff_ffff_ffff_ff00,'hffff_ffff_ffff_f000,'hffff_ffff_ffff_0000};}

`endif  

`ifdef PTILE_X16
  BAS_TX_BURST_COUNT : coverpoint `TOP.PCIE_RP_DUT.subsys_pcie.mcdma.bas_burstcount_i[3:0] iff (`TOP.PCIE_RP_DUT.subsys_pcie.mcdma.bas_write_i == 1) {bins bas_rp_to_ep_burst_count[] = {[1:8]};}
  
  BAS_TX_BYTE_ENABLE : coverpoint `TOP.PCIE_RP_DUT.subsys_pcie.mcdma.bas_byteenable_i[63:0] iff (`TOP.PCIE_RP_DUT.subsys_pcie.mcdma.bas_write_i == 1) {bins bas_rp_to_ep_byteenable[] = {'h0000_0000_0000_ffff,'h0000_0000_ffff_ffff,'h0000_ffff_ffff_ffff,'hffff_ffff_ffff_ffff,'hffff_ffff_ffff_fff0,'hffff_ffff_ffff_ff00,'hffff_ffff_ffff_f000,'hffff_ffff_ffff_0000};}

`endif



endgroup

covergroup BAM_EP_to_RP @(posedge `SYSRP_ED_MCDMA_PATH.app_clk);

BAM_RX_BURST_COUNT : coverpoint `SYSRP_ED_MCDMA_PATH.bam_burstcount_o[3:0] iff (`SYSRP_ED_MCDMA_PATH.bam_write_o == 1) {bins bam_rp_to_ep_burst_count[] = {[1:8]};}

BAM_RX_BYTE_ENABLE : coverpoint `SYSRP_ED_MCDMA_PATH.bam_byteenable_o[63:0] iff (`SYSRP_ED_MCDMA_PATH.bam_write_o == 1) {bins bas_rp_to_ep_byteenable[] = {'h0000_0000_0000_ffff,'h0000_0000_ffff_ffff,'h0000_ffff_ffff_ffff,'hffff_ffff_ffff_ffff,'hffff_ffff_ffff_fff0,'hffff_ffff_ffff_ff00,'hffff_ffff_ffff_f000,'hffff_ffff_ffff_0000};}

BAM_RX_ADDRESS : coverpoint `SYSRP_ED_MCDMA_PATH.bam_address_o[63:0] iff (`SYSRP_ED_MCDMA_PATH.bam_write_o == 1 || `SYSRP_ED_MCDMA_PATH.bam_read_o == 1) { bins bam_ep_to_msi_gic_address = {['hf901_8000:'hf901_807f]};//128B Memory
                     bins bam_ep_to_ocm_rp_address  = {['h8000_0000:'h8003_ffff]}; //256k Memory
                     bins bam_ep_to_hps_address     = {['h1000_0000:'hffff_ffff]};}//2G Memory

endgroup

covergroup INTERRUPT_SCENARIO @(posedge `PCIE_SUBSYS.msi_to_gic_gen.msi_to_gic_gen_0.clk);

MSI_INTERRUPT_STATUS_REG : coverpoint `PCIE_SUBSYS.msi_to_gic_gen.msi_to_gic_gen_0.status_reg[31:0] iff (`PCIE_SUBSYS.msi_to_gic_gen.msi_to_gic_gen_0.csr_write == 1) {bins bas_msi_interrupt_status_reg[] = {'h0000_0001,'h0000_0002,'h0000_0004,'h0000_0008,'h0000_0010,'h0000_0020,'h0000_0040,'h0000_0080,'h0000_0100,'h0000_0200,'h0000_0400,'h0000_0800,'h0000_1000,'h0000_2000,'h0000_4000,'h0000_8000,'h0001_0000,'h0002_0000,'h0004_0000,'h0008_0000,'h0010_0000,'h0020_0000,'h0040_0000,'h0080_0000,'h0100_0000,'h0200_0000,'h0400_0000,'h0800_0000,'h1000_0000,'h2000_0000,'h4000_0000,'h8000_0000};}

endgroup

covergroup AXI_Master_to_RP @(posedge sysrp_top_tb.h2f_axi_bfm_INST.axi_if.common_aclk);

AXI_TX_LEN : coverpoint `TOP.h2f_axi_bfm_INST.axi_if.master_if[0].awlen[9:0] iff (`TOP.h2f_axi_bfm_INST.axi_if.master_if[0].awvalid == 1 && sysrp_top_tb.h2f_axi_bfm_INST.axi_if.master_if[0].awready == 1) { bins bas_rp_to_ep_length[] = {[0:31]};}

AXI_TX_ADDRESS : coverpoint `TOP.h2f_axi_bfm_INST.axi_if.master_if[0].awaddr[63:0] iff (`TOP.h2f_axi_bfm_INST.axi_if.master_if[0].awvalid == 1 && sysrp_top_tb.h2f_axi_bfm_INST.axi_if.master_if[0].awready == 1) { bins bas_hps_to_ep_address  = {['h0000_0000:'h0fff_ffff]};//256MB Memory
                            bins bas_hps_to_rp_address  = {['hA000_0000:'hA01f_ffff]}; //2MB Memory
                            bins bas_hps_to_ocm_address = {['h8000_0000:'h8003_ffff]};}//256k Memory

endgroup

BAM_EP_to_RP       bam_ep_to_rp_1    = new();
BAS_RP_to_EP       bas_rp_to_ep_1    = new();
INTERRUPT_SCENARIO interrupt         = new();
AXI_Master_to_RP   axi_master_to_rp  = new();

endinterface
