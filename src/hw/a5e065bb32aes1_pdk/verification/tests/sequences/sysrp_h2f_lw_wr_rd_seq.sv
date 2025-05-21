class sysrp_h2f_lw_wr_rd_seq extends sysrp_base_seq;
    
   rand int no_of_transactions ;
   rand int unsigned sequence_length = 10;

   `uvm_object_utils(sysrp_h2f_lw_wr_rd_seq);

   /** Declare a typed sequencer object that the sequence can access */
   `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_h2f_lw_wr_rd_seq");
    super.new(name);
  endfunction : new


  virtual function void build_phase(uvm_phase phase);
     `uvm_info ("build_phase", "[sysrp_h2f_lw_wr_rd_seq] Entered Sequence Build Phase...",UVM_LOW);
     `uvm_info ("build_phase", "[sysrp_h2f_lw_wr_rd_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase


  task body();
     bit [63:0] wdata, rdata, wdata_BE, rdata_BE;
     bit [31:0] addr;
     bit status;
     sysrp_pcie_linkup_sequence bring_up_link_seq;
     svt_pcie_mem_target_service target_mem_seq;
     svt_pcie_driver_app_mem_request_sequence mem_request_seq;

     super.body();

      //-----------------------------
      // Program the CS Scratchpad
      //-----------------------------
        addr  = 'h2001_2000;
        wdata = 'hBAAD_CAFE;
       `uvm_info(get_name(), "Writing/reading CS Scratchpad", UVM_LOW)
        mmio_write64(.addr_(addr), .data_(wdata));
        mmio_read64 (.addr_(addr), .data_(rdata));
        if(rdata !== wdata)
           `uvm_error(get_name(), $psprintf("Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
        else
           `uvm_info(get_name(), $psprintf("Data match 64! addr = %0h, data = %0h", addr, rdata), UVM_LOW)

      //--------------------------------------------------
      // Read Access on System ID Register at 0x2000_0000
      //--------------------------------------------------
        addr  = 'h2000_0000;
        wdata = $urandom();
       `uvm_info(get_name(), "Writing/Reading System ID Register", UVM_LOW)
        mmio_write64(.addr_(addr), .data_(wdata));
        mmio_read64 (.addr_(addr), .data_(rdata));
        if(rdata !== 'hacd5cafe)
           `uvm_error(get_name(), $psprintf("SystemID mismatch 64! Addr = %0h, Exp = 0xacd5cafe, Act = 0x%0h", addr, rdata))
        else
           `uvm_info(get_name(), $psprintf("Read SystenID addr = %0h, data = %0h", addr, rdata), UVM_LOW)

      //------------------------------------------------------------
      // Read Access on MSI-to-GIC Vector Register at 0x20018000
      //------------------------------------------------------------
        addr  = 'h2001_8000;
        wdata = $urandom();
       `uvm_info(get_name(), "Writing/Reading MSI-to-GIC Vector Register", UVM_LOW)
        mmio_write64(.addr_(addr), .data_(wdata));
        mmio_read64 (.addr_(addr), .data_(rdata));
        if(rdata !== wdata)
           `uvm_error(get_name(), $psprintf("Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
        else
           `uvm_info(get_name(), $psprintf("Read access addr = %0h, data = %0h", addr, rdata), UVM_LOW)

      //------------------------------------------------------------
      // Read Access on MSI-to-GIC CSR Register at 0x20018080
      //------------------------------------------------------------
        addr  = 'h2001_8080;
        wdata = $urandom();
       `uvm_info(get_name(), "Writing/Reading MSI-to-GIC CSR Register", UVM_LOW)
        mmio_write64(.addr_(addr), .data_(wdata));
        mmio_read64 (.addr_(addr), .data_(rdata));
        if(rdata !== 'h0)
           `uvm_error(get_name(), $psprintf("Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
        else
           `uvm_info(get_name(), $psprintf("Read access addr = %0h, data = %0h", addr, rdata), UVM_LOW)

      //------------------------------------------------------------
      // Read Access on Performance Counter Register at 0x200180A0
      //------------------------------------------------------------
        addr  = 'h2001_80A0;
        wdata = $urandom();
       `uvm_info(get_name(), "Writing/Reading Performance Counter Register", UVM_LOW)
        mmio_write64(.addr_(addr), .data_(wdata));
        mmio_read64 (.addr_(addr), .data_(rdata));
        if(rdata !== 'h0)
           `uvm_error(get_name(), $psprintf("Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
        else
           `uvm_info(get_name(), $psprintf("Read access addr = %0h, data = %0h", addr, rdata), UVM_LOW)

        `uvm_info("body", "Exiting...", UVM_LOW)

  endtask : body

endclass
