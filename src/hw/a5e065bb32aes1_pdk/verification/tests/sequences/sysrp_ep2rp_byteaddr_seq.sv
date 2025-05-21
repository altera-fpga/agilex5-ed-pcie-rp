class sysrp_ep2rp_byteaddr_seq extends sysrp_base_seq;
  
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_ep2rp_byteaddr_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_ep2rp_byteaddr_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_ep2rp_byteaddr_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_ep2rp_byteaddr_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit[31:0] local_addr;
    bit[9:0]  local_len;
    bit[3:0]  local_first_dw_be, local_last_dw_be;

    svt_pcie_driver_app_mem_request_sequence mem_request_seq;
    
    super.body();

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on F2H AVMM BAM interface from Endpoint
     //-----------------------------------------------------------------------------
     for (int i=0;i<20;i++) begin //{ 
        `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
										   mem_request_seq.address[31:12] dist {[20'h8_0000 : 20'hB_0000]:= 1,[20'hB_1000 : 20'hF_0000]:= 1};
										   mem_request_seq.address[11:0] == 'h0;
                                                                                   mem_request_seq.address[63:32] == 'h0;
                                                                                   mem_request_seq.length inside {[2:64]};
                                                                                   mem_request_seq.traffic_class == 0;
                                                                                   mem_request_seq.address_translation == 0;
                                                                                   mem_request_seq.ep == 0;
                                                                                   mem_request_seq.th == 0;
                                                                                   mem_request_seq.first_dw_be inside {'b1111, 'b1110, 'b1100, 'b1000};
                                                                                   mem_request_seq.last_dw_be inside {'b1111, 'b1110, 'b1100, 'b1000};
                                                                                   mem_request_seq.block == 1; }); //block to avoid r/w collision
     local_addr = mem_request_seq.address;
     local_len = mem_request_seq.length;
     local_first_dw_be = mem_request_seq.first_dw_be;
     local_last_dw_be = mem_request_seq.last_dw_be;

     `uvm_info(get_name(), $psprintf("Transaction number = %0d, Local_addr = %0h, Local_len = %0d, Local_first_dw_be = %0h, Local_last_dw_be = %0h", i, local_addr, local_len, local_first_dw_be, local_last_dw_be), UVM_LOW)
     #200ns;
   
     `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                                   mem_request_seq.address == local_addr;
                                                                                   mem_request_seq.length == local_len;
                                                                                   mem_request_seq.traffic_class == 0;
                                                                                   mem_request_seq.address_translation == 0;
                                                                                   mem_request_seq.ep == 0;
                                                                                   mem_request_seq.th == 0;
                                                                                   mem_request_seq.first_dw_be == local_first_dw_be;
                                                                                   mem_request_seq.last_dw_be == local_last_dw_be;
                                                                                   mem_request_seq.block == 1; }); //block to avoid r/w collision
     
       end //}
       #5us;
       
   endtask : body

endclass
