/**
 * Abstract:  sysrp_bam_bas_traffic_test
   Perform Memory Write Transactions on H2F AVMM BAS interface to Endpoint. ( 1-10 )
   Perform Memory Read Transactions on H2F AVMM BAS interface. 
   Ensure that the Write data and Read data matches. If not error will be reported.
 */
class sysrp_bam_bas_traffic_test extends sysrp_base_test;

  int sequence_length ;
  int pcie_tx_scbd;
  int axi_tx_scbd;

  /** UVM Component Utility macro */
  `uvm_component_utils(sysrp_bam_bas_traffic_test)

  /** Class Constructor */
  function new(string name = "sysrp_bam_bas_traffic_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    pcie_tx_scbd = 1;
    axi_tx_scbd  = 1;

   `uvm_info ("build_phase", "[sysrp_bam_bas_traffic_test] Entered Build Phase...",UVM_LOW);
    super.build_phase(phase);

    uvm_config_db #(int)::set(null,"*","sequence_length",10);
   `uvm_info ("build_phase", "[sysrp_bam_bas_traffic_test] Exiting Build Phase...",UVM_LOW)

    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "pcie_tx_scbd", pcie_tx_scbd);
    uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "axi_tx_scbd", axi_tx_scbd);

  endfunction: build_phase

  task run_phase(uvm_phase phase);
    sysrp_basic_avmm_bas_seq   m_bas_seq;
    sysrp_basic_avmm_bam_seq   m_bam_seq;

    super.run_phase(phase);
    phase.raise_objection(this);

    m_bas_seq = sysrp_basic_avmm_bas_seq::type_id::create("m_bas_seq");
    m_bam_seq = sysrp_basic_avmm_bam_seq::type_id::create("m_bam_seq");

    m_bas_seq.randomize() with {m_bas_seq.sequence_length==10;};
    m_bam_seq.randomize() with {m_bam_seq.sequence_length==10;};

    fork
     begin
	#100ns;
        `uvm_info("INFO", $sformatf("Running RP-to_EP BAS traffic"),UVM_LOW);
         m_bas_seq.start(env.sequencer);	   
     end
     begin
	#100ns;
        `uvm_info("INFO", $sformatf("Running EP-to-RP BAM traffic"),UVM_LOW);
         m_bam_seq.start(env.sequencer);	   
     end
     begin
        wait(`SYSRP_ED_MCDMA_PATH.`PCIE_LINK_UP_O == 1'b1) ;
        enable_vip_protocol_check();
     end
    join
    phase.drop_objection(this);
  endtask : run_phase

endclass
