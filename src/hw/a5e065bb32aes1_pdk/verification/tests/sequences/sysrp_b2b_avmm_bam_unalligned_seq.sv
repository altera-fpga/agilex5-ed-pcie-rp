class randomize_unalligned_addr;
  randc bit[11:0] address;
  randc bit[7:0]  dword_len;
  constraint address_valid {address inside {'h000, 'h004, 'h008, 'h00c, 'h010, 'h014, 'h018, 'h01c, 'h020, 'h024, 'h028, 'h02c, 'h030, 'h034, 'h038, 'h03c, 'h040, 'h044, 'h048, 'h04c, 'h050, 'h054, 'h058, 'h05c, 'h060, 'h064, 'h068, 'h06c, 'h070, 'h074, 'h078, 'h07c, 'h080, 'h084, 'h088, 'h08c, 'h090, 'h094, 'h098, 'h09c, 'h0a0, 'h0a4, 'h0a8, 'h0ac, 'h0b0, 'h0b4, 'h0b8, 'h0bc, 'h0c0, 'h0c4, 'h0c8, 'h0cc, 'h0d0, 'h0d4, 'h0d8, 'h0dc, 'h0e0, 'h0e4, 'h0e8, 'h0ec, 'h0f0, 'h0f4, 'h0f8, 'h0fc, 'h100, 'h104, 'h108, 'h10c, 'h110, 'h114, 'h118, 'h11c, 'h120, 'h124, 'h128, 'h12c, 'h130, 'h134, 'h138, 'h13c, 'h140, 'h144, 'h148, 'h14c, 'h150, 'h154, 'h158, 'h15c, 'h160, 'h164, 'h168, 'h16c, 'h170, 'h174, 'h178, 'h17c, 'h180, 'h184, 'h188, 'h18c, 'h190, 'h194, 'h198, 'h19c, 'h1a0, 'h1a4, 'h1a8, 'h1ac, 'h1b0, 'h1b4, 'h1b8, 'h1bc, 'h1c0, 'h1c4, 'h1c8, 'h1cc, 'h1d0, 'h1d4, 'h1d8, 'h1dc, 'h1e0, 'h1e4, 'h1e8, 'h1ec, 'h1f0, 'h1f4, 'h1f8, 'h1fc};}
  constraint valid_dword_len {dword_len inside {32,48,64,128};}
  
endclass

class sysrp_b2b_avmm_bam_unalligned_seq extends sysrp_base_seq;
  
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_b2b_avmm_bam_unalligned_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_b2b_avmm_bam_unalligned_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_b2b_avmm_bam_unalligned_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_b2b_avmm_bam_unalligned_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit[32:0] local_addr;
    int i;
    bit[19:0] addr;
    bit[11:0] unallign_addr;
    bit[7:0]  dword;
    bit[9:0]  local_len;
    bit[3:0]  local_first_dw_be, local_last_dw_be;
    randomize_unalligned_addr obj;

    
    super.body();

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on F2H AVMM BAM interface from Endpoint
     //-----------------------------------------------------------------------------
      i = 0 ;
      obj = new();
     `uvm_info(get_name(), $psprintf("Sequence_length = %0h", sequence_length), UVM_LOW)

      for(int i=0;i<20;i++)
        begin
          obj.randomize();
          unallign_addr = obj.address;
          dword         = obj.dword_len;
          addr          = $urandom_range('h8_0000,'hF_0000);
         `uvm_info(get_name(), $psprintf("Iteration = %0h Address = %0h Unalligned Addr=%0h",i,addr,unallign_addr), UVM_LOW)
          ep_mem_wr(addr,dword,unallign_addr);
          #200ns;
          ep_mem_rd(addr,dword,unallign_addr);
       end   

  
   endtask : body
  
   task ep_mem_wr(input bit [20:0] addr_, input bit [7:0] length_, input bit [11:0] unallign_addr);
             svt_pcie_driver_app_mem_request_sequence mem_request_seq;
             `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                                                              mem_request_seq.address[31:12] == addr_;
                                                                                                              mem_request_seq.address[11:0] == unallign_addr;
                                                                                                              mem_request_seq.address[63:32] == 'h0;
                                                                                                              mem_request_seq.length == length_;
                                                                                                              mem_request_seq.traffic_class == 0;
                                                                                                              mem_request_seq.address_translation == 0;
                                                                                                              mem_request_seq.ep == 0;
                                                                                                              mem_request_seq.th == 0;
                                                                                                              mem_request_seq.first_dw_be == 'b1111;
                                                                                                              mem_request_seq.last_dw_be == 'b1111;
                                                                                                              mem_request_seq.block == 1; }); // Must block to avoid r/w collision
    endtask : ep_mem_wr
        
    task ep_mem_rd(input bit [31:0] addr_, input bit [7:0] length_, input bit [11:0] unallign_addr);     
             svt_pcie_driver_app_mem_request_sequence mem_request_seq;
             `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                                                              mem_request_seq.address[31:12] == addr_;
                                                                                                              mem_request_seq.address[11:0] == unallign_addr;
                                                                                                              mem_request_seq.address[63:32] == 'h0;
                                                                                                              mem_request_seq.length == length_;
                                                                                                              mem_request_seq.length == length_;
                                                                                                              mem_request_seq.traffic_class == 0;
                                                                                                              mem_request_seq.address_translation == 0;
                                                                                                              mem_request_seq.ep == 0;
                                                                                                              mem_request_seq.th == 0;
                                                                                                              mem_request_seq.first_dw_be == 'b1111;
                                                                                                              mem_request_seq.last_dw_be == 'b1111;
                                                                                                              mem_request_seq.block == 1; }); // Must block to avoid r/w collision
    endtask : ep_mem_rd

endclass
