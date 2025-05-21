/**
 * Abstract: sysrp_stress_test 
   Perform b2b Memory Write/Read Transactions on H2F AVMM BAS interface to Endpoint. Ensure that AXI MM Master toggles the ready randomly.
   Perform b2b Memory Write/Read Transactions on AVMM BAM interface to HPS System memory. Ensure that the AXI MM Slave toggles the ready randomly.
   Both the above mentioned transactions are performed in parallel.
   Ensure that data integrity errors are not seen and interrupts are generated properly for the given address.
"
**/

`include "sysrp_pcie_shared_cfg.sv"
class sysrp_stress_test extends sysrp_base_test;
   int sequence_length ;
   int pcie_tx_scbd;
   int axi_tx_scbd;

   /** UVM Component Utility macro */
   `uvm_component_utils(sysrp_stress_test)

   /** Class Constructor */
   function new(string name = "sysrp_stress_test", uvm_component parent=null);
      super.new(name,parent);
   endfunction: new


  virtual function void build_phase(uvm_phase phase);
     pcie_tx_scbd = 1;
     axi_tx_scbd  = 1;

     `uvm_info ("build_phase", "[sysrp_stress_test] Entered Build Phase...",UVM_LOW);
     super.build_phase(phase);

     uvm_config_db #(int)::set(null,"*","sequence_length",10);
     `uvm_info ("build_phase", "[sysrp_stress_test] Exiting Build Phase...",UVM_LOW)
     uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "pcie_tx_scbd", pcie_tx_scbd);
     uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "axi_tx_scbd", axi_tx_scbd);
  endfunction: build_phase


  task run_phase(uvm_phase phase);
     sysrp_stress_seq m_seq;

     super.run_phase(phase);
     phase.raise_objection(this);

     uvm_config_db#(int)::get(null, "", "sequence_length", sequence_length);
     m_seq = sysrp_stress_seq::type_id::create("m_seq");
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
