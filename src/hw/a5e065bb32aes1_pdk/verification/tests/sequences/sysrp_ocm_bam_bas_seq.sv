class sysrp_ocm_bam_bas_seq extends sysrp_base_seq;
  
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_ocm_bam_bas_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_ocm_bam_bas_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_ocm_bam_bas_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_ocm_bam_bas_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit[63:0] local_addr;
    bit[9:0] local_len;
    bit[3:0] local_first_dw_be, local_last_dw_be;
    svt_pcie_driver_app_mem_request_sequence mem_request_seq;
    bit [31:0] addr;
    bit [5:0] len;
    bit [1023:0] burst_rdata;

    
    super.body();

     //--------------------------------
     //Uptream/BAM writing to OCM
     //--------------------------------
     sequence_length = (sequence_length ==0)? 10 : sequence_length;
     `uvm_info(get_name(), $psprintf("Sequence_length = %0d", sequence_length), UVM_LOW)

     for (int i=0; i<sequence_length; i++) begin //{ 
        `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                          mem_request_seq.address == 'h4000_0000 +i*200;
                                                                          mem_request_seq.length dist {16:=1, 32:=1, 64:=1};
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
     #6us;
       
    //----------------------------------
    //Downstream/BAS writing to OCM
    //----------------------------------
    for (int i=0; i<sequence_length; i++) begin //{ 
	addr = 0 + i*'h200;
        len=$urandom_range(1,8);
        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_write_addr = %0h, h2f_write_len=%0h",i,addr,len), UVM_LOW) 
        h2f_write128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1));

        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_read_addr = %0h, h2f_read_len=%0h",i,addr,len), UVM_LOW)
         h2f_read128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1), .data_(burst_rdata));
        #100ns;
     end //}   
     #8us;

  
   endtask : body

endclass
