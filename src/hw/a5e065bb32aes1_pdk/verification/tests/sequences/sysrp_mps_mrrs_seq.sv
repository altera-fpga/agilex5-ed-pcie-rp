class sysrp_mps_mrrs_seq extends sysrp_base_seq;
   rand int no_of_transactions ;
   rand int unsigned sequence_length = 10;
   rand int RP_MAX_payload ;
   rand int EP_MAX_payload ;
   rand int MAX_read_request_size;

  `uvm_object_utils(sysrp_mps_mrrs_seq);

   /** Declare a typed sequencer object that the sequence can access */
   `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

   function new (string name = "sysrp_mps_mrrs_seq");
      super.new(name);
   endfunction : new


   virtual function void build_phase(uvm_phase phase);
      `uvm_info ("build_phase", "[sysrp_mps_mrrs_seq] Entered Sequence Build Phase...",UVM_LOW);
      `uvm_info ("build_phase", "[sysrp_mps_mrrs_seq] Exiting Sequence Build Phase...",UVM_LOW)
   endfunction: build_phase


  task body();
     bit [5:0] len;
     bit [31:0] burst_wdata [31:0];
     bit [1023:0] burst_rdata;
     bit [63:0] rdata;
     bit [31:0] addr;
     bit[31:0]   dev_ctl_data;
     bit[2:0]    max_rd_req, max_pl_size;
     random_unique_address_from_hps addr_obj;
     super.body();
     addr_obj = new();

//====================================================================================================================
//====================================================================================================================
//====================================================================================================================

    //----------------------------------------
    // Setting MPS and MRRs for RP Dev ctl
    //----------------------------------------
      addr  = 'h2008_0078;
      if(MAX_read_request_size==128) begin
	       max_rd_req   = 3'b000;
        `uvm_info(get_name(), "MRRS set in sequence using config_db to 128", UVM_LOW)
         end
      else if(MAX_read_request_size==256) begin
	       max_rd_req   = 3'b001;
        `uvm_info(get_name(), "MRRS set in sequence using config_db to 256", UVM_LOW)
         end
      else if(MAX_read_request_size==512) begin
	       max_rd_req   = 3'b010;
        `uvm_info(get_name(), "MRRS set in sequence using config_db to 512", UVM_LOW)
         end
      else begin
	       max_rd_req   = 3'b000;
        `uvm_info(get_name(), "MRRS set in sequence by default to 128", UVM_LOW)
         end

      if(EP_MAX_payload==128) begin    
        `uvm_info(get_name(), "ENDPOINT MPS set in sequence using config_db to 128", UVM_LOW)
         end
      else if(EP_MAX_payload==256) begin
        `uvm_info(get_name(), "ENDPOINT MPS set in sequence using config_db to 256", UVM_LOW)
         end
      else if(EP_MAX_payload==512) begin
        `uvm_info(get_name(), "ENDPOINT MPS set in sequence using config_db to 512", UVM_LOW)
         end 
      else begin
        `uvm_info(get_name(), "ENDPOINT MPS set in sequence by default to 128", UVM_LOW)
         end
 
      if(RP_MAX_payload==128) begin    
         max_pl_size  = 3'b000;
        `uvm_info(get_name(), "ROOTPORT MPS set in sequence using config_db to 128", UVM_LOW)
         end
      else if(RP_MAX_payload==256) begin
         max_pl_size  = 3'b001;
        `uvm_info(get_name(), "ROOTPORT MPS set in sequence using config_db to 256", UVM_LOW)
         end
      else if(RP_MAX_payload==512) begin
         max_pl_size  = 3'b010;
        `uvm_info(get_name(), "ROOTPORT MPS set in sequence using config_db to 512", UVM_LOW)
         end 
      else begin
         max_pl_size  = 3'b000;
        `uvm_info(get_name(), "ROOTPORT MPS set in sequence by default to 128", UVM_LOW)
         end

      
      dev_ctl_data = {16'h0, 0, max_rd_req, 3'h0, 1'b0, max_pl_size, 5'b01111}; // Ext tag disable bit 8
     `uvm_info(get_name(), $psprintf("ST1 Writing Device control register RP MPS and MRRS [Writedata]=%0h", dev_ctl_data), UVM_LOW)
      h2f_mem_write32 (.addr_(addr), .data_(dev_ctl_data));     
      h2f_mem_read32 (.addr_(addr), .data_(rdata));
     `uvm_info(get_name(), $psprintf("Reading Device control register of RP [Readdata] = %0h", rdata), UVM_LOW)
      if(dev_ctl_data[15:0] !== rdata[15:0])
	 `uvm_error(get_name(), $psprintf("ST1 Device control register mismatch: Addr=0x%0h, wdata=0x%0h, rdata=0x%0h", addr, dev_ctl_data, rdata));

     //-----------------------------------------      
     // RP to EP
     //-----------------------------------------
     for (int i=1;i<=7;i++) begin //{ 
        addr_obj.randomize();
        addr=addr_obj.address;
        addr[11:0] = 'h0;
        /*
        if(max_rd_req == 3'b000) begin
           len=$urandom_range(8,32);
        end
        if(max_rd_req == 3'b001) begin
           len=$urandom_range(16,32);
        end
        if(max_rd_req == 3'b010) begin
           len=$urandom_range(24,32); //Here no split packet will be seen as 512Bytes=128DW. This range can be changed to 0-32
        end
        */
        len = 4*(i+1);
        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_write_addr = %0h, h2f_write_len=%0d",i,addr,len), UVM_LOW) 
        h2f_write128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1));

        #300ns;
        `uvm_info(get_name(), $psprintf("Transaction number = %0d, h2f_read_addr = %0h, h2f_read_len=%0d",i,addr,len), UVM_LOW)
        h2f_read128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1), .data_(burst_rdata));
        #10ns;
     end //}   

  endtask : body

endclass
