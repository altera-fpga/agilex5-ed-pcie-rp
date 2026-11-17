
`ifndef GUARD_pcie_linkup_sequence_SV
`define GUARD_pcie_linkup_sequence_SV

/** 
 *  This sequence calls linkup sequence and then waits for link to enter Gen4.
 */
class sysrp_pcie_linkup_sequence extends svt_pcie_device_system_virtual_base_sequence; 
  
  /** 
   * Factory Registration. 
   */
  `uvm_object_utils(sysrp_pcie_linkup_sequence)

  /** 
   * Parent Sequencer Declaration.
   */
  `svt_xvm_declare_p_sequencer(svt_pcie_device_system_virtual_sequencer)
  
  /** 
   * Constructs the sysrp_pcie_linkup_sequence sequence
   * @param name string to name the instance.
   */
  function new(string name = "sysrp_pcie_linkup_sequence");
    super.new(name);
  endfunction

  /** 
   * Executes the sysrp_pcie_linkup_sequence sequence. 
   */
  extern virtual task body();
endclass : sysrp_pcie_linkup_sequence


task sysrp_pcie_linkup_sequence:: body();
  begin
    svt_pcie_dl_service_set_link_en_sequence link_en_seq;
    svt_pcie_device_status endpoint_status;

    `uvm_info("body", "Entered...", UVM_LOW)

    endpoint_status = p_sequencer.get_endpoint_shared_status(this);

    `uvm_info("body", "Virtual sequence started", UVM_HIGH);
    
    fork
        `uvm_do_on_with(link_en_seq,p_sequencer.endpoint_virt_seqr.pcie_virt_seqr.dl_seqr, { link_en_seq.enable == 1'b1;} )
    join

    `uvm_info("body", "Wait for link to come up from EP SIDE for Gen1", UVM_LOW);
    wait(endpoint_status.pcie_status.pl_status.link_up == 1'b1);
    `uvm_info("body", "LINKUP DONE in Gen1 from EP SIDE", UVM_LOW);
     wait(endpoint_status.port_status.pl_status.ltssm_state == svt_pcie_types::RECOVERY_RCVRLOCK) ;
     wait(endpoint_status.port_status.pl_status.ltssm_state == svt_pcie_types::L0) ;
    `uvm_info("body", "Entered L0 after changing speed to GEN3", UVM_LOW);
     wait(endpoint_status.port_status.pl_status.ltssm_state == svt_pcie_types::RECOVERY_RCVRLOCK) ;
     wait(endpoint_status.port_status.pl_status.ltssm_state == svt_pcie_types::L0) ;
    `uvm_info("body", "Entered L0 after changing speed to GEN4", UVM_LOW);
    #2us;

 end
endtask 

`endif // GUARD_pcie_linkup_sequence_SV
