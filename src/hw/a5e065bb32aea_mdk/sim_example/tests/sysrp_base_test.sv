
`ifndef GUARD_rp_base_test_SV
`define GUARD_rp_base_test_SV

/**
 * Abstract:
 * This file creates a base test, which serves as the base class for the rest
 * of the tests in this environment.  This test sets up the default behavior
 * for the rest of the tests in this environment.
 */

`include "sysrp_axi_slave_mem_response_sequence.sv"
`include "sysrp_pcie_device_basic_env.sv"
`include "sysrp_pcie_shared_cfg.sv"
`include "sysrp_error_catcher.sv"

class sysrp_base_test extends uvm_test;

  /** UVM Component Utility Macro */
  `uvm_component_utils( sysrp_base_test )

  /** All messages are routed through this component */
  uvm_report_object reporter;

  /**
   * Instance of PCIE Device system configuration
   */
  sysrp_pcie_shared_cfg cust_cfg;
            
  /**
   * Instance of PCIE Device system environment 
   */
  sysrp_pcie_device_basic_env env;

  /**
   * error catcher instance, used to demote error/warning messages
   */
  sysrp_error_catcher catcher;

  // =============================================================================
  /**
   * Defines the constructor "new". In the constructor, super method is called
   * and the parent object is passed.
   */
  function new(string name="sysrp_base_test", uvm_component parent=null);
    super.new(name,parent);
    reporter = this;
  endfunction : new

  // =============================================================================
  /**
   * Build Phase
   * - Create and apply customized configuration
   * - Create the TB ENV
   * - Set the default sequences
   */
  virtual function void build_phase(uvm_phase phase);
    `uvm_info("build_phase", "Entered...", UVM_LOW)
    super.build_phase(phase);

    /** set default timeout */
    uvm_top.set_timeout(500ms);

    /** Create the configuration object required for this test */
    cust_cfg = sysrp_pcie_shared_cfg::type_id::create("cust_cfg");
    cust_cfg.endpoint_cfg = new();

    /** Setup the default configuration required for this test */
    cust_cfg.setup_pcie_device_system_defaults();

    /** Register the configuration with the registry so that it will be picked up by the env and sequencers, if needed. */
    uvm_config_db#(sysrp_pcie_shared_cfg)::set(this, "*", "cfg", cust_cfg);

    /** Create the environment */
    env = sysrp_pcie_device_basic_env::type_id::create("env", this);

    /** Apply the Slave default response sequence to every Slave sequencer
     * Slaves will use the memory response sequence by default.  To override this behavior
     * extended tests can apply a different sequence to the Slave Sequencers.
     * 
     * This sequence is configured for the run phase since the slave should always
     * respond to recognized requests.
     */

    uvm_config_db#(uvm_object_wrapper)::set(this, "env.axi_h2f_system_env.slave*.sequencer.run_phase", "default_sequence", sysrp_axi_slave_mem_response_sequence::type_id::get());

    
    /** Set the payload display limit */
    svt_pcie_dl_disp_pattern::default_max_payload_print_dwords = 1024;

    /** Create error catcer instance and add callback */
    catcher = sysrp_error_catcher::type_id::create("catcher", this);

    add_messages_to_demote();

    uvm_report_cb::add(null, catcher);

    `uvm_info("build_phase", "Exiting...", UVM_LOW)
  endfunction: build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    `uvm_info("end_of_elaboration_phase", "Entered...", UVM_LOW)
     uvm_top.print_topology();
    `uvm_info("BASE_TEST", "DISABLING AXI VIP PROTOCOL CHECKER ...",UVM_LOW)
     env.axi_h2f_system_env.master[0].monitor.checks.disable_check(env.axi_h2f_system_env.master[0].monitor.checks.bvalid_low_when_reset_is_active_check);
     env.axi_h2f_system_env.master[0].monitor.checks.disable_check(env.axi_h2f_system_env.master[0].monitor.checks.rvalid_low_when_reset_is_active_check);
     env.axi_h2f_system_env.master[0].monitor.checks.disable_check(env.axi_h2f_system_env.master[0].monitor.checks.signal_valid_bvalid_check);
     env.axi_h2f_system_env.master[0].monitor.checks.disable_check(env.axi_h2f_system_env.master[0].monitor.checks.signal_valid_bvalid_check_during_reset);
     env.axi_h2f_system_env.master[0].monitor.checks.disable_check(env.axi_h2f_system_env.master[0].monitor.checks.signal_valid_rvalid_check);
     env.axi_h2f_system_env.master[0].monitor.checks.disable_check(env.axi_h2f_system_env.master[0].monitor.checks.signal_valid_rvalid_check_during_reset);
     env.axi_system_env.master[0].monitor.checks.disable_check(env.axi_system_env.master[0].monitor.checks.bvalid_low_when_reset_is_active_check);
     env.axi_system_env.master[0].monitor.checks.disable_check(env.axi_system_env.master[0].monitor.checks.rvalid_low_when_reset_is_active_check);
     env.axi_system_env.master[0].monitor.checks.disable_check(env.axi_system_env.master[0].monitor.checks.signal_valid_bvalid_check);
     env.axi_system_env.master[0].monitor.checks.disable_check(env.axi_system_env.master[0].monitor.checks.signal_valid_bvalid_check_during_reset);
     env.axi_system_env.master[0].monitor.checks.disable_check(env.axi_system_env.master[0].monitor.checks.signal_valid_rvalid_check);
     env.axi_system_env.master[0].monitor.checks.disable_check(env.axi_system_env.master[0].monitor.checks.signal_valid_rvalid_check_during_reset);

    `ifdef SM_X4
       env.axi_h2f_system_env.slave[0].monitor.checks.disable_check(env.axi_h2f_system_env.slave[0].monitor.checks.arvalid_low_when_reset_is_active_check);
       env.axi_h2f_system_env.slave[0].monitor.checks.disable_check(env.axi_h2f_system_env.slave[0].monitor.checks.awvalid_low_when_reset_is_active_check);
       env.axi_h2f_system_env.slave[0].monitor.checks.disable_check(env.axi_h2f_system_env.slave[0].monitor.checks.signal_valid_arvalid_check_during_reset);
       env.axi_h2f_system_env.slave[0].monitor.checks.disable_check(env.axi_h2f_system_env.slave[0].monitor.checks.signal_valid_awvalid_check_during_reset);
       env.axi_h2f_system_env.slave[0].monitor.checks.disable_check(env.axi_h2f_system_env.slave[0].monitor.checks.signal_valid_wvalid_check_during_reset);
       env.axi_h2f_system_env.slave[0].monitor.checks.disable_check(env.axi_h2f_system_env.slave[0].monitor.checks.wvalid_low_when_reset_is_active_check);
    `endif  

    `uvm_info("end_of_elaboration_phase", "Exiting...", UVM_LOW)
  endfunction: end_of_elaboration_phase

  /**
   *  Calculate the pass or fail status for the test in the final phase method of the
   * test. If a UVM_FATAL, UVM_ERROR, or a UVM_WARNING message has been generated the
   * test will fail.
   */

  function void final_phase(uvm_phase phase);
    uvm_report_server svr;
    `uvm_info("final_phase", "Entered...",UVM_LOW)

    super.final_phase(phase);

    svr = uvm_report_server::get_server();

    `uvm_info("final_phase", "Exiting...", UVM_LOW)

    if((svr.get_severity_count(UVM_FATAL) +
        svr.get_severity_count(UVM_ERROR) +
        svr.get_severity_count(UVM_WARNING) == 0))
      `uvm_info("final_phase", "\nSvtTestEpilog TEST RESULT: PASSED\n", UVM_LOW)
    else
      `uvm_info("final_phase", "\nSvtTestEpilog TEST RESULT: FAILED\n", UVM_LOW)

  endfunction: final_phase

  function enable_vip_protocol_check();
    `uvm_info("BASE_TEST", "ENABLING AXI VIP PROTOCOL CHECKER AFTER LINK-UP...",UVM_LOW)
     env.axi_h2f_system_env.master[0].monitor.checks.enable_check(env.axi_h2f_system_env.master[0].monitor.checks.bvalid_low_when_reset_is_active_check);
     env.axi_h2f_system_env.master[0].monitor.checks.enable_check(env.axi_h2f_system_env.master[0].monitor.checks.rvalid_low_when_reset_is_active_check);
     env.axi_h2f_system_env.master[0].monitor.checks.enable_check(env.axi_h2f_system_env.master[0].monitor.checks.signal_valid_bvalid_check);
     env.axi_h2f_system_env.master[0].monitor.checks.enable_check(env.axi_h2f_system_env.master[0].monitor.checks.signal_valid_bvalid_check_during_reset);
     env.axi_h2f_system_env.master[0].monitor.checks.enable_check(env.axi_h2f_system_env.master[0].monitor.checks.signal_valid_rvalid_check);
     env.axi_h2f_system_env.master[0].monitor.checks.enable_check(env.axi_h2f_system_env.master[0].monitor.checks.signal_valid_rvalid_check_during_reset);
     env.axi_system_env.master[0].monitor.checks.enable_check(env.axi_system_env.master[0].monitor.checks.bvalid_low_when_reset_is_active_check);
     env.axi_system_env.master[0].monitor.checks.enable_check(env.axi_system_env.master[0].monitor.checks.rvalid_low_when_reset_is_active_check);
     env.axi_system_env.master[0].monitor.checks.enable_check(env.axi_system_env.master[0].monitor.checks.signal_valid_bvalid_check);
     env.axi_system_env.master[0].monitor.checks.enable_check(env.axi_system_env.master[0].monitor.checks.signal_valid_bvalid_check_during_reset);
     env.axi_system_env.master[0].monitor.checks.enable_check(env.axi_system_env.master[0].monitor.checks.signal_valid_rvalid_check);
     env.axi_system_env.master[0].monitor.checks.enable_check(env.axi_system_env.master[0].monitor.checks.signal_valid_rvalid_check_during_reset);
  endfunction

  function msg_and_severity_to_demote(string msg="", uvm_severity severity=UVM_ERROR);
    catcher.set_msg_to_demote(msg);
    catcher.set_severity_to_demote(severity);
  endfunction: msg_and_severity_to_demote

  //
  virtual function add_messages_to_demote();
    msg_and_severity_to_demote("Body definition undefined", UVM_WARNING);
    msg_and_severity_to_demote("Received SKP did not have SKP End indication", UVM_WARNING);
    msg_and_severity_to_demote("SKIP ordered set parity", UVM_WARNING);
    msg_and_severity_to_demote("Received non-Posted TLP", UVM_WARNING);
  endfunction: add_messages_to_demote

endclass // sysrp_base_test

`endif //  GUARD_rp_base_test_SV
