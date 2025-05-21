class sysrp_rp2ep_dwaddr_seq extends sysrp_base_seq;
    
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_rp2ep_dwaddr_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_rp2ep_dwaddr_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_rp2ep_dwaddr_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_rp2ep_dwaddr_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit [31:0] addr, m_addr;
    bit [5:0]  len;
    bit [1023:0] burst_rdata;
    bit[1:0]   offset;
    int        tdelay;
	  
    super.body();

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on H2F AVMM BAS interface to Endpoint
     //-----------------------------------------------------------------------------
     for(int i=0; i<20; i++) begin  
	m_addr[31:16] = $urandom_range('h1000, 'h1fff);
	m_addr[15:0]  = 0;
	m_addr = m_addr + i*'h400;
	len  = $urandom_range(1,8);
	offset = $urandom_range(0,3);
	tdelay = $urandom_range(1,200);

        addr = m_addr + offset*4;
	len  = $urandom_range(1, 8);
        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_write_addr = %0h, h2f_write_len=%0h",i,addr,len), UVM_LOW) 
        h2f_write128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1));

        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_read_addr = %0h, h2f_read_len=%0h",i,addr,len), UVM_LOW)
        h2f_read128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1), .data_(burst_rdata));
	#(tdelay * 1ns);
     end
   
   endtask:body

endclass
