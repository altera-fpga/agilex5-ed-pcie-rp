/**
 * Abstract: sysrp_basic_ep2rp_bam_test 
   Enumerate Rootport and Endpoint through CSR registers writes/reads
   Upstream traffic: Perform Memory Write and Read Transactions from Endpoint to Rootport/HPS. 
   Check transactions in and out of DUT for correctness. Rrror will be reported if mismatch.
 */

class sysrp_basic_ep2rp_bam_test extends sysrp_base_test;

  int sequence_length ;
  int pcie_tx_scbd;
  int axi_tx_scbd;

  /** UVM Component Utility macro */
  `uvm_component_utils(sysrp_basic_ep2rp_bam_test)

  /** Class Constructor */
  function new(string name = "sysrp_basic_ep2rp_bam_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    pcie_tx_scbd = 1;
    axi_tx_scbd  = 0;

   `uvm_info ("build_phase", "[sysrp_basic_ep2rp_bam_test] Entered Build Phase...",UVM_LOW);
    super.build_phase(phase);

    `uvm_info ("build_phase", "[sysrp_basic_ep2rp_bam_test] Exiting Build Phase...",UVM_LOW)

    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "pcie_tx_scbd", pcie_tx_scbd);
    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "axi_tx_scbd", axi_tx_scbd);
  endfunction: build_phase


  task run_phase(uvm_phase phase);
    sysrp_basic_ep2rp_bam_seq m_seq;

    super.run_phase(phase);
    phase.raise_objection(this);

    m_seq = sysrp_basic_ep2rp_bam_seq::type_id::create("m_seq");
    m_seq.randomize() with {m_seq.sequence_length==10;};

    fork
      begin
        `uvm_info("INFO", $sformatf("Running Endpoint to Rootport traffic"),UVM_LOW);
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
