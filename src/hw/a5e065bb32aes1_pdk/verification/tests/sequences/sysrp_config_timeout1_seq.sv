class sysrp_config_timeout1_seq extends sysrp_base_seq;
    
  //rand int no_of_transactions ;
  rand int sequence_length ;
  bit      mrd_timeout_enb;
  bit      cfg_timeout_enb;

  `uvm_object_utils(sysrp_config_timeout1_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_config_timeout1_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_config_timeout1_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_config_timeout1_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
     bit [31:0]   addr, wdata, rdata;
	  
     super.body();
     //==========ST added ===============
     //
     // AER register
     // Uncorrectable Error Status Reg
     addr  = 'h2008_0104; 
     h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, rdata=%0h", addr, rdata), UVM_LOW)

     // Uncorrectable Error Mask Reg
     addr  = 'h2008_0108; 
     h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, rdata=%0h", addr, rdata), UVM_LOW)

     // Uncorrectable Error Serverity Reg
     addr  = 'h2008_010C; 
     h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, rdata=%0h", addr, rdata), UVM_LOW)

     // Uncorrectable Error Serverity Reg
     addr  = 'h2008_0110; 
     h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, rdata=%0h", addr, rdata), UVM_LOW)

     // AER Corr Error Mask Reg
     addr  = 'h2008_0114; 
     h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, rdata=%0h", addr, rdata), UVM_LOW)
     #100ns;
     wdata = rdata;
     wdata[13] = 0;
     h2f_mem_write32 (.addr_(addr), .data_(wdata));
     #100ns;
     h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1 2nd: addr=0x%0h, rdata=%0h", addr, rdata), UVM_LOW)

     // Uncorrectable Error Serverity Reg
     addr  = 'h2008_0118; 
     h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, rdata=%0h", addr, rdata), UVM_LOW)

     //===========End =========

     //
     // RP interrupt Enable 
     //
        addr  = 'h1_4150; 
        rp_indirect_read (addr, rdata);
	`uvm_info(get_name(), $psprintf("ST1: addr=0x%0h,1st read RP Interrupt Enable reg=0x%0h", addr, rdata), UVM_LOW)

	wdata = rdata;
	wdata[4] = 'b1;
        rp_indirect_write (addr, wdata);
	#200ns;
        rp_indirect_read (addr, rdata);
	`uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, after write,2nd read RP interrupt enable reg=0x%0h", addr, rdata), UVM_LOW)
	if(rdata !== wdata)
	   `uvm_error(get_name(), $psprintf("ST1 Interrupt Enable 'h1_4150 : Data mismatch Addr=%0h, Exp_data=%0h, Act_data=%0h", addr, wdata, rdata))
     //
     // RP Error Status Enable 
     //
        addr  = 'h1_4158; 
        rp_indirect_read (addr, rdata);
	`uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, 1st read RP Error Status Enable reg=0x%0h", addr, rdata), UVM_LOW)

	wdata = rdata;
	wdata[2:0] = 3'b111;
        rp_indirect_write (addr, wdata);
	#50ns;
        rp_indirect_read (addr, rdata);
	`uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, after write,2nd read RP Error Status Enable reg=0x%0h", addr, rdata), UVM_LOW)
	if(rdata !== wdata)
	   `uvm_error(get_name(), $psprintf("ST1 Interrupt Enable 'h1_4158 : Data mismatch Addr=%0h, Exp_data=%0h, Act_data=%0h", addr, wdata, rdata))
     //
     // RP Error Status Fields
     //
        #200ns;
        addr  = 'h1_4154; 
        rp_indirect_read (addr, rdata);
	`uvm_info(get_name(), $psprintf("ST1 Error Status: addr=0x%0h, 1st read RP Error Status reg=0x%0h", addr, rdata), UVM_LOW)

     #200ns;
   endtask:body

endclass
