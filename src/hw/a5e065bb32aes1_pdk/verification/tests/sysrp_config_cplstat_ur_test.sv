/**
 * Abstract:  sysrp_config_cplstat_ur_test
   Perform Config Write/Read transactions to Endpoint BFM via 
   H2F Axi Lite interface. Completions from EP should not be 
   provided and a default response to be given to HPS. 
   For read : 0xFFFF read data to HPS with response as 2’b10 -> SLV ERR
   For write: response as 2’b10 -> SLV ERR
 */

///--- class cs_cplur_pcie_target_callback  ---
class cs_cplur_pcie_target_callback extends svt_pcie_target_app_callback;
   svt_pcie_tlp_exception my_tlp_exc = new("my_tlp_exc");

   `uvm_object_utils(cs_cplur_pcie_target_callback)

   function new(string name ="cs_cplur_pcie_target_callback");
      super.new(name);
   endfunction

   virtual function void pre_tx_tlp_put(svt_pcie_target_app target_app, svt_pcie_tlp transaction, ref bit drop);
     //
     //Convert Cpl/CplD to Cpl with status>0. This means not Successful
     //
     if((transaction.tlp_type == svt_pcie_tlp::CPL) && (transaction.fmt == svt_pcie_tlp::NO_DATA_3_DWORD)) begin 
	//my_tlp_exc.error_kind = svt_pcie_tlp_exception::FORCE_UNSUCCESSFUL_CPL;
	my_tlp_exc.error_kind = svt_pcie_tlp_exception::CORRUPT_CPL_STATUS;
	transaction.fmt = svt_pcie_tlp::NO_DATA_3_DWORD;
	transaction.completion_status = svt_pcie_tlp::UNSUPPORTED_REQ;
     end
     else if((transaction.tlp_type == svt_pcie_tlp::CPL) && (transaction.fmt == svt_pcie_tlp::WITH_DATA_3_DWORD)) begin 
	my_tlp_exc.error_kind = svt_pcie_tlp_exception::CORRUPT_CPL_STATUS;
	transaction.fmt = svt_pcie_tlp::WITH_DATA_3_DWORD;
        transaction.completion_status = svt_pcie_tlp::UNSUPPORTED_REQ;
     end

	`uvm_info(get_type_name(),$sformatf(" SCB:: Pkt received from Callback \n %s",transaction.sprint()),UVM_LOW) 
        drop = 0;
  endfunction: pre_tx_tlp_put

endclass: cs_cplur_pcie_target_callback


///---class sysrp_config_cplstat_ur_test ---
class sysrp_config_cplstat_ur_test extends sysrp_base_test;
   int pcie_tx_scbd;
   int axi_tx_scbd;

   /** UVM Component Utility macro */
   `uvm_component_utils(sysrp_config_cplstat_ur_test)

   cs_cplur_pcie_target_callback cs_cpl_ep_packet;

   /** Class Constructor */
   function new(string name = "sysrp_config_cplstat_ur_test", uvm_component parent=null);
      super.new(name,parent);
   endfunction: new


  virtual function void build_phase(uvm_phase phase);
     pcie_tx_scbd = 0;
     axi_tx_scbd  = 1;

     `uvm_info ("build_phase", "[sysrp_config_cplstat_ur_test] Entered Build Phase...",UVM_LOW);
      super.build_phase(phase);

      uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "pcie_tx_scbd", pcie_tx_scbd);
      uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "axi_tx_scbd", axi_tx_scbd);
      uvm_config_db#(int unsigned)::set(uvm_root::get(), "*", "error_case", 1);

     `uvm_info ("build_phase", "[sysrp_config_cplstat_ur_test] Exiting Build Phase...",UVM_LOW)

  endfunction: build_phase


  task run_phase(uvm_phase phase);
     sysrp_config_timeout1_seq   m_seq1;
     sysrp_config_cplstat_seq    m_seq2;
     
     super.run_phase(phase);
     phase.raise_objection(this);

     m_seq1 = sysrp_config_timeout1_seq::type_id::create("m_seq1");
     m_seq1.randomize() with {m_seq1.mrd_timeout_enb==0;m_seq1.cfg_timeout_enb==0;};
     m_seq2 = sysrp_config_cplstat_seq::type_id::create("m_seq2");

    `uvm_info("INFO", $sformatf("Running traffic sequence PART1"),UVM_LOW);
     m_seq1.start(env.sequencer);  
     #4us;

     `uvm_info("INFO", $sformatf("Completion with UR/CA PART2"),UVM_LOW);
     cs_cpl_ep_packet = new("cs_cpl_ep_packet");
     uvm_callbacks#(svt_pcie_target_app,svt_pcie_target_app_callback)::add(env.endpoint.target[0], cs_cpl_ep_packet);
     #400ns;

     `uvm_info("INFO", $sformatf("Running traffic sequence PART2"),UVM_LOW);
     m_seq2.randomize() with {m_seq2.check_cs_irq_enb==1;};
     m_seq2.start(env.sequencer);
     #8us;

     phase.drop_objection(this);
  endtask : run_phase

endclass
