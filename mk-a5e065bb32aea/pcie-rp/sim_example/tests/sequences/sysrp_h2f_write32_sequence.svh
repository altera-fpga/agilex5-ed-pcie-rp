class sysrp_h2f_write32_sequence extends svt_axi_master_base_sequence;

  `svt_xvm_declare_p_sequencer(svt_axi_master_sequencer)
  `svt_xvm_object_utils(sysrp_h2f_write32_sequence)

  /** Address to be written */
  rand bit [31:0] addr;

  /** Address to be written */
  rand bit [31:0] data ;
  rand bit [7:0] burst_length;
  rand bit [2:0] burst_size;
  rand bit [1:0] burst_type;

  /**Write strobe */
  rand bit [3:0] wstrb;


  constraint write_strobe {
    soft wstrb == 4'hF;
  }

  svt_axi_transaction::atomic_type_enum atomic_type = svt_axi_transaction::NORMAL;

  function new(string name="sysrp_h2f_write32_sequence");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    `svt_xvm_do_with(req, {
      xact_type       == svt_axi_transaction::WRITE;
      addr            == local::addr;
      data.size()     == 1;
      data[0]         == local::data;
      burst_length    == 1;
      burst_size      == 2;
      burst_type      == 0;
      wstrb[0]        == local::wstrb;
      wvalid_delay[0] == 0; //to make wvalid and awvalid assert at the same time from VIP
    })
  
    get_response(rsp);
  endtask: body

  virtual function bit is_applicable(svt_configuration cfg);
    return 1;
  endfunction : is_applicable
endclass: sysrp_h2f_write32_sequence

