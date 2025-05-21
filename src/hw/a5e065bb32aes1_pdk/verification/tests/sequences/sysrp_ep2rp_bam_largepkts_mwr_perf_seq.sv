class sysrp_ep2rp_bam_largepkts_mwr_perf_seq extends sysrp_base_seq;
  
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_ep2rp_bam_largepkts_mwr_perf_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_ep2rp_bam_largepkts_mwr_perf_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_ep2rp_bam_largepkts_mwr_perf_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_ep2rp_bam_largepkts_mwr_perf_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
     bit[31:0]  addr, dev_ctl_data;
     bit[63:0]  rdata;
     bit[2:0]   max_rd_req, max_pl_size;

     svt_pcie_driver_app_mem_request_sequence mem_request_seq;
    
     super.body();

     //Updated MPS=512B and MRRS-512B
     addr  = 'h2008_0078; 
     max_rd_req   = 3'b010;     
     max_pl_size  = 3'b010;    
     dev_ctl_data = {16'h0, 1'b0, max_rd_req, 3'h0, 1'b0, max_pl_size, 5'b01111}; // Ext tag disable bit 8
     h2f_mem_write32 (.addr_(addr), .data_(dev_ctl_data));
     `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, Writing Device control register of RP=%0h", addr, rdata), UVM_LOW)

     h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, Reading Device control register of RP=%0h", addr, rdata), UVM_LOW)

     #200ns;

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on F2H AVMM BAM interface from Endpoint
     //-----------------------------------------------------------------------------

     sequence_length = (sequence_length ==0)? 200 : sequence_length;
     `uvm_info(get_name(), $psprintf("Sequence_length = %0d", sequence_length), UVM_LOW)

     for (int i=0; i<sequence_length; i++) begin //{ 
        `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
								      mem_request_seq.address[35:12] dist {[24'h08_0000 : 24'h0F_0000]:= 1, [24'h88_0000 : 24'h90_0000]:= 1, [24'h90_0000 : 24'h9F_0000]:= 1};
                                                                      mem_request_seq.address[11:0] == 'h0;
                                                                      mem_request_seq.address[63:36] == 'h0;
                                                                      mem_request_seq.length == 128;
                                                                      mem_request_seq.traffic_class == 0;
                                                                      mem_request_seq.address_translation == 0;
                                                                      mem_request_seq.ep == 0;
                                                                      mem_request_seq.th == 0;
                                                                      mem_request_seq.first_dw_be == 'b1111;
                                                                      mem_request_seq.last_dw_be == 'b1111;
                                                                      mem_request_seq.block == 1; }); // Must block to avoid r/w collision

     end //}
     #40us;
       
   endtask : body

endclass
