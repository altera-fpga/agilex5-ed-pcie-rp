`define DEFAULT_ZERO 0
`define DEFAULT_HIP_STATUS 'h8b
// HIP Status Value = 'h8b (1000_1011)
// HIP Status[0]   = 1  (PCIe LinkUp) 
// HIP Status[1]   = 1  (PCIe DLUp)
// HIP Status[7:3] = 'h11 (LTSSM is L0)
// Above mentioned values are as per Spec Section 4.1.1.3.1 (CSR Space)
`define DEFAULT_SYSTEM_ID 'hacd5cafe
`define UPDATED_COMPLETION_TIMEOUT 'hf_4240
`define DEFAULT_CLK_FREQ 'h0007a120

`define default_check(addr,rd_data,default_val) \
        if(``rd_data`` !== ``default_val``)\
           `uvm_error(get_name(), $psprintf("Data mismatch 64! Addr=%0h, Exp=%0h, Act=%0h", ``addr``, ``default_val``, ``rd_data``))\
        else\
           `uvm_info(get_name(), $psprintf("Data match 64! addr=%0h, data=%0h", ``addr``, ``rd_data``), UVM_LOW)\


class sysrp_por_register_seq extends sysrp_base_seq;
    
  rand int no_of_transactions ;
  rand int unsigned sequence_length = 10;

  `uvm_object_utils(sysrp_por_register_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_por_register_seq");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
   `uvm_info ("build_phase", "[sysrp_por_register_seq] Entered Sequence Build Phase...",UVM_LOW);
   `uvm_info ("build_phase", "[sysrp_por_register_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
    bit [63:0] wdata, rdata, wdata_BE, rdata_BE;
    bit [31:0] addr;
    bit status;
    sysrp_pcie_linkup_sequence bring_up_link_seq;
	  svt_pcie_mem_target_service target_mem_seq;
    svt_pcie_driver_app_mem_request_sequence mem_request_seq;
    super.body();
    //----------
    // Link up
    //----------
    `uvm_info("body", "Entered ...", UVM_LOW)

      //------------------------------------------------------------
      // Read System ID Register at 0x2000_0000
      //------------------------------------------------------------
        addr  = 'h2000_0000;
        mmio_read64 (.addr_(addr), .data_(rdata));
       `uvm_info(get_name(), $psprintf("Reading F2H interface tester Register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       `default_check(addr,rdata,`DEFAULT_SYSTEM_ID);

      //------------------------------------------------------------
      // Read Access on ILC Register at 0x20001100
      //------------------------------------------------------------
        addr  = 'h2000_1100;
        mmio_read64 (.addr_(addr), .data_(rdata));
       `uvm_info(get_name(), $psprintf("Reading ILC Register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       `default_check(addr,rdata,`DEFAULT_ZERO);

      //------------------------------------------------------------
      // Read Access on MSI-to-GIC Vector Register at 0x20018000
      //------------------------------------------------------------
        addr  = 'h2001_8000;
        mmio_read64 (.addr_(addr), .data_(rdata));
       `uvm_info(get_name(), $psprintf("Reading MSI-to-GIC Vector Register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       `default_check(addr,rdata,`DEFAULT_ZERO);

      //------------------------------------------------------------
      // Read Access on MSI-to-GIC CSR Register at 0x20018080
      //------------------------------------------------------------
        addr  = 'h2001_8080;
        mmio_read64 (.addr_(addr), .data_(rdata));
       `uvm_info(get_name(), $psprintf("Reading MSI-to-GIC CSR Register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       `default_check(addr,rdata,`DEFAULT_ZERO);

      //------------------------------------------------------------
      // Read Access on Performance Counter Register at 0x200180A0
      //------------------------------------------------------------
        addr  = 'h2001_80A0;
        mmio_read64 (.addr_(addr), .data_(rdata));
       `uvm_info(get_name(), $psprintf("Reading Performance Counter Register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       `default_check(addr,rdata,`DEFAULT_ZERO);

      //---------------------------------------------------------------------------
      // Reading HIP status sideband register
      //---------------------------------------------------------------------------
        addr = 'h2001_80C0;       
        mmio_read64(.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("Reading HIP status sideband register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       `default_check(addr,rdata,`DEFAULT_HIP_STATUS);

      //---------------------------------------------------------------------------
      // Reading Completion timeout register 
      //---------------------------------------------------------------------------
        addr = 'h2001_80C4;       
        mmio_read64(.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("Reading Completion timeout register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       `default_check(addr,rdata,`UPDATED_COMPLETION_TIMEOUT);

        //Cpl timeout smaller ---
        wdata = 'h2_4240;
        mmio_write64(.addr_(addr), .data_(wdata));
        mmio_read64 (.addr_(addr), .data_(rdata));
        if(rdata !== wdata)
           `uvm_error(get_name(), $psprintf("ST1: Mismatch Cpl timeout Addr=%0h, Exp_rdata=%0h, Act_rdata=%0h", addr, wdata, rdata))
        else
           `uvm_info(get_name(), $psprintf("ST1: Match addr=%0h, rdata=%0h", addr, rdata), UVM_LOW)


      //---------------------------------------------------------------------------
      // Reading Clock frequency register
      //---------------------------------------------------------------------------
        addr = 'h2001_80C8;       
        mmio_read64(.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("Reading Clock frequency register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       `default_check(addr,rdata,`DEFAULT_CLK_FREQ);

      //---------------------------------------------------------------------------
      // Reading Control register 
      //---------------------------------------------------------------------------
        addr = 'h2001_80CC;       
        mmio_read64(.addr_(addr), .data_(rdata));
        `uvm_info(get_name(), $psprintf("Reading Control register addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       `default_check(addr,rdata,`DEFAULT_ZERO);

    `uvm_info("body", "Exiting...", UVM_LOW)

  endtask : body

endclass
