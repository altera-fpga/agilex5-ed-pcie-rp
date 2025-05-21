/**
 * Abstract:  sysrp_ep2rp_dwaddr_test.sv
   Perform back to back memory write transactions followed by memory read transactions on AVMM BAM 
   interface to HPS System memory. Ensure that the address are unaligned. Ensure that the Write 
   data and Read data matches. If not error will be reported.
 * 
 */

class sysrp_ep2rp_dwaddr_test extends sysrp_base_test;
  int sequence_length ;
  int pcie_tx_scbd;
  int axi_tx_scbd;

  /** UVM Component Utility macro */
  `uvm_component_utils(sysrp_ep2rp_dwaddr_test)

  /** Class Constructor */
  function new(string name = "sysrp_ep2rp_dwaddr_test", uvm_component parent=null);
     super.new(name,parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    `uvm_info ("build_phase", "[sysrp_ep2rp_dwaddr_test] Entered Build Phase...",UVM_LOW);
     super.build_phase(phase);

     uvm_config_db #(int)::set(null,"*","sequence_length",2);
     uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "pcie_tx_scbd", pcie_tx_scbd);
     uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "axi_tx_scbd", axi_tx_scbd);
     uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "unaligned_enb", 1);

    `uvm_info ("build_phase", "[sysrp_ep2rp_dwaddr_test] Exiting Build Phase...",UVM_LOW)
  endfunction: build_phase


  task run_phase(uvm_phase phase);
    sysrp_ep2rp_dwaddr_seq m_seq;
    super.run_phase(phase);

    phase.raise_objection(this);
    uvm_config_db#(int)::get(null, "", "sequence_length", sequence_length);
    m_seq = sysrp_ep2rp_dwaddr_seq::type_id::create("m_seq");
    m_seq.randomize() with {m_seq.sequence_length==sequence_length;};

    fork
       begin
          `uvm_info("INFO", $sformatf("Running sanity test sequence from TEST RUN PHASE"),UVM_LOW);
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
