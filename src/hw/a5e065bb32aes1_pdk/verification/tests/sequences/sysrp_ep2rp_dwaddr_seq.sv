class sysrp_ep2rp_dwaddr_seq extends sysrp_base_seq;
  
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_ep2rp_dwaddr_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_ep2rp_dwaddr_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_ep2rp_dwaddr_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_ep2rp_dwaddr_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit[31:0] addr;
    bit[7:0]  l_len;
    bit[1:0] offset;

    
    super.body();

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on F2H AVMM BAM interface from Endpoint
     //-----------------------------------------------------------------------------
     for(int i=0; i<20; i++) begin
        offset      = $urandom_range(1,3);
        addr[31:16] = $urandom_range('h8000,'hFFFF);
        addr[15:0]  = i*'h1000 + offset *4;
	l_len       = $urandom_range(2, 128);

       `uvm_info(get_name(), $psprintf("Pkt%0d, Address=0x%0h, length=%0d ",i, addr, l_len), UVM_LOW)
        ep_mem_wr_req(addr, l_len);
        #400ns;
        ep_mem_rd_req(addr, l_len);
     end   
     #4us;

  
   endtask : body
  
endclass
