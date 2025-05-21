class sysrp_basic_rp2ep_bas_seq extends sysrp_base_seq;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_basic_rp2ep_bas_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_basic_rp2ep_bas_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_basic_rp2ep_bas_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_basic_rp2ep_bas_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit [31:0] addr, m_addr;
    bit [5:0] len;
    bit [1023:0] burst_rdata;
    int tdelay;
	  
    super.body();

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on H2F AVMM BAS interface to Endpoint
     //-----------------------------------------------------------------------------
     sequence_length = (sequence_length == 0)? 5 : sequence_length;
     `uvm_info(get_name(), $psprintf("Sequence_length = %0d", sequence_length), UVM_LOW)

     for (int i=0; i<sequence_length; i++) begin //{ 
	tdelay = $urandom_range(4,200);
	m_addr[31:16] = $urandom_range('h1000, 'h1FFF);
	m_addr[15:0]  = 0;
	addr = m_addr + i*'h1000;
        len=$urandom_range(1,32);
        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_write_addr = %0h, h2f_write_len=%0h",i,addr,len), UVM_LOW) 
        h2f_write128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1));

        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_read_addr = %0h, h2f_read_len=%0h",i,addr,len), UVM_LOW)
         h2f_read128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1), .data_(burst_rdata));

        #(tdelay *1ns);
     end //}   
     #8us;
   
   endtask:body

endclass
