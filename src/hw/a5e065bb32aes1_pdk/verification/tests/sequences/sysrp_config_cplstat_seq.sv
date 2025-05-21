class sysrp_config_cplstat_seq extends sysrp_base_seq;
    
  rand int sequence_length ;
  rand bit check_cs_irq_enb;

  `uvm_object_utils(sysrp_config_cplstat_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_config_cplstat_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_config_cplstat_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_config_cplstat_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
     bit [31:0]   addr, m_addr;
     bit [63:0] wdata, rdata, wdata_BE, rdata_BE;
     bit [5:0]    len;
     bit [1023:0] burst_rdata;
     int tdelay;

        `uvm_info(get_name(), $psprintf("ST1: Starting PART2 i=%d", 2), UVM_LOW)
    	// Program EP Bar0 register
	//
        addr  = 'h2001_0010; //'h2001_0010;
        wdata = 'hFFFF_FFFF;
        wdata_BE = changeEndian(wdata[31:0]);
       `uvm_info(get_name(), "ST1b: Writing BAR0 with FFFF_FFFF and reading", UVM_LOW)
        mmio_write64(.addr_(addr), .data_(wdata_BE));
        #50;
        mmio_read64 (.addr_(addr), .data_(rdata));
        rdata_BE = changeEndian(rdata[31:0]);
       `uvm_info(get_name(), $psprintf("ST1b: BAR0 READATA: addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)
        #200ns;
	if(check_cs_irq_enb)  read_clear_errstat_reg();
        
        // Reading EP Command Register 
        //
        addr  = 'h2001_0004; //'h2001_0004;
        mmio_read64 (.addr_(addr), .data_(rdata));
        rdata_BE = changeEndian(rdata[31:0]);
        `uvm_info(get_name(), $psprintf("ST1b: EP Command Register: addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)
        #50;
        wdata = 'h0000_0006;
        wdata_BE = changeEndian(wdata[31:0]);
        mmio_write64(.addr_(addr), .data_(wdata_BE));
        #50;
        mmio_read64 (.addr_(addr), .data_(rdata));
        rdata_BE = changeEndian(rdata[31:0]);
        `uvm_info(get_name(), $psprintf("ST1b: EP 2nd read Command Register: addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)
	if(rdata_BE !== wdata)
           `uvm_error(get_name(), $psprintf("ST1b: Command Register Mismatch Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata_BE))
        else
           `uvm_info(get_name(), $psprintf("ST1b: Command Register Match addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)
        #200ns;
	if(check_cs_irq_enb)  read_clear_errstat_reg();

        //
        // Writing ''h1200_0000 to BAR0 address 
        //
        addr  = 'h2001_0010; //'h2001_0010;
        wdata = 'h1200_0000; //It should be programmed from 'h1000_0000 till 'h1FFF_FFFF
        wdata_BE = changeEndian(wdata[31:0]);
        mmio_write64(.addr_(addr), .data_(wdata_BE));
        mmio_read64 (.addr_(addr), .data_(rdata));
        rdata_BE = changeEndian(rdata[31:0]);
        if(rdata_BE !== wdata)
              `uvm_error(get_name(), $psprintf("ST1b: Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
        else
              `uvm_info(get_name(), $psprintf("ST1b: Data match 64! addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)
        #200ns;
	if(check_cs_irq_enb)  read_clear_errstat_reg();
        #4us;

   endtask:body

   task read_clear_errstat_reg();
     bit [31:0]  addr, irq_data;
     bit [63:0]  wdata, rdata;

      //Reading RP Uncorrectable Error Status (addr: 'h8_0104)
      addr  = 'h2008_0104; 
      h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1 After traffic: addr=0x%0h, rdata=%0h", addr, rdata), UVM_LOW)
      if( (rdata[14] == 0) && (rdata[15] == 0) )
         `uvm_error(get_name(), $psprintf("ST1:  Cpl-CA or Cpl-UR status bit is not triggered rdata=%0h", rdata))
      else
         `uvm_info(get_name(), $psprintf("ST2: Cpl-CA or Cpl-UR status bit triggered rdata=%0h ", rdata), UVM_LOW)

      /* IRQ covered in HIP verification
      //`uvm_info(get_name(), $psprintf("ST1: Waiting for IRQ asserted"), UVM_LOW)
      //wait(`H2F_TOP.subsys_hps_f2h_irq0_in_irq[31:0] !== 0); 
      #500ns; //remove once IRQ works

      irq_data = `H2F_TOP.subsys_hps_f2h_irq0_in_irq[31:0];
      `uvm_info(get_name(), $psprintf("ST1: IRQ asserted IRQ_data = %0h", irq_data), UVM_LOW)
         
      if(irq_data[3] == 1)
         `uvm_info(get_name(), $psprintf("ST2: Interrupt signal IRQ is asserted irq_data=%0h ", irq_data), UVM_LOW)
      else 
 	`uvm_error(get_name(), $psprintf("ST1: IRQ mismatch Exp:irq_data[3]=1, Act:irq_data=%0h", irq_data))
      */

      //Reading RP Uncorrectable Error Status (addr: 'h8_0104)
      addr  = 'h2008_0104; 
      h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1 After traffic: addr=0x%0h, rdata=%0h", addr, rdata), UVM_LOW)
      if( (rdata[14] == 0) && (rdata[15] == 0) )
         `uvm_error(get_name(), $psprintf("ST1:  Cpl-CA or Cpl-UR status bit is not triggered rdata=%0h", rdata))
      else
         `uvm_info(get_name(), $psprintf("ST2: Cpl-CA or Cpl-UR status bit triggered rdata=%0h ", rdata), UVM_LOW)

      //Reading Completion status register
      addr = 'h2001_80D0;       
      mmio_read64(.addr_(addr), .data_(rdata));
      `uvm_info(get_name(), $psprintf("ST1: Reading Completion timeout register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
      if(rdata[0] !== 'b1)
         `uvm_error(get_name(), $psprintf("ST1: CS Error Cpl-status Exp:rdata[0]=1, Act:rdata[0]=%0h", rdata[0]))
      else
         `uvm_info(get_name(), $psprintf("ST1: CS Error Cpl-status Exp:rdata[0]=1, Act:rdata[0]=%0h", rdata[0]), UVM_LOW)

     //Clear completion timeout status bit
     wdata = 0;
     mmio_write64(.addr_(addr), .data_(wdata));
     mmio_read64(.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: Reading after clear CS Errstatus register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
     if(rdata[0] !== 'b0)
        `uvm_error(get_name(), $psprintf("ST1: After clear,CS Errstatus Exp:rdata[0]=0, Act:rdata[0]=%0h", rdata[0]))
     else
        `uvm_info(get_name(), $psprintf("ST1: After clear, CS Errstatus Exp:rdata[0]=0, Act:rdata[0]=%0h", rdata[0]), UVM_LOW)
   endtask

endclass
