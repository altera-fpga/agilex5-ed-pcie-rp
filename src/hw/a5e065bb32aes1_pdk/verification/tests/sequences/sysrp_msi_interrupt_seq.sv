class randomize_add_data;
   randc bit[31:0] address;
   randc int array_index;
   constraint address_valid {address inside {'h2001_8000,'h2001_8004,'h2001_8008,'h2001_800C,'h2001_8010,'h2001_8014,'h2001_8018,'h2001_801C,'h2001_8020,'h2001_8024,'h2001_8028,'h2001_802C,'h2001_8030,'h2001_8034,'h2001_8038,'h2001_803C,'h2001_8040,'h2001_8044,'h2001_8048,'h2001_804C,'h2001_8050,'h2001_8054,'h2001_8058,'h2001_805C,'h2001_8060,'h2001_8064,'h2001_8068,'h2001_806C,'h2001_8070,'h2001_8074,'h2001_8078,'h2001_807C};}
   constraint index_valid {array_index inside {0,1,2,3,4};}
  
endclass


class sysrp_msi_interrupt_seq extends sysrp_base_seq;
   rand int no_of_transactions ;
   rand int unsigned sequence_length = 10;

   `uvm_object_utils(sysrp_msi_interrupt_seq);

   /** Declare a typed sequencer object that the sequence can access */
   `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

   function new (string name = "sysrp_msi_interrupt_seq");
      super.new(name);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);
      `uvm_info ("build_phase", "[sysrp_msi_interrupt_seq] Entered Sequence Build Phase...",UVM_LOW);
      `uvm_info ("build_phase", "[sysrp_msi_interrupt_seq] Exiting Sequence Build Phase...",UVM_LOW)
   endfunction: build_phase

   task body();
      bit [63:0] wdata, rdata, wdata_BE, rdata_BE;
      bit [31:0] addr;
      bit [31:0] burst_wdata [15:0];
      bit [1023:0] burst_rdata;
      bit[31:0]   dev_ctl_data;
      bit[2:0]    max_rd_req, max_pl_size;
      bit status;
      bit[31:0] local_status_reg;
      int index,multi_intr_array_index,intr_bit;
      int multi_intr_array[5];
      randomize_add_data obj,obj1;
      svt_pcie_driver_app_mem_request_sequence mem_request_seq;

      super.body();

      //===================================
      //MSI CAPABILITY Register for RP
      //===================================
      //Message control register at 0x50 at [31:16]
      //[0]   - MSI Enable                1
      //[3:1] - Multiple Message capable  RO field
      //[6:4] - Multiple Message enable  - 101 (32 vectors allocated)
      //[7]   - 64 bit address capable   - 1  (must be set if function in endpoint)

      //Message address register at 0x54 at [31:0]

      //Message upper address register at 0x58 at [31:0]

      //Message data register at 0x5C at [15:0]

      //-------------------------------------------------------
      // STEP-1 : Configuring MSI Capability Structure for RP
      //-------------------------------------------------------
      addr = 'h2008_0050; 
      h2f_mem_read32 (.addr_(addr), .data_(rdata));
      `uvm_info(get_name(), $psprintf("ST2:Message control register Addr=0x%0h, Rd_data=0x%0h", addr, rdata), UVM_LOW)

      addr  = 'h2008_0054; 
      h2f_mem_read32 (.addr_(addr), .data_(rdata));
      `uvm_info(get_name(), $psprintf("ST2:Message address register Addr=0x%0h, Rd_datas=0x%0h", addr, rdata), UVM_LOW)

      addr  = 'h2008_005C; 
      h2f_mem_read32 (.addr_(addr), .data_(rdata));
      `uvm_info(get_name(), $psprintf("ST2:Message data register Addr=0x%0h, Rd_data=0x%0h", addr, rdata), UVM_LOW)

      addr  = 'h2008_0054; 
      wdata = 'h2001_8000; //System specific address 'h2001_8000
      h2f_mem_write32 (.addr_(addr), .data_(wdata));
      h2f_mem_read32 (.addr_(addr), .data_(rdata));
      `uvm_info(get_name(), $psprintf("ST2: Write and read Message address reg Addr=0x%0h, Rd_data=0x%0h", addr, rdata), UVM_LOW)

      addr  = 'h2008_005C; 
      wdata = 'hA5A5_A5A5;  //System specific data
      h2f_mem_write32 (.addr_(addr), .data_(wdata));
      h2f_mem_read32 (.addr_(addr), .data_(rdata));
      `uvm_info(get_name(), $psprintf("ST2: Write and read Message data reg Addr=0x%0h, Rd_data=0x%0h", addr, rdata), UVM_LOW)

      //--------------------------------------------------------
      // STEP-2 : Configuring MSI-GIC CSR via H2F-LW Interface
      //--------------------------------------------------------
      addr  = 'h2001_8080; 
       mmio_read64 (.addr_(addr), .data_(rdata));
      `uvm_info(get_name(), $psprintf("ST2: Read MSI-to-GIC Status Register Addr=0x%0h, Rd_data=0x%0h", addr, rdata), UVM_LOW)
 
      addr  = 'h2001_8084; 
      mmio_read64 (.addr_(addr), .data_(rdata));
      `uvm_info(get_name(), $psprintf("ST2: Read MSI-to-GIC Error Reg Addr=0x%0h, Rd_data=0x%0h", addr, rdata), UVM_LOW)
 
      addr  = 'h2001_8088; 
      mmio_read64 (.addr_(addr), .data_(rdata));
      `uvm_info(get_name(), $psprintf("ST2: Read MSI-to-GIC Interrupt Mask Reg Addr=0x%0h, Rd_data=0x%0h", addr, rdata), UVM_LOW)
 
      addr  = 'h2001_8084; 
      wdata = 'hFFFF_FFFF;
      `uvm_info(get_name(), $psprintf("ST2: Write and read MSI-to-GIC Error Reg Addr=0x%0h, wdata=0x%0h", addr, wdata), UVM_LOW)
      mmio_write64(.addr_(addr), .data_(wdata));
      #20ns;
      mmio_read64 (.addr_(addr), .data_(rdata));
      if(rdata !== 'h0)
         `uvm_error(get_name(), $psprintf("ST2: Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
      else
         `uvm_info(get_name(), $psprintf("ST2: Data match 64! Error register is clearing after writing 1 to location. Addr=0x%0h, Rd_data=0x%0h", addr, rdata), UVM_LOW)
 
      //==================================
      // SINGLE INTERRUPT SCENARIO       /{
      //==================================

      //-------------------------------------------------------------
      // STEP-3 : Sending 1 DW MWr Interrupt Message from Endpoint 
      //-------------------------------------------------------------
      obj = new();
      obj1 = new();
      for(int i=0;i<32;i++) begin //{
         obj.randomize();
         addr = obj.address;
         `uvm_info(get_name(), $psprintf("ST2: 2a [INTR NO: %0d] Interrupt message sent from Endpoint to MSI-GIC at address %0h", i,addr), UVM_LOW)
         `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                                               mem_request_seq.address == addr;
                                                                                               mem_request_seq.length == 1;
                                                                                               mem_request_seq.traffic_class == 0;
                                                                                               mem_request_seq.address_translation == 0;
                                                                                               mem_request_seq.ep == 0;
                                                                                               mem_request_seq.th == 0;
                                                                                               mem_request_seq.first_dw_be == 'b1111;
                                                                                               mem_request_seq.last_dw_be == 'b0000;
                                                                                               mem_request_seq.write_payload[0] == 'h0000_A5A5;
                                                                                               mem_request_seq.block == 1; }); // Must block to avoid r/w collision

      //-------------------------------------------------------------
      // STEP-4 : Checking which status register bit is asserted 
      //-------------------------------------------------------------
      `uvm_info(get_name(), $psprintf("ST2: [INTR Wait: %0d] Waiting for status_reg !=0", 1), UVM_LOW)
      wait(`PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.status_reg[31:0]!='h0); 
      local_status_reg = `PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.status_reg[31:0];
      for(index=0 ;index<$size(local_status_reg);index++) begin
         if( local_status_reg & (1 << index))
            begin
               break;
            end  
      end   
      `uvm_info(get_name(), $psprintf("ST2: [INTR NO: %0d] Status reg = %h Bit asserted = %d", i,local_status_reg,index), UVM_LOW)
      #10;

      //----------------------------------------------------------------------------------------
      // STEP-5 : Based on status register bit, same bit is unmasked in Interrupt Mask Register 
      //----------------------------------------------------------------------------------------
      addr         = 'h2001_8088; 
      wdata        = 'h0000_0000;
      wdata[index] = 'b1;
      `uvm_info(get_name(), "ST2: [INTR NO: %0d] Writing and Reading MSI-to-GIC Interrupt Mask Register", UVM_LOW)
      mmio_write64(.addr_(addr), .data_(wdata));
      mmio_read64 (.addr_(addr), .data_(rdata));
      if(rdata !== wdata)
         `uvm_error(get_name(), $psprintf("ST2: Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
      else
         `uvm_info(get_name(), $psprintf("ST2: Data match 64! addr = %0h, data = %0h", addr, rdata), UVM_LOW)

      //------------------------------------------------------------------
      // STEP-6 : Waiting for IRQ signal to be asserted 
      //------------------------------------------------------------------
      `uvm_info(get_name(), $psprintf("ST2: [INTR Wait: %0d] Waiting for irq", 2), UVM_LOW)
      wait(`PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.irq=='b1)
      `uvm_info(get_name(), $psprintf("ST2: [INTR NO: %0d] Interrupt signal is asserted ", i), UVM_LOW)

      //------------------------------------------------------------------
      // STEP-7 : Read initiated from EP to MSI-GIC 
      //------------------------------------------------------------------
      `uvm_info(get_name(), $psprintf("ST2: [INTR NO: %0d] Read initiated from Endpoint to MSI-GIC", i), UVM_LOW)
      addr = 'h2001_8000+(4*index); 
      `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                                               mem_request_seq.address == addr;
                                                                                               mem_request_seq.length == 1;
                                                                                               mem_request_seq.traffic_class == 0;
                                                                                               mem_request_seq.address_translation == 0;
                                                                                               mem_request_seq.ep == 0;
                                                                                               mem_request_seq.th == 0;
                                                                                               mem_request_seq.first_dw_be == 'b1111;
                                                                                               mem_request_seq.last_dw_be == 'b0000;
                                                                                               mem_request_seq.block == 1; }); // Must block to avoid r/w collision

      //------------------------------------------------------------------
      // STEP-8 : Masking all bits in Interrupt Mask Register 
      //------------------------------------------------------------------
      `uvm_info(get_name(), $psprintf("ST2: [INTR Wait: %0d] Waiting for status_reg==0", 3), UVM_LOW)
      wait(`PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.status_reg[31:0]=='h0);
      `uvm_info(get_name(), $psprintf("ST2: [INTR Wait: %0d] Waiting for irq=0", 4), UVM_LOW)
      wait(`PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.irq=='b0)
      addr         = 'h2001_8088; 
      wdata        = 'h0000_0000;
      `uvm_info(get_name(), $psprintf("ST2: [INTR NO: %0d] Masking all bits to 0 in Interrupt Mask Register", i), UVM_LOW)
      mmio_write64(.addr_(addr), .data_(wdata));
      mmio_read64 (.addr_(addr), .data_(rdata));
      if(rdata !== wdata)
         `uvm_error(get_name(), $psprintf("ST2: Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
      else
         `uvm_info(get_name(), $psprintf("ST2: Data match 64! addr = %0h, data = %0h", addr, rdata), UVM_LOW)

      end //}
      #100;
   //}

    //==================================
    // MULTIPLE INTERRUPT SCENARIO     /{
    //==================================

    //-------------------------------------------------------------
    // STEP-3 : Sending Multiple Interrupt Messages from Endpoint 
    //-------------------------------------------------------------
    for(int i=0;i<5;i++) begin //{
       obj.randomize();
       addr = obj.address;
       `uvm_info(get_name(), $psprintf("ST2: [INTR NO: %0d] Multiple Interrupt messages sent from Endpoint to MSI-GIC at address %0h", i,addr), UVM_LOW)
       `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_WR;
                                                                                               mem_request_seq.address == addr;
                                                                                               mem_request_seq.length == 1;
                                                                                               mem_request_seq.traffic_class == 0;
                                                                                               mem_request_seq.address_translation == 0;
                                                                                               mem_request_seq.ep == 0;
                                                                                               mem_request_seq.th == 0;
                                                                                               mem_request_seq.first_dw_be == 'b1111;
                                                                                               mem_request_seq.last_dw_be == 'b0000;
                                                                                               mem_request_seq.write_payload[0] == 'h0000_A5A5;
                                                                                               mem_request_seq.block == 1; }); // Must block to avoid r/w collision
    end //}  

    #5us; //Waiting for all interrupt messages to reach MSI-GIC block
    //-------------------------------------------------------------
    // STEP-4 : Storing all status bits asserted in an array 
    //-------------------------------------------------------------
     multi_intr_array_index = 0;
     `uvm_info(get_name(), $psprintf("ST2: [INTR Wait: %0d] Waiting for status_reg !=0", 5), UVM_LOW)
     wait(`PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.status_reg[31:0]!='h0);
     local_status_reg = `PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.status_reg[31:0];
     for(index=0 ;index<$size(local_status_reg);index++) begin
       if( local_status_reg & (1 << index))
         begin
          multi_intr_array[multi_intr_array_index] = index;
          `uvm_info(get_name(), $psprintf("ST2: INDEX = %0d and VALUE = %0d", index,multi_intr_array[multi_intr_array_index]), UVM_LOW)
          multi_intr_array_index++;
         end  
      end   

      foreach(multi_intr_array[i]) 
        `uvm_info(get_name(), $psprintf("ST2: multi_intr_array[%0d] = %0d", i,multi_intr_array[i]), UVM_LOW)

    //------------------------------------------------------------------
    // STEP-5 : Unmasking interrupt bits based on status register bits 
    //------------------------------------------------------------------
      wdata           = 'h0000_0000;
      for(int i=0;i<5;i++)
       begin //{
        #10;
        addr            = 'h2001_8088; 
        intr_bit        = multi_intr_array[i];
        wdata[intr_bit] = 'b1;
       `uvm_info(get_name(), "ST2: [INTR NO: %0d] Writing and Reading MSI-to-GIC Interrupt Mask Register", UVM_LOW)
        mmio_write64(.addr_(addr), .data_(wdata));
        mmio_read64 (.addr_(addr), .data_(rdata));
        if(rdata !== wdata)
              `uvm_error(get_name(), $psprintf("ST2: Data mismatch 64! Addr = %0h, Exp = %0h, Act = %0h", addr, wdata, rdata))
        else
              `uvm_info(get_name(), $psprintf("ST2: Data match 64! addr = %0h, data = %0h", addr, rdata), UVM_LOW)
       end //}       

    //------------------------------------------------------------------
    // STEP-6 : Waiting for IRQ signal to be asserted 
    //------------------------------------------------------------------
      `uvm_info(get_name(), $psprintf("ST2: [INTR Wait: %0d] Waiting for irq=0", 6), UVM_LOW)
      wait(`PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.irq=='b1)
      `uvm_info(get_name(), $psprintf("ST2: Interrupt signal is asserted"), UVM_LOW)

    //------------------------------------------------------------------
    // STEP-7 : Read initiated from EP to MSI-GIC 
    //------------------------------------------------------------------
    for(int i=0;i<5;i++) begin  //{
       obj1.randomize();
       index = obj1.array_index;
      `uvm_info(get_name(), $psprintf("ST2: [INTR NO: %0d] Read initiated from Endpoint to MSI-GIC", index), UVM_LOW)
      addr = 'h2001_8000+(4*multi_intr_array[index]); 
      `uvm_do_on_with(mem_request_seq,p_sequencer.endpoint_vseqr.endpoint_virt_seqr.driver_transaction_seqr[0],{ mem_request_seq.transaction_type == svt_pcie_driver_app_transaction::MEM_RD;
                                                                                             mem_request_seq.address == addr;
                                                                                             mem_request_seq.length == 1;
                                                                                             mem_request_seq.traffic_class == 0;
                                                                                             mem_request_seq.address_translation == 0;
                                                                                             mem_request_seq.ep == 0;
                                                                                             mem_request_seq.th == 0;
                                                                                             mem_request_seq.first_dw_be == 'b1111;
                                                                                             mem_request_seq.last_dw_be == 'b0000;
                                                                                             mem_request_seq.block == 1; }); // Must block to avoid r/w collision
        #20;
        if(i!=4 && `PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.irq=='b1)
          begin
            `uvm_info(get_name(), $psprintf("ST2: Interrupt signal is still asserted as not all interrupts are cleared..!", index), UVM_LOW)
          end
    end //}

     `uvm_info(get_name(), $psprintf("ST2: [INTR Wait: %0d] Waiting for irq=0", 7), UVM_LOW)
     wait(`PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.irq=='b0)
     `uvm_info(get_name(), $psprintf("ST2: Waiting Interrupt signal is deasserted as all interrupts are served"), UVM_LOW)
     wait(`PCIE_SUBSYS.msi_to_gic.msi_to_gic_gen_0.status_reg[31:0]=='h0);
     `uvm_info(get_name(), $psprintf("ST2: Status register is cleared and default value is 32'h0"), UVM_LOW)
  //}

      `uvm_info("body", "Exiting...", UVM_LOW)

  endtask : body

endclass
