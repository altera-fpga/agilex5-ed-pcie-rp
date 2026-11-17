class sysrp_axi_derived_read_sequence extends svt_axi_master_base_sequence;

  `svt_xvm_declare_p_sequencer(svt_axi_master_sequencer)
  `svt_xvm_object_utils(sysrp_axi_derived_read_sequence)

  /** Address to be written */
  rand bit [31:0] addr;

  /** Address to be written */
  /** Enable the check of the expected data. */
  bit check_enable = 1;

  svt_axi_transaction::atomic_type_enum atomic_type = svt_axi_transaction::NORMAL;

  function new(string name="sysrp_axi_derived_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    `svt_xvm_do_with(req, {
      xact_type == svt_axi_transaction::READ;
      addr == local::addr;
      atomic_type == local::atomic_type;
      burst_length == 1;
      burst_size   == 2;
    })

    get_response(rsp);

  endtask: body

  virtual function bit is_applicable(svt_configuration cfg);
    return 1;
  endfunction : is_applicable
endclass: sysrp_axi_derived_read_sequence

