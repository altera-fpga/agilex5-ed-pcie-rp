class random_unique_address_from_hps;
    randc bit [31:0] address;
    constraint valid_address {address[31:12] inside {['h1_0000:'h1_fff0]}; address[11:0] == 0;} 
endclass


class sysrp_basic_avmm_bas_b2b_seq extends sysrp_base_seq;
    
  //rand int no_of_transactions ;
  rand int sequence_length ;
  rand int trans_no;

  `uvm_object_utils(sysrp_basic_avmm_bas_b2b_seq);

  /** Declare a typed sequencer object that the sequence can access */
  `uvm_declare_p_sequencer(sysrp_virtual_sequencer)

  function new (string name = "sysrp_basic_avmm_bas_b2b_seq");
     super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
     `uvm_info ("build_phase", "[sysrp_basic_avmm_bas_b2b_seq] Entered Sequence Build Phase...",UVM_LOW);
     `uvm_info ("build_phase", "[sysrp_basic_avmm_bas_b2b_seq] Exiting Sequence Build Phase...",UVM_LOW)
  endfunction: build_phase

  task body();
     bit [63:0] wdata, rdata, wdata_BE, rdata_BE;
     bit [31:0] addr;
     bit [5:0] len;
     bit [31:0] addr_array[$];
     bit [5:0] len_array[$]; 
     bit [1023:0] burst_rdata;
     random_unique_address_from_hps addr_obj;

     super.body() ;
     addr_obj = new();

     //-----------------------------------------------------------------------------
     //Perform Back to Back Memory Write/Read Transactions on H2F AVMM BAS interface to Endpoint
     //-----------------------------------------------------------------------------
     for (int i=0;i<sequence_length;i++) begin  //{
        addr_obj.randomize();
        addr=addr_obj.address;
        addr[11:0] = 'h0;
        len=$urandom_range(1,16);

        `uvm_info(get_name(), $psprintf("iteration_write=%0d, addr=0x%0h, len=0x%0h",i,addr,len), UVM_LOW) 

        h2f_write128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1));
        addr_array[i] = addr;
        len_array[i] = len; 
     end //}
    
     #200ns;

     for (int k=0;k<sequence_length;k++) begin  //{
        addr = addr_array[k];
        len = len_array[k];

        `uvm_info(get_name(), $psprintf("iteration_read=%0d, addr=0x%0h, len=0x%0h", k,addr,len), UVM_LOW)
        h2f_read128_random (.addr_(addr), .burst_length_(len), .burst_type_('h1), .data_(burst_rdata));
     end //}
     #10us;

   endtask:body

endclass
