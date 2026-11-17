//***********************************************************************************************
// Copyright (C) 2025 - 2025 Altera Corporation
//
// This code and the related documents are Altera copyrighted materials and your use 
// of them is governed by the express license under which they were provided to you ("License"). 
// This code and the related documents are provided as is, with no express or implied 
// warranties other than those that are expressly stated in the License.
//************************************************************************************************

`ifndef GUARD_PCIE_SHARED_CFG_SV
`define GUARD_PCIE_SHARED_CFG_SV

`include "svt_pcie_device_configuration.sv"

// =============================================================================
/**
 * This class extension defines a custom system configuration data object
 * up through the PCIE application layers. It is used to encapsulate 2 PCIE 
 * Device configuration objects. It is also used to encapsulate configuration 
 * information that is specific to this environment. An object of this type 
 * will be created by a testcase, and passed to the UVM verification environment 
 * used by that testcase. The UVM verification environment will then extract the 
 * sub-objects that represent the PCIE Device system configurations for the 2 
 * separate PCIE Devices, and pass them to the correct components.
 */
class sysrp_pcie_shared_cfg extends uvm_object;
 
  /**
   * Configuration object used by the Endpoint PCIE Device objects.
   */
  rand svt_pcie_device_configuration endpoint_cfg;

  `uvm_object_utils_begin(sysrp_pcie_shared_cfg)
     `uvm_field_object  (endpoint_cfg , UVM_ALL_ON | UVM_DEEP)
  `uvm_object_utils_end
 
  //----------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Create a new configuration instance, passing the appropriate argument
   * values to the super.
   *
   * @param name Instance name of the configuration
   */
  function new(string name = "sysrp_pcie_shared_cfg");
    super.new(name);
    begin
      // Create Root complex and endpoint configurations
      this.endpoint_cfg = new("endpoint_cfg"); 
    end
  endfunction

  //----------------------------------------------------------------------------
  /**
   * Returns the class name for the object.
   */
  virtual function string get_class_name ();
    get_class_name = "sysrp_pcie_shared_cfg";
  endfunction
 
  /** Setup the PCIE device system default values */
  function void setup_pcie_device_system_defaults();
    begin

      endpoint_cfg.pcie_cfg.enable_transaction_logging = 1'b1;
      endpoint_cfg.pcie_cfg.transaction_log_filename   = "trans.log";
      endpoint_cfg.pcie_cfg.enable_symbol_logging      = 1'b1;
      endpoint_cfg.pcie_cfg.symbol_log_filename        = "symbol.log";
      endpoint_cfg.device_is_root                      = 0;
      endpoint_cfg.pcie_spec_ver                       = svt_pcie_device_configuration::PCIE_SPEC_VER_4_0;
      endpoint_cfg.pipe_spec_ver                       = svt_pcie_device_configuration::PIPE_SPEC_VER_4_4;
      endpoint_cfg.pcie_cfg.pl_cfg.skip_polling_active = 1;
      endpoint_cfg.pcie_cfg.enable_cov                 = 4'b1111;      // [3] TL [2] DL [1] PL [0] PIPE
      endpoint_cfg.pcie_cfg.pl_cfg.highest_enabled_equalization_phase = 1; //to skip the EQ phase2, 3

      `ifdef SM_X4
         endpoint_cfg.pcie_cfg.pl_cfg.set_link_width_values(4);
	 endpoint_cfg.pcie_cfg.pl_cfg.enable_sris_elastic_buffer_mode = 1;
      `endif
        
      endpoint_cfg.pcie_cfg.pl_cfg.enable_ctrl_skp_support = 1;
      endpoint_cfg.pcie_cfg.pl_cfg.upstream_lanes_recovery_eq_phase0_timeout_ns = 24000;
      endpoint_cfg.pcie_cfg.pl_cfg.upstream_lanes_recovery_eq_phase1_timeout_ns = 60000;

      //Gen1 --> Gen5 (No Eq) (VIP doc)
      endpoint_cfg.pcie_cfg.pl_cfg.set_link_speed_values(32'h1E);
      endpoint_cfg.pcie_cfg.pl_cfg.set_link_eq_attribute_values(,1,0);
      endpoint_cfg.driver_cfg[0].requester_id = 'h100;  //Requester ID by default

      // Shadow memory checking is required in case of VIP acting as RC, 
      // since here VIP is configured as Endpoint, switching off shadow memory checking.
      endpoint_cfg.pcie_cfg.tl_cfg.enable_shadow_cfg_lookup = 1'b0 ;
    end
  endfunction

  //----------------------------------------------------------------------------
  /**
   * Checks to see that the data field values are valid, focusing mainly making sure the
   * root and endpoint common parameters are consistent. This does NOT check the
   * validity of the contained root and endpoint configurations.
   */
  virtual function bit is_valid ( bit silent = 1, int kind = -1 );
    begin
      is_valid = 1;
      `uvm_info("is_valid", "check", UVM_LOW)
 
 
      if(!endpoint_cfg.is_valid()) begin
        if(!silent) begin
          `uvm_info("is_valid", $psprintf("Invalid endpoint configuration.  Contents:\n%s", endpoint_cfg.sprint()), UVM_HIGH)
        end
        is_valid = 0;
      end
 
      if (endpoint_cfg.device_is_root == 1'b1) begin
        if (!silent) begin
          `uvm_error("is_valid", $sformatf("The device_is_root variable is set to 1'b1 for endpoint_cfg.\n"));
        end
        is_valid = 0;
      end
 
    end
  endfunction

endclass

`endif // GUARD_PCIE_SHARED_CFG_SV
