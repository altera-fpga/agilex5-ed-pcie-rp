class sysrp_basic_avmm_bam_seq extends sysrp_base_seq;
  
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_basic_avmm_bam_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_basic_avmm_bam_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_basic_avmm_bam_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_basic_avmm_bam_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit[63:0] local_addr;
    bit[9:0] local_len;
    bit[3:0] local_first_dw_be, local_last_dw_be;

    svt_pcie_driver_app_mem_request_sequence mem_request_seq;
    
    super.body();

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on F2H AVMM BAM interface from Endpoint
     //-----------------------------------------------------------------------------
     sequence_length = (sequence_length ==0)? 20 : sequence_length;
     `uvm_info(get_name(), $psprintf("Sequence_length = %0d", sequence_length), UVM_LOW)

     for (int i=0; i<sequence_length; i++) begin //{ 
    `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                                  mem_request_seq.address[31:12] dist {[20'h8_0000 : 20'hA_0000]:= 1,[20'hA_0000 : 20'hC_0000]:= 1,[20'hD_0000 : 20'hF_0000]:= 1};
                                                                                  mem_request_seq.address[11:0] == 'h0;
                                                                                  mem_request_seq.address[63:32] == 'h0;
                                                                                  mem_request_seq.length dist {16:=1, 32:=1, 48:=1, 64:=1, 80:=1, 96:=1, 112:=1, 128:=1};
                                                                                  mem_request_seq.traffic_class == 0;
                                                                                  mem_request_seq.address_translation == 0;
                                                                                  mem_request_seq.ep == 0;
                                                                                  mem_request_seq.th == 0;
                                                                                  mem_request_seq.first_dw_be == 'b1111;
                                                                                  mem_request_seq.last_dw_be == 'b1111;
                                                                                  mem_request_seq.block == 1; }); // Must block to avoid r/w collision
     local_addr = mem_request_seq.address;
     local_len = mem_request_seq.length;
     local_first_dw_be = mem_request_seq.first_dw_be;
     local_last_dw_be = mem_request_seq.last_dw_be;
     `uvm_info(get_name(), $psprintf("Transaction number = %0d, Local_addr = %0h, Local_len = %0d, Local_first_dw_be = %0h, Local_last_dw_be = %0h", i, local_addr, local_len, local_first_dw_be, local_last_dw_be), UVM_LOW)
   
    `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                                  mem_request_seq.address == local_addr;
                                                                                  mem_request_seq.length == local_len;
                                                                                  mem_request_seq.traffic_class == 0;
                                                                                  mem_request_seq.address_translation == 0;
                                                                                  mem_request_seq.ep == 0;
                                                                                  mem_request_seq.th == 0;
                                                                                  mem_request_seq.first_dw_be == local_first_dw_be;
                                                                                  mem_request_seq.last_dw_be == local_last_dw_be;
                                                                                  mem_request_seq.block == 1; }); // Must block to avoid r/w collision
     
     end //}
     #4us;
       
    //===============================
    //OCM Access done from Endpoint
    //===============================
    `uvm_info(get_name(), "MEM_WR on 'h4000_0000 from Endpoint to OCM RAM", UVM_LOW)
     local_addr = 'h4000_0000;
     ep_mem_wr_req (.addr_(local_addr), .length_(16));
    `uvm_info(get_name(), "MEM_RD on 'h4000_0000 from Endpoint to OCM RAM", UVM_LOW)
     ep_mem_rd_req (.addr_(local_addr), .length_(16));
     #5us;
  
   endtask : body

endclass
