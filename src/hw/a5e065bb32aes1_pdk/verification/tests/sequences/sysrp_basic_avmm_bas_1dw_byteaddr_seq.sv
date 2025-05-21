class sysrp_basic_avmm_bas_1dw_byteaddr_seq extends sysrp_base_seq;
    
  //rand int no_of_transactions ;
  rand int sequence_length ;

  `uvm_object_utils(sysrp_basic_avmm_bas_1dw_byteaddr_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_basic_avmm_bas_1dw_byteaddr_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_basic_avmm_bas_1dw_byteaddr_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_basic_avmm_bas_1dw_byteaddr_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit [31:0] addr, wdata, rdata;
    bit [5:0] len;
    bit [1023:0] burst_rdata;
    int       k;
	  
    super.body();

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on H2F AVMM BAS interface to Endpoint
     //-----------------------------------------------------------------------------

     for (int i=0;i<10;i++) begin //{ 
	addr[31:12] = 'h1_2345 + i*200;; 
	k = i%4 + 1;
        addr[11:0] = k;
        len = 1;
	wdata = $urandom();

        h2f_mem_write32 (.addr_(addr), .data_(wdata));
	`uvm_info(get_name(), $psprintf("ST1: Transaction number=%0d, h2f_write_addr=0x%0h, h2f_write_data=0x%0h",i,addr,wdata), UVM_LOW)
        #100ns;

         h2f_mem_read32 (.addr_(addr), .data_(rdata));
	 `uvm_info(get_name(), $psprintf("ST1: Transaction number=%0d, h2f_read_addr=0x%0h, h2f_read_data=%0h",i,addr, rdata), UVM_LOW)

	 if(rdata !== wdata)
            `uvm_error(get_name(), $psprintf("Data Mismatch Addr=0x%0h, Exp=0x%0h, Act=0x%0h", addr, wdata, rdata));
     end //}   
     #5us;
   
   endtask:body

endclass
