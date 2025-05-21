class sysrp_stress_seq extends sysrp_base_seq;
  
   //rand int no_of_transactions ;
   rand int sequence_length ;
   rand int trans_no;

   `uvm_object_utils(sysrp_stress_seq);

   /** Declare a typed sequencer object that the sequence can access */
   `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

   function new (string name = "sysrp_stress_seq");
      super.new(name);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
      `uvm_info ("build_phase", "[sysrp_stress_seq] Entered Sequence Build Phase...",UVM_LOW);
      `uvm_info ("build_phase", "[sysrp_stress_seq] Exiting Sequence Build Phase...",UVM_LOW)
   endfunction: build_phase


   task body();
      bit[63:0] local_addr;
      bit[9:0] local_len;
      bit[3:0] local_first_dw_be, local_last_dw_be;
      bit [31:0] addr;
      bit [5:0] len;
      bit [1023:0] burst_rdata;
      random_unique_address_from_hps addr_obj;
      svt_pcie_mem_target_service target_mem_seq;
      svt_pcie_driver_app_mem_request_sequence mem_request_seq;	  

      super.body();

      trans_no=60;
      addr_obj = new();


      fork
         //=================================================================================================
         //Fork 1st process BAM Write/Read
         //=================================================================================================
	 begin  //{
	    for(int i=0;i < trans_no; i++) begin  //{
               `uvm_info(get_name(), $psprintf("Transaction No=%0d",trans_no), UVM_LOW) 
               `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                          mem_request_seq.address[35:12] dist {[24'h08_0000 : 24'h0F_8000]:= 1,[24'h88_0000 : 24'h9F_0000]:= 1};
                                                                          mem_request_seq.address[11:0] == 'h0;
                                                                          mem_request_seq.address[63:36] == 'h0;
                                                                          mem_request_seq.length dist {16:=1, 32:=1, 48:=1, 64:=1,128:=1};
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
	 end // }
         //============================================================================================
         // Fork 2nd Process BAS Write/Read
         //============================================================================================
         begin //{
            for (int j=0; j< trans_no; j++) begin  //{
               addr_obj.randomize();
               addr=addr_obj.address;
               addr[11:0] = 'h0;
               len=$urandom_range(1,32);

              `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_write_addr = %0h, h2f_write_len=%0h",j,addr,len), UVM_LOW) 
               h2f_write128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1));

              `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_read_addr = %0h, h2f_read_len=%0h",j,addr,len), UVM_LOW)
               h2f_read128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1), .data_(burst_rdata));
            end //}
	 end //}
      join

   #20us;

 endtask : body
endclass
