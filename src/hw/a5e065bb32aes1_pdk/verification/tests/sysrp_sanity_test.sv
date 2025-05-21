/**
 * Abstract: sysrp_sanity_test 
 * A memory write followed by memory read transaction is initiated from both
 * HPS to EP memory and Endpoint to system memory sequentially. This is to make sure atleast one transaction
 * is reaching the destination successfully.
 */

class sysrp_sanity_test extends sysrp_base_test;

	int sequence_length ;
  int pcie_tx_scbd;
  int axi_tx_scbd;

  /** UVM Component Utility macro */
  `uvm_component_utils(sysrp_sanity_test)

  /** Class Constructor */
  function new(string name = "sysrp_sanity_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    pcie_tx_scbd = 1;
    axi_tx_scbd  = 0;

   `uvm_info ("build_phase", "[sysrp_sanity_test] Entered Build Phase...",UVM_LOW);
    super.build_phase(phase);
 	  uvm_config_db #(int)::set(null,"*","sequence_length",2);
   `uvm_info ("build_phase", "[sysrp_sanity_test] Exiting Build Phase...",UVM_LOW)
    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "pcie_tx_scbd", pcie_tx_scbd);
    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "axi_tx_scbd", axi_tx_scbd);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    sysrp_sanity_seq m_seq;
    super.run_phase(phase);
    phase.raise_objection(this);
    uvm_config_db#(int)::get(null, "", "sequence_length", sequence_length);
    m_seq = sysrp_sanity_seq::type_id::create("m_seq");
 	  m_seq.randomize() with {m_seq.sequence_length==sequence_length;};
    `uvm_info("INFO", $sformatf("Running traffic sequence from TEST RUN PHASE"),UVM_LOW);
    m_seq.start(env.sequencer);	   
    phase.drop_objection(this);
  endtask : run_phase

endclass
