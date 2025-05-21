class sysrp_bam_back_pressure_seq extends sysrp_base_seq;
  
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_bam_back_pressure_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_bam_back_pressure_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_bam_back_pressure_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_bam_back_pressure_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit[63:0] l_addr;
    bit[9:0]  l_len;
    bit[3:0]  l_first_dw_be, l_last_dw_be;

    svt_pcie_driver_app_mem_request_sequence mem_request_seq;
    
    super.body();

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on F2H AVMM BAM interface from Endpoint
     //-----------------------------------------------------------------------------
     sequence_length = (sequence_length ==0)? 20 : sequence_length;
     `uvm_info(get_name(), $psprintf("Sequence_length = %0d", sequence_length), UVM_LOW)

     for (int i=0; i<sequence_length; i++) begin //{ 
        `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                      mem_request_seq.address[35:12] dist {[24'h08_0000 : 24'h0B_0000]:= 1,[24'h0B_0000 : 24'h0F_0000]:= 1, [24'h88_0000 : 24'h90_0000]:= 1, [24'h90_0000 : 24'h9F_0000]:= 1};
                                                                      mem_request_seq.address[11:0] == 'h0;
                                                                      mem_request_seq.address[63:36] == 'h0;
                                                                      mem_request_seq.length dist {16:=1, 32:=1, 48:=1, 64:=1, 80:=1, 96:=1, 112:=1, 128:=1};
                                                                      mem_request_seq.traffic_class == 0;
                                                                      mem_request_seq.address_translation == 0;
                                                                      mem_request_seq.ep == 0;
                                                                      mem_request_seq.th == 0;
                                                                      mem_request_seq.first_dw_be == 'b1111;
                                                                      mem_request_seq.last_dw_be == 'b1111;
                                                                      mem_request_seq.block == 1; }); // Must block to avoid r/w collision

           l_addr = mem_request_seq.address;
           l_len = mem_request_seq.length;
           l_first_dw_be = mem_request_seq.first_dw_be;
           l_last_dw_be = mem_request_seq.last_dw_be;
           `uvm_info(get_name(), $psprintf("Transaction=%0d, addr=%0h, len=%0d, first_dw_be=%0h, last_dw_be=%0h", i, l_addr, l_len, l_first_dw_be, l_last_dw_be), UVM_LOW)
   
           `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                      mem_request_seq.address == l_addr;
                                                                      mem_request_seq.length == l_len;
                                                                      mem_request_seq.traffic_class == 0;
                                                                      mem_request_seq.address_translation == 0;
                                                                      mem_request_seq.ep == 0;
                                                                      mem_request_seq.th == 0;
                                                                      mem_request_seq.first_dw_be == l_first_dw_be;
                                                                      mem_request_seq.last_dw_be == l_last_dw_be;
                                                                      mem_request_seq.block == 1; }); // Must block to avoid r/w collision
     end //}
     #18us;

   endtask : body

endclass
