class sysrp_bas_cplstat_seq extends sysrp_base_seq;
    
  rand int sequence_length ;
  rand bit check_bas_errstatus;

  `uvm_object_utils(sysrp_bas_cplstat_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_bas_cplstat_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_bas_cplstat_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_bas_cplstat_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
     bit [31:0]   addr, m_addr;
     bit [63:0]   wdata, rdata, wdata_BE, rdata_BE;
     bit [5:0]    len;
     bit [1023:0] burst_rdata;
     int tdelay;
     bit [1:0]    l_rresp;

     `uvm_info(get_name(), $psprintf("ST1: Starting PART2 i=%d", 2), UVM_LOW)

     //-----------------------------------------------------------------------------
     //Perform Memory Write/Read Transactions on H2F AVMM BAS interface to Endpoint
     //-----------------------------------------------------------------------------
     sequence_length = (sequence_length == 0)? 2 : sequence_length;
     `uvm_info(get_name(), $psprintf("Sequence_length = %0d", sequence_length), UVM_LOW)

     for (int i=0; i<sequence_length; i++) begin //{ 
	tdelay = $urandom_range(200,600);
	m_addr[31:16] = $urandom_range('h1000, 'h1fff);
	m_addr[15:0]  = 0;
	addr = m_addr + i*'h1000;
        len=$urandom_range(1,32);
        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_write_addr = %0h, h2f_write_len=%0h",i,addr,len), UVM_LOW) 
        h2f_write128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1));

        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_read_addr = %0h, h2f_read_len=%0h",i,addr,len), UVM_LOW)
         h2f_read128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1), .data_(burst_rdata));
        #(tdelay *1ns);

	//Check rresp
	l_rresp = sysrp_top_tb.PCIE_RP_DUT.subsys_hps_hps2fpga_rresp[1:0];
	`uvm_info(get_name(), $psprintf("ST1: l_rresp=%0b", l_rresp), UVM_LOW)

	if(check_bas_errstatus)   read_clear_bas_errstat_reg();
     end //}
     #8us;
   
   endtask:body


  task read_clear_bas_errstat_reg();
     bit [31:0]  addr, irq_data;
     bit [63:0]  wdata, rdata;

      /* IRQ is covered in HIP verification
      //`uvm_info(get_name(), $psprintf("ST1: Waiting for IRQ asserted"), UVM_LOW)
      //wait(`H2F_TOP.subsys_hps_f2h_irq0_in_irq[31:0] !== 0); 
      #500ns;  //remove once IRQ works

      irq_data = `H2F_TOP.subsys_hps_f2h_irq0_in_irq[31:0];
      `uvm_info(get_name(), $psprintf("ST1: IRQ asserted IRQ_data = %0h", irq_data), UVM_LOW)
         
      if(irq_data[3] == 1)
         `uvm_info(get_name(), $psprintf("ST1: Interrupt signal IRQ is asserted irq_data=%0h ", irq_data), UVM_LOW)
      else 
 	`uvm_error(get_name(), $psprintf("ST1: IRQ mismatch Exp:irq_data[3]=1, Act:irq_data=%0h", irq_data))
       */

      //Reading Completion status register
        addr = 'h2001_80D4;       
        mmio_read64(.addr_(addr), .data_(rdata));
       `uvm_info(get_name(), $psprintf("ST1: Reading BAS ErrStatus register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
        if(rdata[0] !== 'b1)
           `uvm_error(get_name(), $psprintf("ST1: BAS ErrStatus Exp:rdata[0]=1, Act:rdata[0]=%0h", rdata[0]))
        else
           `uvm_info(get_name(), $psprintf("ST1: BAS ErrStatus Exp:rdata[0]=1, Act:rdata[0]=%0h", rdata[0]), UVM_LOW)

       //Clear BAS ErrStatus bit
        wdata = 0;
	mmio_write64(.addr_(addr), .data_(wdata));
  	mmio_read64(.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("ST1: after clear BAS ErrStatus register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
        if(rdata[0] !== 'b0)
           `uvm_error(get_name(), $psprintf("ST1: After clear, BAS Errstatus Exp:rdata[0]=0, Act:rdata[0]=%0h", rdata[0]))
        else
           `uvm_info(get_name(), $psprintf("ST1: After clear, BAS Errstatus Exp:rdata[0]=0, Act:rdata[0]=%0h", rdata[0]), UVM_LOW)
   endtask
endclass
