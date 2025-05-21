//===============================
// Description
//===============================

class sysrp_h2f_read_sequence extends svt_axi_master_base_sequence;

  `svt_xvm_declare_p_sequencer(svt_axi_master_sequencer)
  `svt_xvm_object_utils(sysrp_h2f_read_sequence)

  /** Address to be written */
  rand bit [31:0] addr;
  rand bit [7:0]  burst_length;
  rand bit [2:0] burst_size;
  rand bit [1:0] burst_type;

  rand bit disable_readdata ;

  constraint default_readdata {
    soft disable_readdata == 0;
  }

  svt_axi_transaction::atomic_type_enum atomic_type = svt_axi_transaction::NORMAL;

  function new(string name="sysrp_h2f_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    `svt_xvm_do_with(req, {
      xact_type == svt_axi_transaction::READ;
      addr == local::addr;
      atomic_type == local::atomic_type;
      burst_length == local::burst_length;
      burst_size   == local::burst_size;
      burst_type   == local::burst_type;
    })

    if(disable_readdata != 1)
     begin
      get_response(rsp);
     end

  endtask: body

  virtual function bit is_applicable(svt_configuration cfg);
    return 1;
  endfunction : is_applicable
endclass: sysrp_h2f_read_sequence
