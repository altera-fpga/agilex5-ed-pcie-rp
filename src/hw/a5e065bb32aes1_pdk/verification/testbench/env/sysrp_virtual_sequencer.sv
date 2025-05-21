//=======================================================================
// COPYRIGHT (C) 2010, 2011, 2012, 2013 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------

/**
 * Abstract:
 * Defines a virtual sequencer for the testbench ENV.  This sequencer obtains
 * a handle to the reset interface using the config db.  This allows
 * reset sequences to be written for this sequencer.
 */

`ifndef GUARD_axi_virtual_sequencer_SV
`define GUARD_axi_virtual_sequencer_SV

class sysrp_virtual_sequencer extends uvm_sequencer;

  `uvm_component_utils(sysrp_virtual_sequencer)
   svt_axi_master_sequencer    master_sequencer;
   svt_axi_master_sequencer    h2f_master_sequencer;
   svt_pcie_device_system_virtual_sequencer endpoint_vseqr;
   svt_axi_slave_sequencer     h2f_slave_sequencer;

  function new(string name="sysrp_virtual_sequencer", uvm_component parent=null);
    super.new(name,parent);
  endfunction // new


  virtual function void build_phase(uvm_phase phase);
    `uvm_info("build_phase", "Entered...", UVM_LOW)
    super.build_phase(phase);
    this.endpoint_vseqr = svt_pcie_device_system_virtual_sequencer::type_id::create("endpoint_vseqr", this);
    `uvm_info("build_phase", "Exiting...", UVM_LOW)
  endfunction

endclass

`endif // GUARD_axi_virtual_sequencer_SV
