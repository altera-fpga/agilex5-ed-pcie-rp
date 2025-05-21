class sysrp_ep2rp_bam_smallpkts_perf_seq extends sysrp_base_seq;
  
  //rand int no_of_transactions ;
  rand int sequence_length ;
  rand bit sel0for2G_sel1for6G;

  `uvm_object_utils(sysrp_ep2rp_bam_smallpkts_perf_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_ep2rp_bam_smallpkts_perf_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_ep2rp_bam_smallpkts_perf_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_ep2rp_bam_smallpkts_perf_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit[63:0] local_addr[$];
    bit[9:0] local_len[$];
    bit[3:0] local_first_dw_be[$], local_last_dw_be[$];

    svt_pcie_driver_app_mem_request_sequence mem_request_seq;
    
    super.body();

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on F2H AVMM BAM interface from Endpoint
     //-----------------------------------------------------------------------------

     sel0for2G_sel1for6G = $urandom_range(0, 1);
     sequence_length = (sequence_length ==0)? 100 : sequence_length;
     `uvm_info(get_name(), $psprintf("ST3: Sequence_length = %0d, sel0for2G_sel1for6G=%0d", sequence_length, sel0for2G_sel1for6G), UVM_LOW)

     for (int i=0; i<sequence_length; i++) begin //{ 
	if(sel0for2G_sel1for6G == 0) begin //{ 2G-32b address
           `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
									      mem_request_seq.address[35:12] dist {[24'h08_0000 : 24'h0B_0000]:= 1,[24'h0B_0000 : 24'h0F_0000]:= 1};
                                                                              mem_request_seq.address[11:0] == 'h0;
                                                                              mem_request_seq.address[63:36] == 'h0;
                                                                              mem_request_seq.length == 4;
                                                                              mem_request_seq.traffic_class == 0;
                                                                              mem_request_seq.address_translation == 0;
                                                                              mem_request_seq.ep == 0;
                                                                              mem_request_seq.th == 0;
                                                                              mem_request_seq.first_dw_be == 'b1111;
                                                                              mem_request_seq.last_dw_be == 'b1111;
                                                                              mem_request_seq.block == 1; }); // Must block to avoid r/w collision

              local_addr[i] = mem_request_seq.address;
              local_len[i] = mem_request_seq.length;
              local_first_dw_be[i] = mem_request_seq.first_dw_be;
              local_last_dw_be[i] = mem_request_seq.last_dw_be;
              `uvm_info(get_name(), $psprintf("Transaction number=%0d, addr=%0h, len=%0d, first_dw_be=%0h, last_dw_be=%0h", i, local_addr[i], local_len[i], local_first_dw_be[i], local_last_dw_be[i]), UVM_LOW)
	end //}
	else begin //{ 6G-36b address
           `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
									      mem_request_seq.address[35:12] dist {[24'h88_0000 : 24'h90_0000]:= 1,[24'h90_0000 : 24'h9F_0000]:= 1};
                                                                              mem_request_seq.address[11:0] == 'h0;
                                                                              mem_request_seq.address[63:36] == 'h0;
                                                                              mem_request_seq.length == 4;
                                                                              mem_request_seq.traffic_class == 0;
                                                                              mem_request_seq.address_translation == 0;
                                                                              mem_request_seq.ep == 0;
                                                                              mem_request_seq.th == 0;
                                                                              mem_request_seq.first_dw_be == 'b1111;
                                                                              mem_request_seq.last_dw_be == 'b1111;
                                                                              mem_request_seq.block == 1; }); // Must block to avoid r/w collision

              local_addr[i] = mem_request_seq.address;
              local_len[i] = mem_request_seq.length;
              local_first_dw_be[i] = mem_request_seq.first_dw_be;
              local_last_dw_be[i] = mem_request_seq.last_dw_be;
              `uvm_info(get_name(), $psprintf("Transaction number=%0d, addr=%0h, len=%0d, first_dw_be=%0h, last_dw_be=%0h", i, local_addr[i], local_len[i], local_first_dw_be[i], local_last_dw_be[i]), UVM_LOW)


        end //}
     end //}

     #2us; //delay between MWr and MRd 
     for (int j=0; j <sequence_length; j++) begin //{
        `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                              mem_request_seq.address == local_addr[j];
                                                                              mem_request_seq.length == local_len[j];
                                                                              mem_request_seq.traffic_class == 0;
                                                                              mem_request_seq.address_translation == 0;
                                                                              mem_request_seq.ep == 0;
                                                                              mem_request_seq.th == 0;
                                                                              mem_request_seq.first_dw_be == local_first_dw_be[j];
                                                                              mem_request_seq.last_dw_be == local_last_dw_be[j];
                                                                              mem_request_seq.block == 1; }); // Must block to avoid r/w collision
     
     end //}
     #20us;
       
   endtask : body

endclass
