class sysrp_sanity_seq extends sysrp_base_seq;
    
  rand int no_of_transactions ;
  rand int unsigned sequence_length = 10;

  `uvm_object_utils(sysrp_sanity_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_sanity_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_sanity_seq] ST1: Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit [127:0] rdata, wdata[$];
    bit [31:0] addr;
    bit [31:0] burst_wdata [31:0];
    svt_pcie_driver_app_mem_request_sequence mem_request_seq;
    super.body();

    //------------------------------------------------------
    // Reading/Writing - H2F (RP to EP) Data path
    // -----------------------------------------------------
    // Note: based on HAS section "Scope For Future Work", RP send TLP with 28b
    // address to EP. SW handles the mapping of 'h9xxx_xxxx 
    //
     addr  = 'h1030_2000;
     burst_wdata[0] = 'h1111_1111;
     burst_wdata[1] = 'h2222_2222;
     burst_wdata[2] = 'h3333_3333;
     burst_wdata[3] = 'h4444_4444;

     h2f_mem_write128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(burst_wdata));
     wdata[0] = {burst_wdata[3], burst_wdata[2], burst_wdata[1], burst_wdata[0]};

     `uvm_info(get_name(), $psprintf("ST1: Writing to EP h2f_write_addr=0x%0h, wdata=0x%0h ", addr, wdata[0]), UVM_LOW)
     h2f_mem_read128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: Addr=0x%0h, Exp=0x%0h, Act=0x%0h", addr, wdata[0], rdata), UVM_LOW)

     if(rdata !== wdata[0])
        `uvm_error(get_name(), $psprintf("Data Mismatch Addr = 0x%0h, Exp = 0x%0h, Act = 0x%0h", addr, wdata[0], rdata));

     ////1. MWr to EP
     addr  = 'h1030_2020;
     burst_wdata[0] = 'ha1a2_a3a4;
     burst_wdata[1] = 'hb1b2_b3b4;
     burst_wdata[2] = 'hc1c2_c3c4;
     burst_wdata[3] = 'hd1d2_d3d4;
     h2f_mem_write128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(burst_wdata));
     wdata[1] = {burst_wdata[3], burst_wdata[2], burst_wdata[1], burst_wdata[0]};
     `uvm_info(get_name(), $psprintf("ST1: Writing to EP h2f_write_addr=0x%0h, wdata=0x%0h ", addr, wdata[1]), UVM_LOW)

     addr  = 'h1030_2030;
     burst_wdata[0] = 'h5555_4446;
     burst_wdata[1] = 'h6666_4447;
     burst_wdata[2] = 'h7777_4448;
     burst_wdata[3] = 'h8888_8880;
     h2f_mem_write128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(burst_wdata));
     wdata[2] = {burst_wdata[3], burst_wdata[2], burst_wdata[1], burst_wdata[0]};
     `uvm_info(get_name(), $psprintf("ST1: Writing to EP h2f_write_addr=0x%0h, wdata=0x%0h ", addr, wdata[2]), UVM_LOW)

     addr  = 'h1030_2040;
     burst_wdata[0] = 'h5555_4447;
     burst_wdata[1] = 'h6666_4448;
     burst_wdata[2] = 'h7777_4449;
     burst_wdata[3] = 'h8888_8881;
     h2f_mem_write128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(burst_wdata));
     wdata[3] = {burst_wdata[3], burst_wdata[2], burst_wdata[1], burst_wdata[0]};
     `uvm_info(get_name(), $psprintf("ST1: Writing to EP h2f_write_addr=0x%0h, wdata=0x%0h ", addr, wdata[3]), UVM_LOW)

     addr  = 'h1030_2050;
     burst_wdata[0] = 'h5555_4448;
     burst_wdata[1] = 'h6666_4449;
     burst_wdata[2] = 'h7777_4440;
     burst_wdata[3] = 'h8888_8882;
     h2f_mem_write128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(burst_wdata));
     wdata[4] = {burst_wdata[3], burst_wdata[2], burst_wdata[1], burst_wdata[0]};
     `uvm_info(get_name(), $psprintf("ST1: Writing to EP h2f_write_addr=0x%0h, wdata=0x%0h ", addr, wdata[4]), UVM_LOW)
    
     ////2. MRd to EP and compare with MWr data
     addr  = 'h1030_2020;
     h2f_mem_read128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: Addr=0x%0h, Exp=0x%0h, Act=0x%0h", addr, wdata[1], rdata), UVM_LOW)
     if(rdata !== wdata[1])
        `uvm_error(get_name(), $psprintf("Data Mismatch Addr = 0x%0h, Exp = 0x%0h, Act = 0x%0h", addr, wdata[1], rdata));

     addr  = 'h1030_2030;
     h2f_mem_read128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: Addr=0x%0h, Exp=0x%0h, Act=0x%0h", addr, wdata[2], rdata), UVM_LOW)
     if(rdata !== wdata[2])
        `uvm_error(get_name(), $psprintf("Data Mismatch Addr = 0x%0h, Exp = 0x%0h, Act = 0x%0h", addr, wdata[2], rdata));

     addr  = 'h1030_2040;
     h2f_mem_read128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: Addr=0x%0h, Exp=0x%0h, Act=0x%0h", addr, wdata[3], rdata), UVM_LOW)
     if(rdata !== wdata[3])
        `uvm_error(get_name(), $psprintf("Data Mismatch Addr = 0x%0h, Exp = 0x%0h, Act = 0x%0h", addr, wdata[3], rdata));

     addr  = 'h1030_2050;
     h2f_mem_read128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: Addr=0x%0h, Exp=0x%0h, Act=0x%0h", addr, wdata[4], rdata), UVM_LOW)
     if(rdata !== wdata[4])
        `uvm_error(get_name(), $psprintf("Data Mismatch Addr = 0x%0h, Exp = 0x%0h, Act = 0x%0h", addr, wdata[4], rdata));

     ////3. Random data
     addr  = 'h1038_2200;
     burst_wdata[0] = $urandom();
     burst_wdata[1] = $urandom();
     burst_wdata[2] = $urandom();
     burst_wdata[3] = $urandom();
     wdata[5] = {burst_wdata[3], burst_wdata[2], burst_wdata[1], burst_wdata[0]};
     h2f_mem_write128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(burst_wdata));
     h2f_mem_read128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: Addr=0x%0h, Exp=0x%0h, Act=0x%0h", addr, wdata[5], rdata), UVM_LOW)

     if(rdata !== wdata[5])
        `uvm_error(get_name(), $psprintf("Data Mismatch Addr = 0x%0h, Exp = 0x%0h, Act = 0x%0h", addr, wdata[5], rdata));

     addr  = 'h1034_4000;
     burst_wdata[0] = $urandom();
     burst_wdata[1] = $urandom();
     burst_wdata[2] = $urandom();
     burst_wdata[3] = $urandom();
     wdata[6] = {burst_wdata[3], burst_wdata[2], burst_wdata[1], burst_wdata[0]};
     h2f_mem_write128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(burst_wdata));
     h2f_mem_read128 (.addr_(addr), .burst_length_('h1), .burst_type_('h1), .data_(rdata));
     `uvm_info(get_name(), $psprintf("ST1: Reading EP h2f_read_addr=0x%0h, rdata=0x%0h",addr, rdata), UVM_LOW)
     if(rdata !== wdata[6])
        `uvm_error(get_name(), $psprintf("Data Mismatch Addr = 0x%0h, Exp = 0x%0h, Act = 0x%0h", addr, wdata[6], rdata));

    #400ns;

    //------------------------------------------------------
    // Reading/Writing - F2H (EP to RP) Data path
    //------------------------------------------------------

    `uvm_info(get_name(), "ST1: MEM_WR to RP from Endpoint", UVM_LOW)
    `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                                                              mem_request_seq.address == 'h8100_1100;
                                                                                                              mem_request_seq.length == 20;
                                                                                                              mem_request_seq.traffic_class == 0;
                                                                                                              mem_request_seq.address_translation == 0;
                                                                                                              mem_request_seq.ep == 0;
                                                                                                              mem_request_seq.th == 0;
													      mem_request_seq.first_dw_be == 'b1111;
                                                                                                              mem_request_seq.last_dw_be == 'b1111;
                                                                                                              mem_request_seq.block == 1; }); // Must block to avoid r/w collision  
                                                                                                                 
    `uvm_info(get_name(), "ST1: MEM_RD to RP from Endpoint", UVM_LOW)
    `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                                                              mem_request_seq.address == 'h8100_1100;
                                                                                                              mem_request_seq.length == 20;
                                                                                                              mem_request_seq.traffic_class == 0;
                                                                                                              mem_request_seq.address_translation == 0;
                                                                                                              mem_request_seq.ep == 0;
                                                                                                              mem_request_seq.th == 0;
													      mem_request_seq.first_dw_be == 'b1111;
                                                                                                              mem_request_seq.last_dw_be == 'b1111;
                                                                                                              mem_request_seq.block == 1; }); // Must block to avoid r/w collision  

    #2us;
                                                                                                             
    `uvm_info("body", "ST1: Exiting sanity test...", UVM_LOW)

  endtask : body

endclass
