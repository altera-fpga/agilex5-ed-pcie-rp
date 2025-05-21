//************************************************************************************************
// Copyright (C) 2025 - 2025 Altera Corporation
//
// This code and the related documents are Altera copyrighted materials and your use 
// of them is governed by the express license under which they were provided to you ("License"). 
// This code and the related documents are provided as is, with no express or implied 
// warranties other than those that are expressly stated in the License.
//************************************************************************************************

/**
 *  Abstract:
 *  class 'sysrp_pcie_device_basic_env' is extended from uvm_env base class. It implements
 *  the build phase to construct the structural elements of this environment.
 *
 *  sysrp_pcie_device_basic_env is the testbench environment, which constructs the PCIE Device System
 *  ENV in the build_phase method using the UVM factory service.  The PCIE Device System
 *  ENV  is the top level component provided by the PCIE VIP. The PCIE Device System ENV
 *  in turn, instantiates constructs the PCIE Root Complex device and Endpoint device. 
 *
 *  sysrp_pcie_device_basic_env also constructs the system virtual sequencer. 
 *  It connects virtual sequencers of Root and Endpoint PCIE devices.
 */

`ifndef GUARD_PCIE_DEVICE_BASIC_ENV_SV
`define GUARD_PCIE_DEVICE_BASIC_ENV_SV

`include "sysrp_virtual_sequencer.sv"
`include "sysrp_pcie_shared_cfg.sv"
`include "sysrp_scoreboard.sv"

typedef class sysrp_pcie_device_basic_env;

class sysrp_pcie_device_basic_env extends uvm_env;

  //===========================
  // PCIe-related env variables
  //===========================

  /** 
   * A PCIE agent acting as an Endpoint device. If a real PCIE Root Complex
   * DUT is added to this environment, then this agent would remain
   * as the PCIE EP connected to PCIE RC DUT. If a real PCIE EP DUT is added to
   * this environment, then this agent would NOT be created.
   */
  svt_pcie_device_agent endpoint;

  /**
   * System virtual sequencer handle used to connect to lower level PCIE Device virtual sequencer.
   */
  svt_pcie_device_system_virtual_sequencer sys_virt_seqr;

  /**
   * System configuration data object reference.
   *
   * This object is of a custom type, which contains sub-objects for the
   * configuration of the both the Root complex device and an Endpoint device.
   *
   * In the example as delivered, this object contains root_cfg and
   * endpoint_cfg sub-objects, each of which is of type svt_pcie_device_configuration,
   * which defines the entire configuration for one PCIE Device protocol stack.
   */
  sysrp_pcie_shared_cfg        pcie_cfg;

  /** Status object for Endpoint device. */
  svt_pcie_device_status endpoint_status;

  sysrp_scoreboard   sysrp_scbd;

  //===========================
  // AXI-related env variables
  //===========================

  /** AXI System ENV */
  svt_axi_system_env   axi_system_env;
  svt_axi_system_env   axi_h2f_system_env;

  /** Virtual Sequencer */
  sysrp_virtual_sequencer sequencer;

  /** AXI System Configuration */
  svt_axi_system_configuration axi_cfg;
  svt_axi_system_configuration h2f_axi_cfg;


  /** UVM Component Utility macro */
  `uvm_component_utils_begin(sysrp_pcie_device_basic_env)
    `uvm_field_object      (endpoint                , UVM_ALL_ON|UVM_DEEP)
    `uvm_field_object      (sys_virt_seqr           , UVM_ALL_ON|UVM_DEEP)
    `uvm_field_object      (pcie_cfg                , UVM_ALL_ON|UVM_DEEP)
    `uvm_field_object      (axi_cfg                 , UVM_ALL_ON|UVM_DEEP)
    `uvm_field_object      (h2f_axi_cfg             , UVM_ALL_ON|UVM_DEEP)
    `uvm_field_object      (endpoint_status         , UVM_ALL_ON|UVM_DEEP)
  `uvm_component_utils_end

  // ---------------------------------------------------------------------------
  /**
   * CONSTRUCTOR: Creates a new instance of the ENV class. Calling this constructor
   * does not fully create the ENV however, the uvm-defined method <b>build_phase()</b>
   * does that.
   */
  extern function new(string name="sysrp_pcie_device_basic_env", uvm_component parent=null);

  // ---------------------------------------------------------------------------
  /**
   * UVM Run Flow: Implementation of the ENV build method.
   * It calls configure for each of the contained ENV objects.
   */
  extern virtual function void build_phase(uvm_phase phase);

  // ---------------------------------------------------------------------------
  /**
   * UVM Run Flow: Implementation of the ENV connect method.
   * It takes care of connecting elements created in the build phase.
   */
  extern function void connect_phase(uvm_phase phase);


  //====================================
  // Function to configure AXI VIP
  //====================================
  extern function void AXIS_HOST_CFG();
  extern function void H2F_AXI4_CFG();


endclass : sysrp_pcie_device_basic_env

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
// End of Class Declarations - Beginning of Method Implementations
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

// =============================================================================
// IMPLEMENTIONS: Methods in the sysrp_pcie_device_basic_env class.

// -----------------------------------------------------------------------------
function sysrp_pcie_device_basic_env::new(string name="sysrp_pcie_device_basic_env", uvm_component parent=null);
  begin
    super.new(name,parent);
   end
endfunction

function void sysrp_pcie_device_basic_env::build_phase( uvm_phase phase );
   int pcie_tx_scbd,axi_tx_scbd;
   bit unaligned_enb = 0;
   bit error_case = 0;
   bit status1, status2, status3, status4, status5;
   int EP_MAX_payload, RP_MAX_payload, MAX_read_request_size, MAX_CPL_LATENCY, MIN_CPL_LATENCY;

   `uvm_info("build_phase", "Entered...",UVM_LOW)
   super.build_phase( phase );

   /**
    *  Check if the configuration is passed to the environment.
    *  If not then create the configuration and pass it to the device environment.
    */
   if(uvm_config_db#(sysrp_pcie_shared_cfg)::get(get_parent(), get_name(), "cfg", pcie_cfg)) begin
     `uvm_info("build_phase", "Using test case provided cfg", UVM_LOW)
   end
   else begin
     `uvm_info("build_phase", "External cfg not provided, creating default cfg.", UVM_LOW)
     pcie_cfg = sysrp_pcie_shared_cfg::type_id::create("pcie_cfg");
   end
   
   /** Set the model instance scope */
   //this.pcie_cfg.root_cfg.model_instance_scope = "sysrp_top_tb.root0";
   this.pcie_cfg.endpoint_cfg.model_instance_scope = "sysrp_top_tb.endpoint0";


      status1 = uvm_config_db #(int unsigned)::get(this, "", "rp_mps", RP_MAX_payload);
      if(status1)begin
         `uvm_info("body", $sformatf("ENV: rp_max_payload_size = %d", RP_MAX_payload), UVM_LOW); 
         this.pcie_cfg.endpoint_cfg.pcie_cfg.tl_cfg.remote_max_payload_size      = RP_MAX_payload; 
      end
      else begin
         `uvm_info("body", $sformatf("ENV: rp_max_payload_size is set to default(512)"), UVM_LOW);
         this.pcie_cfg.endpoint_cfg.pcie_cfg.tl_cfg.remote_max_payload_size      = 512; 
      end


      status2 =  uvm_config_db #(int unsigned)::get(this, "", "mrrs", MAX_read_request_size);
      if(status2)begin
         `uvm_info("body", $sformatf("ENV: max_read_request_size %d ", MAX_read_request_size), UVM_LOW);
         this.pcie_cfg.endpoint_cfg.pcie_cfg.tl_cfg.remote_max_read_request_size = MAX_read_request_size;
      end
      else begin
         `uvm_info("body", $sformatf("ENV: max_read_request_size is set to default(512)"), UVM_LOW);
         this.pcie_cfg.endpoint_cfg.pcie_cfg.tl_cfg.remote_max_read_request_size = 512;
      end


      status3 = uvm_config_db #(int unsigned)::get(this, "", "ep_mps", EP_MAX_payload);
      if(status3) begin
        `uvm_info("body", $sformatf("ENV: ep_max_payload_size = %d", EP_MAX_payload), UVM_LOW);
         this.pcie_cfg.endpoint_cfg.pcie_cfg.dl_cfg.max_payload_size             = EP_MAX_payload; 
      end
      else begin
        `uvm_info("body", $sformatf("ENV: ep_max_payload_size is set to default(512)"), UVM_LOW);
         this.pcie_cfg.endpoint_cfg.pcie_cfg.dl_cfg.max_payload_size             = 512;  
      end

      status4 = uvm_config_db #(int unsigned)::get(this, "", "min_cpl_latency", MIN_CPL_LATENCY);
      if(status4)begin
         `uvm_info("body", $sformatf("ENV: min_cpl_latency_in_ns = %d", MIN_CPL_LATENCY), UVM_LOW); 
         this.pcie_cfg.endpoint_cfg.target_cfg[0].min_mem_cpl_latency_ns = MIN_CPL_LATENCY; 
      end

      status5 = uvm_config_db #(int unsigned)::get(this, "", "max_cpl_latency", MAX_CPL_LATENCY);
      if(status5)begin
         `uvm_info("body", $sformatf("ENV: max_cpl_latency_in_ns = %d", MAX_CPL_LATENCY), UVM_LOW); 
         this.pcie_cfg.endpoint_cfg.target_cfg[0].max_mem_cpl_latency_ns = MAX_CPL_LATENCY; 
      end

      this.pcie_cfg.endpoint_cfg.target_cfg[0].max_read_cpl_data_size_in_bytes = 512; 
      this.pcie_cfg.endpoint_cfg.target_cfg[0].max_payload_size_in_bytes = 512;
      this.pcie_cfg.endpoint_cfg.target_cfg[0].flag_uninitialized_mem_read = 1'b0;


   /** Create status objects for Root and Endpoint devices */
   endpoint_status = svt_pcie_device_status::type_id::create("endpoint_status");

   /**
    * Register configurations for Root and Endpoint devices.
    */
   uvm_config_db#(svt_pcie_device_configuration)::set(this,  "endpoint",  "cfg",  this.pcie_cfg.endpoint_cfg);

   /**
    * Register status objects for Root and Endpoint devices.
    */
   uvm_config_db#(svt_pcie_device_status)::set(this,  "endpoint",  "shared_status",  this.endpoint_status);

  /** Construct an Endpoint device namely endpoint. */
  endpoint = svt_pcie_device_agent::type_id::create( "endpoint", this );

  /**
   * Create the system virtual sequencer.
   */
  this.sys_virt_seqr = svt_pcie_device_system_virtual_sequencer::type_id::create("sys_virt_seqr", this);


  //==================================
  // AXI-related Build Phase
  //==================================
  axi_cfg     = svt_axi_system_configuration::type_id::create("axi_cfg");
  h2f_axi_cfg = svt_axi_system_configuration::type_id::create("h2f_axi_cfg");
  AXIS_HOST_CFG();
  H2F_AXI4_CFG();

  /** Apply the configuration to the System ENV */
  uvm_config_db#(svt_axi_system_configuration)::set(this, "axi_system_env", "cfg", axi_cfg);
  uvm_config_db#(svt_axi_system_configuration)::set(this, "axi_h2f_system_env", "cfg", h2f_axi_cfg);

  /** Construct the system agent */
  axi_system_env     = svt_axi_system_env::type_id::create("axi_system_env", this);
  axi_h2f_system_env = svt_axi_system_env::type_id::create("axi_h2f_system_env", this);

  /** Construct the virtual sequencer */
  sequencer = sysrp_virtual_sequencer::type_id::create("sequencer", this);

  /** Construct Scoreboard */
  sysrp_scbd = sysrp_scoreboard::type_id::create("sysrp_scbd", this);
  status1 = uvm_config_db #(int unsigned)::get(this, "", "pcie_tx_scbd", pcie_tx_scbd);
  status2 = uvm_config_db #(int unsigned)::get(this, "", "axi_tx_scbd", axi_tx_scbd);
  status3 = uvm_config_db #(int unsigned)::get(this, "", "unaligned_enb", unaligned_enb);
  status4 = uvm_config_db #(int unsigned)::get(this, "", "error_case", error_case);

  sysrp_scbd.has_pcie_tx = pcie_tx_scbd; 
  sysrp_scbd.has_axi_tx  = axi_tx_scbd;
  sysrp_scbd.unaligned_enb = unaligned_enb;
  sysrp_scbd.error_case    = error_case;

  `uvm_info("body", $sformatf("ENV: has_pcie_tx = %d", pcie_tx_scbd), UVM_LOW);
  `uvm_info("body", $sformatf("ENV: has_axi_tx  = %d", axi_tx_scbd), UVM_LOW);
  `uvm_info("body", $sformatf("ENV: unaligned_enb  = %d", unaligned_enb), UVM_LOW);
  `uvm_info("body", $sformatf("ENV: error_case  = %d", error_case), UVM_LOW);

  `uvm_info("build_phase", "Exiting...", UVM_LOW)
endfunction

// -----------------------------------------------------------------------------
function void sysrp_pcie_device_basic_env::connect_phase(uvm_phase phase);
  begin

  `uvm_info("connect_phase", "Entered...",UVM_LOW)
  super.connect_phase(phase);

  /**
   * Connect up the Endpoint virtual sequencer -- always use the one setup by the PCIE Device ENV.
   */
  //this.sys_virt_seqr.endpoint_virt_seqr = endpoint.virt_seqr;

  //AXI Virtual Sequencer Connection
  sequencer.endpoint_vseqr.endpoint_virt_seqr   =  endpoint.virt_seqr; 
  sequencer.master_sequencer     =  axi_system_env.master[0].sequencer;
  sequencer.h2f_master_sequencer =  axi_h2f_system_env.master[0].sequencer;
  sequencer.h2f_slave_sequencer  = axi_h2f_system_env.slave[0].sequencer;

  //Scoreboard connections
  endpoint.port.dl.sent_tlp_observed_port.connect(sysrp_scbd.pcie_port_tx);    
  axi_h2f_system_env.slave[0].monitor.item_observed_port.connect(sysrp_scbd.axi_port_rx);

  axi_h2f_system_env.master[0].monitor.item_observed_port.connect(sysrp_scbd.axi_port_tx);
  endpoint.port.dl.received_tlp_observed_port.connect(sysrp_scbd.pcie_port_rx);    

  axi_h2f_system_env.slave[0].monitor.item_observed_port.connect(sysrp_scbd.axi_port_tx_from_slave);
  endpoint.port.dl.received_tlp_observed_port.connect(sysrp_scbd.pcie_port_rx_from_slave);    

  `uvm_info("connect_phase", "Exiting...", UVM_LOW)
  end
endfunction

function void sysrp_pcie_device_basic_env::AXIS_HOST_CFG();
      axi_cfg.num_masters = 1;
      axi_cfg.num_slaves  = 1 ;

      axi_cfg.create_sub_cfgs(1,1);

      axi_cfg.master_cfg[0].axi_interface_type = svt_axi_port_configuration::AXI4;
      axi_cfg.slave_cfg[0].axi_interface_type = svt_axi_port_configuration::AXI4;

      axi_cfg.master_cfg[0].is_active = 1;
      axi_cfg.slave_cfg[0].is_active = 1;
      axi_cfg.master_cfg[0].snoop_data_width = 32;

      axi_cfg.slave_cfg[0].snoop_data_width = 32;

      axi_cfg.master_cfg[0].id_width   = 4;
      axi_cfg.master_cfg[0].addr_width = 32;
      axi_cfg.master_cfg[0].data_width = 32;
      axi_cfg.slave_cfg[0].id_width = 4;
      axi_cfg.slave_cfg[0].addr_width = 32;
      axi_cfg.slave_cfg[0].data_width = 32;
 endfunction

 function void sysrp_pcie_device_basic_env::H2F_AXI4_CFG();
      h2f_axi_cfg.num_masters = 1;
      h2f_axi_cfg.num_slaves  = 1 ;

      h2f_axi_cfg.create_sub_cfgs(1,1);

      h2f_axi_cfg.master_cfg[0].axi_interface_type = svt_axi_port_configuration::AXI4;
      h2f_axi_cfg.slave_cfg[0].axi_interface_type = svt_axi_port_configuration::AXI4;

      h2f_axi_cfg.master_cfg[0].is_active = 1;
      h2f_axi_cfg.slave_cfg[0].is_active = 1;

      h2f_axi_cfg.master_cfg[0].snoop_data_width = 128;

      `ifdef SM_X4
      h2f_axi_cfg.slave_cfg[0].snoop_data_width = 256;
      h2f_axi_cfg.slave_cfg[0].data_width       = 256;
      `endif

      h2f_axi_cfg.master_cfg[0].id_width   = 4;
      h2f_axi_cfg.master_cfg[0].addr_width = 32;
      h2f_axi_cfg.master_cfg[0].data_width = 128;
      h2f_axi_cfg.slave_cfg[0].id_width = 4;
      `ifdef SM_X4
          h2f_axi_cfg.slave_cfg[0].addr_width = 36;
      `else
	  h2f_axi_cfg.slave_cfg[0].addr_width = 32;
      `endif
      h2f_axi_cfg.slave_cfg[0].default_wready = 1; 
      h2f_axi_cfg.master_cfg[0].default_rready = 1;

      h2f_axi_cfg.wready_watchdog_timeout = 0; 
      h2f_axi_cfg.rdata_watchdog_timeout   = 0; 
      h2f_axi_cfg.bready_watchdog_timeout   = 0; 
      h2f_axi_cfg.bresp_watchdog_timeout  = 0;
      h2f_axi_cfg.arready_watchdog_timeout = 0;
      
      // Added for dropping completions from EP scenario 
      h2f_axi_cfg.master_cfg[0].num_outstanding_xact = -1;
      h2f_axi_cfg.master_cfg[0].num_write_outstanding_xact = 100;
      h2f_axi_cfg.master_cfg[0].num_read_outstanding_xact  = 100;
 
 endfunction

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
// End of Method Implementations
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

`endif //  GUARD_PCIE_DEVICE_BASIC_ENV_SV

