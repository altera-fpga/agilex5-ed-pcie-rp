/**
 * Abstract: sysrp_512B_mps_256B_mrrs_b2b_avmm_bas_test 
   Perform transactions from HPS to EP with MPS=512bytes and MRRS=256bytes
 */

 class sysrp_512B_mps_256B_mrrs_b2b_avmm_bas_test extends sysrp_base_test;
    int RP_MPS_value ;
    int EP_MPS_value ;
    int MRRS_value ;
    int pcie_tx_scbd;
    int axi_tx_scbd;

    /** UVM Component Utility macro */
    `uvm_component_utils(sysrp_512B_mps_256B_mrrs_b2b_avmm_bas_test)

    /** Class Constructor */
    function new(string name = "sysrp_512B_mps_256B_mrrs_b2b_avmm_bas_test", uvm_component parent=null);
       super.new(name,parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
       int ep_max_payload_size;
       int rp_max_payload_size;
       int max_rd_req;

       pcie_tx_scbd = 0;
       axi_tx_scbd  = 1;

       `uvm_info ("build_phase", "[sysrp_512B_mps_256B_mrrs_b2b_avmm_bas_test] Entered Build Phase...",UVM_LOW);

       super.build_phase(phase);
       ep_max_payload_size = 512;
       rp_max_payload_size = 512;
       max_rd_req = 256;

       uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "mrrs", max_rd_req);
       `uvm_info("body", $sformatf("ENV: max_rd_req %d ", max_rd_req), UVM_LOW);

       uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "ep_mps", ep_max_payload_size);
       `uvm_info("body", $sformatf("ENV: ep_max_payload_size %d ", ep_max_payload_size), UVM_LOW);

       uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "rp_mps", rp_max_payload_size);
       `uvm_info("body", $sformatf("ENV: rp_max_payload_size %d ", rp_max_payload_size), UVM_LOW);

       uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "pcie_tx_scbd", pcie_tx_scbd);
       uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "axi_tx_scbd", axi_tx_scbd);

       `uvm_info ("build_phase", "[sysrp_512B_mps_256B_mrrs_b2b_avmm_bas_test] Exiting Build Phase...",UVM_LOW)
  endfunction: build_phase


  task run_phase(uvm_phase phase);
     sysrp_mps_mrrs_seq m_seq;

     super.run_phase(phase);
     phase.raise_objection(this);

     uvm_config_db #(int unsigned)::get(this, "", "rp_mps", RP_MPS_value);
     uvm_config_db #(int unsigned)::get(this, "", "ep_mps", EP_MPS_value);
     uvm_config_db #(int unsigned)::get(this, "", "mrrs", MRRS_value);

     m_seq = sysrp_mps_mrrs_seq::type_id::create("m_seq");
     m_seq.randomize() with {m_seq.EP_MAX_payload==EP_MPS_value;m_seq.RP_MAX_payload==RP_MPS_value;m_seq.MAX_read_request_size==MRRS_value;};
     `uvm_info("INFO", $sformatf("Running traffic sequence from TEST RUN PHASE"),UVM_LOW);
     m_seq.start(env.sequencer);	   

     phase.drop_objection(this);
  endtask : run_phase

endclass
