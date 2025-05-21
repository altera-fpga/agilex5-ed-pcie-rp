/**
 * Abstract:  sysrp_ep2rp_bam_midpkts_mwr_bp_perf_test
   Perform Memory Write Transactions on AVMM BAM interface to HPS System memory. 
   Perform Memory Read Transactions on AVMM BAM interface.
   Ensure that the Write data and Read data matches. If not error will be reported.
 */

class sysrp_ep2rp_bam_midpkts_mwr_bp_perf_test extends sysrp_base_test;
  int sequence_length ;
  int pcie_tx_scbd;
  int axi_tx_scbd;

  /** UVM Component Utility macro */
  `uvm_component_utils(sysrp_ep2rp_bam_midpkts_mwr_bp_perf_test)

  /** Class Constructor */
  function new(string name = "sysrp_ep2rp_bam_midpkts_mwr_bp_perf_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    pcie_tx_scbd = 1;
    axi_tx_scbd  = 0;

   `uvm_info ("build_phase", "[sysrp_ep2rp_bam_m idpkts_mwr_bp_perf_test] Entered Build Phase...",UVM_LOW);
    super.build_phase(phase);

    uvm_config_db #(int)::set(null,"*","sequence_length",120);
   `uvm_info ("build_phase", "[sysrp_ep2rp_bam_midpkts_mwr_bp_perf_test] Exiting Build Phase...",UVM_LOW)

    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "pcie_tx_scbd", pcie_tx_scbd);
    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "axi_tx_scbd", axi_tx_scbd);
  endfunction: build_phase


  task run_phase(uvm_phase phase);
    sysrp_ep2rp_bam_midpkts_mwr_perf_seq m_seq;

    super.run_phase(phase);
    phase.raise_objection(this);

    m_seq = sysrp_ep2rp_bam_midpkts_mwr_perf_seq::type_id::create("m_seq");
    m_seq.randomize() with {m_seq.sequence_length==100;};

    fork
      begin
        `uvm_info("INFO", $sformatf("Running sanity test sequence from TEST RUN PHASE"),UVM_LOW);
        m_seq.start(env.sequencer);	   
      end
      begin
        wait(`SYSRP_ED_MCDMA_PATH.`PCIE_LINK_UP_O == 1'b1);
        enable_vip_protocol_check();
      end
    join

    phase.drop_objection(this);
  endtask : run_phase

endclass
