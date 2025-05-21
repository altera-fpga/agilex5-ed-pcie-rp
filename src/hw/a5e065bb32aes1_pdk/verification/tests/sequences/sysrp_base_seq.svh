class sysrp_base_seq extends uvm_sequence;
    `uvm_object_utils(sysrp_base_seq)
    `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

    function new(string name = "sysrp_base_seq");
        super.new(name);
    endfunction : new

    task body();
      bit [63:0] wdata, rdata, wdata_BE, rdata_BE;
      bit [31:0] addr, reg_addrbase, mem_addrbase;
      bit [3:0] len;
      bit [1023:0] burst_rdata;
      bit[31:0]   dev_ctl_data;
      bit[2:0]    max_rd_req, max_pl_size;
      bit status;
      sysrp_pcie_linkup_sequence bring_up_link_seq;
      svt_pcie_mem_target_service target_mem_seq;
      svt_pcie_driver_app_mem_request_sequence mem_request_seq;

      super.body();

      //-------------------------------------------
      // Link up
      //-------------------------------------------
      `uvm_info("body", "ST1: Entered ...", UVM_LOW)
	  `uvm_info(get_name(), "ST1: waiting for Linking up...", UVM_LOW)
	  `uvm_do_on(bring_up_link_seq, p_sequencer.endpoint_vseqr)
	  `uvm_info(get_name(), "ST1: Link is up now", UVM_LOW)
	  #400ns; //

      //-------------------------------------------
      // Program the bus,device,function(BDF=0100) 
      //-------------------------------------------
        reg_addrbase = 'h2001_0000;

	//BDF reg
        addr  = reg_addrbase + 'h2004; //'h2001_2004;
        wdata = 'h0100;
        mmio_write64(.addr_(addr), .data_(wdata));
        mmio_read64 (.addr_(addr), .data_(rdata));
        if(rdata !== wdata)
           `uvm_error(get_name(), $psprintf("ST1: Data mismatch 64! Addr=%0h, Exp_data=%0h, Act_data=%0h", addr, wdata, rdata))
        else
           `uvm_info(get_name(), $psprintf("ST1: Data match 64! addr=%0h, rdata=%0h", addr, rdata), UVM_LOW)

        //==============================
	// 1. Enunmerate Pcie Endpoint
        //==============================
	//
	// Program EP Bar0 register
	//
        addr  = reg_addrbase + 'h10; //'h2001_0010;
        wdata = 'hFFFF_FFFF;
        wdata_BE = changeEndian(wdata[31:0]);
       `uvm_info(get_name(), "ST1: Writing BAR0 with FFFF_FFFF and reading", UVM_LOW)
        mmio_write64(.addr_(addr), .data_(wdata_BE));
        #5;
        mmio_read64 (.addr_(addr), .data_(rdata));
        rdata_BE = changeEndian(rdata[31:0]);
       `uvm_info(get_name(), $psprintf("ST1: BAR0 READATA: addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)

        //
        // Reading EP Command Register 
        //
        addr  = reg_addrbase + 'h4; //'h2001_0004;
        mmio_read64 (.addr_(addr), .data_(rdata));
        rdata_BE = changeEndian(rdata[31:0]);
        `uvm_info(get_name(), $psprintf("ST1: EP Command Register: addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)
        #5;
        wdata = 'h0000_0006;
        wdata_BE = changeEndian(wdata[31:0]);
        mmio_write64(.addr_(addr), .data_(wdata_BE));
        #5;
        mmio_read64 (.addr_(addr), .data_(rdata));
        rdata_BE = changeEndian(rdata[31:0]);
        `uvm_info(get_name(), $psprintf("ST1: EP 2nd read Command Register: addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)
	if(rdata_BE !== wdata)
           `uvm_error(get_name(), $psprintf("ST1: Command Register Mismatch Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata_BE))
        else
           `uvm_info(get_name(), $psprintf("ST1: Command Register Match addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)

        //
        // Writing ''h1000_0000 to BAR0 address 
        //
        addr  = reg_addrbase + 'h10; //'h2001_0010;
        wdata = 'h1000_0000; //It should be programmed from 'h1000_0000 till 'h1FFF_FFFF
        wdata_BE = changeEndian(wdata[31:0]);
        mmio_write64(.addr_(addr), .data_(wdata_BE));
        mmio_read64 (.addr_(addr), .data_(rdata));
        rdata_BE = changeEndian(rdata[31:0]);
        if(rdata_BE !== wdata)
              `uvm_error(get_name(), $psprintf("ST1: Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
        else
              `uvm_info(get_name(), $psprintf("ST1: Data match 64! addr = %0h, data = %0h", addr, rdata_BE), UVM_LOW)


        //======================================
	// 2. Enumerate Pcie Rootport
	//======================================
	//
	// Reading RP vendor ID
	//
	addr  = 'h2008_0000;
        h2f_mem_read32 (.addr_(addr), .data_(rdata));
	`uvm_info(get_name(), $psprintf("ST1: RP Vendor ID addr=0x%0h, Vendor-ID = %0h", addr, rdata), UVM_LOW)

	//
	// Program RP command register
	//
        addr  = 'h2008_0004; 
        wdata = 'h0000_0006;
        h2f_mem_read32 (.addr_(addr), .data_(rdata));
	`uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, reading default RP command reg=0x%0h", addr, rdata), UVM_LOW)

        h2f_mem_write32 (.addr_(addr), .data_(wdata));
        h2f_mem_read32 (.addr_(addr), .data_(rdata));
	`uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, 2nd reading RP command reg=0x%0h", addr, rdata), UVM_LOW)

	//Use default value for RP BAR 
        //addr  = 'h2008_0010; 
        //h2f_mem_read32 (.addr_(addr), .data_(rdata));
        //`uvm_info(get_name(), $psprintf("ST1 BAR: addr=0x%0h, Readdata = %0h", addr, rdata), UVM_LOW)

	//
	// Primary-Secondary Bus
	//
        addr  = 'h2008_0018; 
        h2f_mem_read32 (.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, Primary-Secondary Bus [Readdata] = %0h", addr, rdata), UVM_LOW)

        addr  = 'h2008_0018; 
        wdata = 'h0001_0100;
        h2f_mem_write32 (.addr_(addr), .data_(wdata));
        h2f_mem_read32 (.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, Secondary Bus [Readdata] = %0h", addr, rdata), UVM_LOW)

	//
	// Memory Base and Limit
	//
        addr  = 'h2008_0020; 
        h2f_mem_read32 (.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, reading default Memory Base and Limit=%0h", addr, rdata), UVM_LOW)

        addr  = 'h2008_0020; 
        wdata = 'h0ff0_0000; //So now range shoulde be 'h0000_0000 to 'h0FFF_FFFF
        h2f_mem_write32 (.addr_(addr), .data_(wdata));
        h2f_mem_read32 (.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("ST1a: addr=0x%0h, reading 2nd Memory Base and Limit=%0h", addr, rdata), UVM_LOW)

	//
	// Device Capability register
	//
        addr  = 'h2008_0074; 
        h2f_mem_read32 (.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, Device Capabilities Register [Readdata] = %0h", addr, rdata), UVM_LOW)

        //
	// Device Control register
	//
        addr  = 'h2008_0078; 
        max_rd_req   = 3'b000;     
        max_pl_size  = 3'b010; //MPS=512B    
        dev_ctl_data = {16'h0, 1'b0, max_rd_req, 3'h0, 1'b0, max_pl_size, 5'b01111}; // Ext tag disable bit 8
        h2f_mem_write32 (.addr_(addr), .data_(dev_ctl_data));
        `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, Writing Device control register of RP=%0h", addr, dev_ctl_data), UVM_LOW)

        h2f_mem_read32 (.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("ST1: addr=0x%0h, Reading Device control register of RP=%0h", addr, rdata), UVM_LOW)

        #200ns;

    endtask : body

    //------------------------------------------------------------------
    //task mmio_write64(input bit [31:0] addr_, input bit [31:0] data_);
    //------------------------------------------------------------------
    task mmio_write64(input bit [31:0] addr_, input bit [31:0] data_);
        sysrp_axi_derived_write_sequence wr_trans;
        `uvm_do_on_with(wr_trans,p_sequencer.master_sequencer, { 
            wr_trans.addr                  == addr_;
            wr_trans.data                  == data_;
         })
    endtask : mmio_write64

    //-----------------------------------------------------------------
    //task mmio_write32(input bit [31:0] addr_, input bit [31:0] data_);
    //-----------------------------------------------------------------
    task mmio_write32(input bit [31:0] addr_, input bit [31:0] data_);
        sysrp_axi_derived_write_sequence wr_trans;
        `uvm_do_on_with(wr_trans,p_sequencer.master_sequencer, { 
            wr_trans.addr                  == addr_;
            wr_trans.data                  == data_;
            wr_trans.wstrb                 == 'hf  ;
         })
    endtask : mmio_write32

    //--------------------------------------------------------------------
    //task mmio_read64(input  bit [31:0] addr_, output bit [31:0] data_);
    //--------------------------------------------------------------------
    task mmio_read64(input  bit [31:0] addr_, output bit [31:0] data_);
              sysrp_axi_derived_read_sequence rd_trans;
              rd_trans = sysrp_axi_derived_read_sequence::type_id::create("rd_trans");
              rd_trans.randomize() with { rd_trans.addr    == addr_; };
              rd_trans.start(p_sequencer.master_sequencer);
              data_ = rd_trans.rsp.data[0][31:0];
    endtask : mmio_read64

    //-------------------------------------------------------------------
    //task mmio_read32(input  bit [31:0] addr_, output bit [31:0] data_);
    //-------------------------------------------------------------------
    task mmio_read32(input  bit [31:0] addr_, output bit [31:0] data_);
              sysrp_axi_derived_read_sequence rd_trans;
              rd_trans = sysrp_axi_derived_read_sequence::type_id::create("rd_trans");
              rd_trans.randomize() with { rd_trans.addr    == addr_; };
              rd_trans.start(p_sequencer.master_sequencer);
              data_ = rd_trans.rsp.data[0][31:0];
    endtask : mmio_read32

    //---------------------------------------------------------------------
    //task h2f_mem_read128(input  bit [31:0] addr_, input bit [7:0] burst_length_, input bit[1:0] burst_type_, output bit [1023:0] data_);
    //---------------------------------------------------------------------
    task h2f_mem_read128(input  bit [31:0] addr_, input bit [7:0] burst_length_, input bit[1:0] burst_type_, output bit [1023:0] data_);
              sysrp_h2f_read_sequence rd_trans;
              rd_trans = sysrp_h2f_read_sequence::type_id::create("rd_trans");
              rd_trans.randomize() with { rd_trans.addr    == addr_; rd_trans.burst_length == burst_length_;rd_trans.burst_size =='h4;rd_trans.burst_type==burst_type_;};
              rd_trans.start(p_sequencer.h2f_master_sequencer);
              if(burst_length_=='h1)
                begin
                 data_ = rd_trans.rsp.data[0][127:0];
                end
              else if(burst_length_=='h2)
                begin
                 data_ = rd_trans.rsp.data[0][255:0];
                end
              else if(burst_length_=='h3)
                begin
                 data_ = rd_trans.rsp.data[0][383:0];
                end
              else if(burst_length_=='h4)
                begin
                 data_ = rd_trans.rsp.data[0][511:0];
                end
              else if(burst_length_=='h5)
                begin
                 data_ = rd_trans.rsp.data[0][639:0];
                end
              else if(burst_length_=='h6)
                begin
                 data_ = rd_trans.rsp.data[0][767:0];
                end
              else if(burst_length_=='h7)
                begin
                 data_ = rd_trans.rsp.data[0][895:0];
                end
              else if(burst_length_=='h8)
                begin
                 data_ = rd_trans.rsp.data[0][1023:0];
                end
    endtask : h2f_mem_read128

    //-----------------------------------------------------------
    //task h2f_read128_random(input  bit [31:0] addr_, input bit [7:0] burst_length_, input bit[1:0] burst_type_, output bit [1023:0] data_);
    //-----------------------------------------------------------
    task h2f_read128_random(input  bit [31:0] addr_, input bit [7:0] burst_length_, input bit[1:0] burst_type_, output bit [1023:0] data_);
             sysrp_h2f_write128_random_seq rd_trans_random;
             rd_trans_random = sysrp_h2f_write128_random_seq::type_id::create("rd_trans_random");
              begin
               rd_trans_random.randomize() with { rd_trans_random.addr  == addr_; rd_trans_random.burst_length == burst_length_; rd_trans_random.wr_mode==0;};
              end
             rd_trans_random.start(p_sequencer.h2f_master_sequencer);
              if(burst_length_=='h1)
                begin
                 data_ = rd_trans_random.rsp.data[0][127:0];
                end
              else if(burst_length_=='h2)
                begin
                 data_ = rd_trans_random.rsp.data[0][255:0];
                end
              else if(burst_length_=='h3)
                begin
                 data_ = rd_trans_random.rsp.data[0][383:0];
                end
              else if(burst_length_=='h4)
                begin
                 data_ = rd_trans_random.rsp.data[0][511:0];
                end
              else if(burst_length_=='h5)
                begin
                 data_ = rd_trans_random.rsp.data[0][639:0];
                end
              else if(burst_length_=='h6)
                begin
                 data_ = rd_trans_random.rsp.data[0][767:0];
                end
              else if(burst_length_=='h7)
                begin
                 data_ = rd_trans_random.rsp.data[0][895:0];
                end
              else if(burst_length_=='h8)
                begin
                 data_ = rd_trans_random.rsp.data[0][1023:0];
                end
    endtask : h2f_read128_random

    //----------------------------------------------------------------------
    //task h2f_mem_read32(input  bit [31:0] addr_,  output bit [63:0] data_);
    //----------------------------------------------------------------------
    task h2f_mem_read32(input  bit [31:0] addr_,  output bit [63:0] data_);
              sysrp_h2f_read_sequence rd_trans;
              rd_trans = sysrp_h2f_read_sequence::type_id::create("rd_trans");
              rd_trans.randomize() with { rd_trans.addr    == addr_; rd_trans.burst_length == 'h1;rd_trans.burst_size =='h2;rd_trans.burst_type=='h0;};
              rd_trans.start(p_sequencer.h2f_master_sequencer);
              data_ = rd_trans.rsp.data[0][63:0];
    endtask : h2f_mem_read32

    //---------------------------------------------------------------------
    //task h2f_mem_write32(input  bit [31:0] addr_, input bit [31:0] data_);
    //---------------------------------------------------------------------
    task h2f_mem_write32(input  bit [31:0] addr_, input bit [31:0] data_);
              sysrp_h2f_write32_sequence wr_trans;
              wr_trans = sysrp_h2f_write32_sequence::type_id::create("wr_trans");
              wr_trans.randomize() with { wr_trans.addr    == addr_; wr_trans.data==data_;};
              wr_trans.start(p_sequencer.h2f_master_sequencer);
    endtask : h2f_mem_write32

    //---------------------------------------------------------------------
    //task h2f_write128_random(input  bit [31:0] addr_, input bit [7:0] burst_length_, input bit[1:0] burst_type_);
    //---------------------------------------------------------------------
    task h2f_write128_random(input  bit [31:0] addr_, input bit [7:0] burst_length_, input bit[1:0] burst_type_);
             sysrp_h2f_write128_random_seq wr_trans_random;
             wr_trans_random = sysrp_h2f_write128_random_seq::type_id::create("wr_trans_random");
              begin
               wr_trans_random.randomize() with { wr_trans_random.addr  == addr_; wr_trans_random.burst_length == burst_length_; wr_trans_random.wr_mode == 1;};
              end
             wr_trans_random.start(p_sequencer.h2f_master_sequencer);
    endtask : h2f_write128_random

    //---------------------------------------------------------------------
    //task h2f_mem_write128(input  bit [31:0] addr_, input bit [7:0] burst_length_, input bit[1:0] burst_type_, input bit [31:0] data_[31:0]);
    //---------------------------------------------------------------------
    task h2f_mem_write128(input  bit [31:0] addr_, input bit [7:0] burst_length_, input bit[1:0] burst_type_, input bit [31:0] data_[31:0]);
              sysrp_h2f_write128_sequence wr_trans;
              wr_trans = sysrp_h2f_write128_sequence::type_id::create("wr_trans");
              if(burst_length_=='h1)
                begin
              wr_trans.randomize() with { wr_trans.addr  == addr_; wr_trans.burst_length == burst_length_; wr_trans.burst_type == burst_type_; wr_trans.data[0]==data_[0];wr_trans.data[1]==data_[1];wr_trans.data[2]==data_[2];wr_trans.data[3]==data_[3];};
                end
              else if(burst_length_=='h2)
                begin
              wr_trans.randomize() with { wr_trans.addr  == addr_; wr_trans.burst_length == burst_length_; wr_trans.burst_type == burst_type_; wr_trans.data[0]==data_[0];wr_trans.data[1]==data_[1];wr_trans.data[2]==data_[2];wr_trans.data[3]==data_[3];wr_trans.data[4]==data_[4];wr_trans.data[5]==data_[5];wr_trans.data[6]==data_[6];wr_trans.data[7]==data_[7];};
                end
              else if(burst_length_=='h3)
                begin
              wr_trans.randomize() with { wr_trans.addr  == addr_; wr_trans.burst_length == burst_length_; wr_trans.burst_type == burst_type_; wr_trans.data[0]==data_[0];wr_trans.data[1]==data_[1];wr_trans.data[2]==data_[2];wr_trans.data[3]==data_[3];wr_trans.data[4]==data_[4];wr_trans.data[5]==data_[5];wr_trans.data[6]==data_[6];wr_trans.data[7]==data_[7];wr_trans.data[8]==data_[8];wr_trans.data[9]==data_[9];wr_trans.data[10]==data_[10];wr_trans.data[11]==data_[11];};
                end
              else if(burst_length_=='h4)
                begin
              wr_trans.randomize() with { wr_trans.addr  == addr_; wr_trans.burst_length == burst_length_; wr_trans.burst_type == burst_type_; wr_trans.data[0]==data_[0];wr_trans.data[1]==data_[1];wr_trans.data[2]==data_[2];wr_trans.data[3]==data_[3];wr_trans.data[4]==data_[4];wr_trans.data[5]==data_[5];wr_trans.data[6]==data_[6];wr_trans.data[7]==data_[7];wr_trans.data[8]==data_[8];wr_trans.data[9]==data_[9];wr_trans.data[10]==data_[10];wr_trans.data[11]==data_[11];wr_trans.data[12]==data_[12];wr_trans.data[13]==data_[13];wr_trans.data[14]==data_[14];wr_trans.data[15]==data_[15];};
                end
              else if(burst_length_=='h5)
                begin
              wr_trans.randomize() with { wr_trans.addr  == addr_; wr_trans.burst_length == burst_length_; wr_trans.burst_type == burst_type_; wr_trans.data[0]==data_[0];wr_trans.data[1]==data_[1];wr_trans.data[2]==data_[2];wr_trans.data[3]==data_[3];wr_trans.data[4]==data_[4];wr_trans.data[5]==data_[5];wr_trans.data[6]==data_[6];wr_trans.data[7]==data_[7];wr_trans.data[8]==data_[8];wr_trans.data[9]==data_[9];wr_trans.data[10]==data_[10];wr_trans.data[11]==data_[11];wr_trans.data[12]==data_[12];wr_trans.data[13]==data_[13];wr_trans.data[14]==data_[14];wr_trans.data[15]==data_[15];wr_trans.data[16]==data_[16];wr_trans.data[17]==data_[17];wr_trans.data[18]==data_[18];wr_trans.data[19]==data_[19];};
                end
              else if(burst_length_=='h6)
                begin
              wr_trans.randomize() with { wr_trans.addr  == addr_; wr_trans.burst_length == burst_length_; wr_trans.burst_type == burst_type_; wr_trans.data[0]==data_[0];wr_trans.data[1]==data_[1];wr_trans.data[2]==data_[2];wr_trans.data[3]==data_[3];wr_trans.data[4]==data_[4];wr_trans.data[5]==data_[5];wr_trans.data[6]==data_[6];wr_trans.data[7]==data_[7];wr_trans.data[8]==data_[8];wr_trans.data[9]==data_[9];wr_trans.data[10]==data_[10];wr_trans.data[11]==data_[11];wr_trans.data[12]==data_[12];wr_trans.data[13]==data_[13];wr_trans.data[14]==data_[14];wr_trans.data[15]==data_[15];wr_trans.data[16]==data_[16];wr_trans.data[17]==data_[17];wr_trans.data[18]==data_[18];wr_trans.data[19]==data_[19];wr_trans.data[20]==data_[20];wr_trans.data[21]==data_[21];wr_trans.data[22]==data_[22];wr_trans.data[23]==data_[23];};
                end
              else if(burst_length_=='h7)
                begin
              wr_trans.randomize() with { wr_trans.addr  == addr_; wr_trans.burst_length == burst_length_; wr_trans.burst_type == burst_type_; wr_trans.data[0]==data_[0];wr_trans.data[1]==data_[1];wr_trans.data[2]==data_[2];wr_trans.data[3]==data_[3];wr_trans.data[4]==data_[4];wr_trans.data[5]==data_[5];wr_trans.data[6]==data_[6];wr_trans.data[7]==data_[7];wr_trans.data[8]==data_[8];wr_trans.data[9]==data_[9];wr_trans.data[10]==data_[10];wr_trans.data[11]==data_[11];wr_trans.data[12]==data_[12];wr_trans.data[13]==data_[13];wr_trans.data[14]==data_[14];wr_trans.data[15]==data_[15];wr_trans.data[16]==data_[16];wr_trans.data[17]==data_[17];wr_trans.data[18]==data_[18];wr_trans.data[19]==data_[19];wr_trans.data[20]==data_[20];wr_trans.data[21]==data_[21];wr_trans.data[22]==data_[22];wr_trans.data[23]==data_[23];wr_trans.data[24]==data_[24];wr_trans.data[25]==data_[25];wr_trans.data[26]==data_[26];wr_trans.data[27]==data_[27];};
                end
              else if(burst_length_=='h8)
                begin
              wr_trans.randomize() with { wr_trans.addr  == addr_; wr_trans.burst_length == burst_length_; wr_trans.burst_type == burst_type_; wr_trans.data[0]==data_[0];wr_trans.data[1]==data_[1];wr_trans.data[2]==data_[2];wr_trans.data[3]==data_[3];wr_trans.data[4]==data_[4];wr_trans.data[5]==data_[5];wr_trans.data[6]==data_[6];wr_trans.data[7]==data_[7];wr_trans.data[8]==data_[8];wr_trans.data[9]==data_[9];wr_trans.data[10]==data_[10];wr_trans.data[11]==data_[11];wr_trans.data[12]==data_[12];wr_trans.data[13]==data_[13];wr_trans.data[14]==data_[14];wr_trans.data[15]==data_[15];wr_trans.data[16]==data_[16];wr_trans.data[17]==data_[17];wr_trans.data[18]==data_[18];wr_trans.data[19]==data_[19];wr_trans.data[20]==data_[20];wr_trans.data[21]==data_[21];wr_trans.data[22]==data_[22];wr_trans.data[23]==data_[23];wr_trans.data[24]==data_[24];wr_trans.data[25]==data_[25];wr_trans.data[26]==data_[26];wr_trans.data[27]==data_[27];wr_trans.data[28]==data_[28];wr_trans.data[29]==data_[29];wr_trans.data[30]==data_[30];wr_trans.data[31]==data_[31];};
                end
              wr_trans.start(p_sequencer.h2f_master_sequencer);
    endtask : h2f_mem_write128

    //--------------------------------------------------------------------
    //task ep_mem_wr_req(input bit [31:0] addr_, input bit [7:0] length_);
    //--------------------------------------------------------------------
    task ep_mem_wr_req(input bit [31:0] addr_, input bit [7:0] length_);
             svt_pcie_driver_app_mem_request_sequence mem_request_seq;
             `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                                                              mem_request_seq.address == addr_;
                                                                                                              mem_request_seq.length == length_;
                                                                                                              mem_request_seq.traffic_class == 0;
                                                                                                              mem_request_seq.address_translation == 0;
                                                                                                              mem_request_seq.ep == 0;
                                                                                                              mem_request_seq.th == 0;
                                                                                                              mem_request_seq.first_dw_be == 'b1111;
                                                                                                              mem_request_seq.last_dw_be == 'b1111;
                                                                                                              mem_request_seq.block == 1; }); // Must block to avoid r/w collision
    endtask : ep_mem_wr_req
        
    //--------------------------------------------------------------------
    //task ep_mem_rd_req(input bit [31:0] addr_, input bit [7:0] length_);
    //--------------------------------------------------------------------
    task ep_mem_rd_req(input bit [31:0] addr_, input bit [7:0] length_);     
             svt_pcie_driver_app_mem_request_sequence mem_request_seq;
             `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                                                              mem_request_seq.address == addr_;
                                                                                                              mem_request_seq.length == length_;
                                                                                                              mem_request_seq.traffic_class == 0;
                                                                                                              mem_request_seq.address_translation == 0;
                                                                                                              mem_request_seq.ep == 0;
                                                                                                              mem_request_seq.th == 0;
                                                                                                              mem_request_seq.first_dw_be == 'b1111;
                                                                                                              mem_request_seq.last_dw_be == 'b1111;
                                                                                                              mem_request_seq.block == 1; }); // Must block to avoid r/w collision
    endtask : ep_mem_rd_req


    //----------------------------------------
    //function [31:0] changeEndian; 
    //----------------------------------------
    function [31:0] changeEndian;   //transform data from the memory to big-endian form
        input [31:0] value;
        changeEndian = {value[7:0], value[15:8], value[23:16], value[31:24]};
    endfunction

    //---------------------------------------
    //task rp_indirect_read(input bit[21:0] address, output bit[31:0] rd_data);
    //---------------------------------------
    task rp_indirect_read(input bit[22:0] address, output bit[31:0] rd_data);
       bit[31:0] rdata, wdata;
       bit[31:0] addr;

        //1. Read CFG REG IA CLTR 'h2000_00C8, check for Init Access bit 
	addr = 'h2000_00C8;
        h2f_mem_read32 (.addr_('h2000_00C8), .data_(rdata));
        while(rdata[0] == 'b1) begin
           `uvm_info(get_name(), $psprintf("ST1 rp_indirect_read_1: waiting for CFG REGH IA CTRL Init_Access_bit=0", addr, rdata), UVM_LOW)
	   h2f_mem_read32 (.addr_('h2000_00C8), .data_(rdata));
           #20ns;
	end

	//2. Wait for Init Access bit=0 then setup read req to address
	if(rdata[0] == 0) begin //{
	   wdata = 'h0000_0002;
	   h2f_mem_write32 (.addr_('h2000_00CC), .data_(wdata));

	   //Write to CTRL addr and set read
	   wdata = {4'h0, address/4 , 4'hF, 1'h0, 1'h1}; //set ctrl to read reg with address (byte address)
	   h2f_mem_write32 (.addr_('h2000_00C8), .data_(wdata));
	end

	//3. Wait for read data ready in CFG REG IA RDDATA
	h2f_mem_read32 (.addr_('h2000_00C8), .data_(rdata));
        while(rdata[0] == 'b1) begin 
	   `uvm_info(get_name(), $psprintf("ST1 rp_indirect_read_2: waiting for CFG REGH IA CTRL Init_Access_bit=0", addr, rdata), UVM_LOW)
	   h2f_mem_read32 (.addr_('h2000_00C8), .data_(rdata));
	   #20ns;
	end
        if(rdata[0] == 0) begin //{
           h2f_mem_read32 (.addr_('h2000_00D4), .data_(rdata));
	   rd_data = rdata;
        end //}
    endtask : rp_indirect_read


    //---------------------------------------
    //task rp_indirect_write(input bit[21:0] address, input bit[31:0] wr_data);
    //---------------------------------------
    task rp_indirect_write(input bit[22:0] address, input bit[31:0] wr_data);
       bit[31:0] rdata, wdata;
       bit[31:0] addr;

        //1. Read CFG REG IA CLTR 'h2000_00C8, check for Init Access bit 
	addr = 'h2000_00C8;
        h2f_mem_read32 (.addr_('h2000_00C8), .data_(rdata));
        while(rdata[0] == 'b1) begin
	   `uvm_info(get_name(), $psprintf("ST1 rp_indirect_write: waiting for CFG REGH IA CTRL Init_Access_bit=0", addr, rdata), UVM_LOW)
	   h2f_mem_read32 (.addr_('h2000_00C8), .data_(rdata));
	end

	//2. Wait for Init Access bit=0 then setup write req to address
	if(rdata[0] == 0) begin //{
	   //Progam function number 'b010
           wdata = 'h0000_0002;
	   h2f_mem_write32 (.addr_('h2000_00CC), .data_(wdata));

	   //Program write data
	   h2f_mem_write32 (.addr_('h2000_00D0), .data_(wr_data));

	   //Write to CTRL addr and set write
	   wdata = {4'h0, address/4 , 4'hF, 1'h1, 1'h1}; //set ctrl to write to input address
	   h2f_mem_write32 (.addr_('h2000_00C8), .data_(wdata));
	end
    endtask : rp_indirect_write

endclass : sysrp_base_seq
