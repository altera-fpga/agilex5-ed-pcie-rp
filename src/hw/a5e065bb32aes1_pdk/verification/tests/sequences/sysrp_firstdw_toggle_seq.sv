class randomize_byteenable;
  rand bit[3:0] first_byte_enable;
  rand bit[3:0] last_byte_enable;
  rand bit[9:0] length;
  constraint first_byte_enable_valid {
    if(length=='h1)
    {
      first_byte_enable inside {1,2,3,4,5,7,8,10,12,14}; //Non-contiguous Byte Enables (enabled bytes separated by non-enabled bytes) are permitted in the First DW BE field for all Requests with length of 1 DW. Non-contiguous Byte Enable examples: 1010b, 0101b, 1001b, 1011b, 1101b
    }
    else if(length=='h4)
    {
      first_byte_enable inside {8,12,14,15};
    }
    solve length before first_byte_enable;
  }   
  constraint last_byte_enable_valid {
    if(length=='h1)
    {
      last_byte_enable == 'h0;
    }
    else if(length=='h2)
    {
      last_byte_enable inside {1,2,3,4,5,7,8,10,12,14};
    }
    else
    {
      last_byte_enable inside {1,3,7,15};
    }
    solve length before last_byte_enable;
  }   
  constraint length_valid {
    length inside {1,4};
    }  

endclass


class sysrp_firstdw_toggle_seq extends sysrp_base_seq;
  
  //rand int no_of_transactions ;
  rand int sequence_length ;
  rand int trans_no;

  `uvm_object_utils(sysrp_firstdw_toggle_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_firstdw_toggle_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_firstdw_toggle_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_firstdw_toggle_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit[63:0] local_addr[1000];
    bit[9:0] local_len[1000];
    bit[9:0] random_len;
    bit[3:0] local_first_dw_be[1000], local_last_dw_be[1000];
    bit[3:0] first_be,last_be;
    bit[3:0] first_be_read,last_be_read;
    randomize_byteenable obj1,obj2;
    
    svt_pcie_driver_app_mem_request_sequence mem_request_seq;
    
    super.body();

   //-------------------------------------------------------------------------------------------------------------------------
   //Perform Back to Back Memory Write/Read Transactions on F2H AVMM BAM interface from Endpoint with FIRST_DW_BE randomized
   //-------------------------------------------------------------------------------------------------------------------------
   obj1 = new();
   obj2 = new();

   for (int j=0;j<1;j++) begin //{
      trans_no   = 20;
      `uvm_info(get_name(), $psprintf("Loop Number=%0d and Transaction No=%0d", j,trans_no), UVM_LOW)

      for (int i=0;i<trans_no;i++) begin //{
         obj1.randomize();
         first_be   = obj1.first_byte_enable;
         last_be    = obj1.last_byte_enable;
         random_len = obj1.length;
         `uvm_info(get_name(), $psprintf("Loop Number = %0d, Sequence_length_iteration_write = %0d, FIRST_BE = %0h, LAST_BE = %0d, RANDOM_LEN = %0h",j,i,first_be,last_be,random_len), UVM_LOW)
         `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                                      mem_request_seq.address[31:12]     dist {[20'h8_0000 : 20'hA_0000]:= 1,[20'hA_0000 : 20'hF_0000]:= 1};
                                                                                      mem_request_seq.address[11:0]      == 'h0;
                                                                                      mem_request_seq.address[63:32]     == 'h0;
                                                                                      mem_request_seq.length              == random_len;
                                                                                      mem_request_seq.traffic_class       == 0;
                                                                                      mem_request_seq.address_translation == 0;
                                                                                      mem_request_seq.ep                  == 0;
                                                                                      mem_request_seq.th                  == 0;
                                                                                      mem_request_seq.first_dw_be         == first_be; 
                                                                                      mem_request_seq.last_dw_be          == last_be;
                                                                                      mem_request_seq.block               == 1; }); // Must block to avoid r/w collision
         local_addr[i] = mem_request_seq.address;
         local_len[i] = mem_request_seq.length;
         local_first_dw_be[i] = mem_request_seq.first_dw_be;
         local_last_dw_be[i] = mem_request_seq.last_dw_be;
         `uvm_info(get_name(), $psprintf("Loop=%0d, write_no=%0d, addr=%0h, len=%0d, first_dw_be=%0h, last_dw_be=%0h",j , i, local_addr[i], local_len[i], local_first_dw_be[i], local_last_dw_be[i]), UVM_LOW)
     end // } Write loop ending

     #1us;
   
     for (int i=0;i<trans_no;i++) begin //{
        `uvm_info(get_name(), $psprintf("Loop=%0d, read_no=%0d, addr=%0h, len=%0d, first_dw_be=%0h, last_dw_be=%0h", j, i, local_addr[i], local_len[i], local_first_dw_be[i], local_last_dw_be[i]), UVM_LOW)
	if(local_len[i] == 'h1) begin
           first_be_read = 'b1111;
           last_be_read  = 'h0;
        end
	else begin
           first_be_read = 'b1111; 
           last_be_read  = 'b1111; 
        end

        `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                                      mem_request_seq.address             == local_addr[i];
                                                                                      mem_request_seq.length              == local_len[i];
                                                                                      mem_request_seq.traffic_class       == 0;
                                                                                      mem_request_seq.address_translation == 0;
                                                                                      mem_request_seq.ep                  == 0;
                                                                                      mem_request_seq.th                  == 0;
                                                                                      mem_request_seq.first_dw_be         == first_be_read; 
                                                                                      mem_request_seq.last_dw_be          == last_be_read;
                                                                                      mem_request_seq.block               == 1; }); // Must block to avoid r/w collision
     end //} Read loop ending
     #10us;
  end //} //End of all transaction 

   endtask : body

endclass
