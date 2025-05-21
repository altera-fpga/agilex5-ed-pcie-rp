class sysrp_b2b_avmm_bas_unalligned_seq extends sysrp_base_seq;
    
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_b2b_avmm_bas_unalligned_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_b2b_avmm_bas_unalligned_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_b2b_avmm_bas_unalligned_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_b2b_avmm_bas_unalligned_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit [31:0] addr;
    bit [5:0] len;
    bit [1023:0] burst_rdata;
    random_unique_address_from_hps addr_obj;
	  
    super.body();

    addr_obj = new();
     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on H2F AVMM BAS interface to Endpoint
     //-----------------------------------------------------------------------------
     
     for (int k=4;k<17;k=k+4) begin  
        for (int i=0;i<10;i++) begin  
           addr_obj.randomize();
           addr=addr_obj.address;
           addr[11:0] = k;
           len=$urandom_range(1,32);
           `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_write_addr = %0h, h2f_write_len=%0h",i,addr,len), UVM_LOW) 
           h2f_write128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1));

           #200ns;

           `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_read_addr = %0h, h2f_read_len=%0h",i,addr,len), UVM_LOW)
           h2f_read128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1), .data_(burst_rdata));
        end 
     end
   
   endtask:body

endclass
