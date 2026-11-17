/**
 * Abstract:  sysrp_sanity_test
   Enumerate Rootport and Endpoint through CSR register writes/reads
   Downstream traffic: Perform Memory Write and Read Transactions from Rootport to Endpoint.
   Upstream traffic:   Perform Memory Write and Read Transactions from Endpoint to Rootport. 
   Check transactions in and out of DUT. 
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
    axi_tx_scbd  = 1;

   `uvm_info ("build_phase", "[sysrp_sanity_test] Entered Build Phase...",UVM_LOW);
    super.build_phase(phase);

   `uvm_info ("build_phase", "[sysrp_sanity_test] Exiting Build Phase...",UVM_LOW)

    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "pcie_tx_scbd", pcie_tx_scbd);
    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "axi_tx_scbd", axi_tx_scbd);

  endfunction: build_phase

  task run_phase(uvm_phase phase);
    sysrp_sanity_seq   m_seq;

    super.run_phase(phase);
    phase.raise_objection(this);

    m_seq = sysrp_sanity_seq::type_id::create("m_seq");
    m_seq.randomize() with {m_seq.sequence_length==5;};

    fork
     begin
        `uvm_info("INFO", $sformatf("Running sanity traffic from RP-to-EP and EP-to-RP "),UVM_LOW);
         m_seq.start(env.sequencer);	   
     end
     begin
        wait(`SYSRP_ED_MCDMA_PATH.`PCIE_LINK_UP_O == 1'b1) ;
        enable_vip_protocol_check();
     end
    join
    phase.drop_objection(this);
  endtask : run_phase

endclass
