
/**
 * Abstract:
 * Class sysrp_axi_slave_mem_response_sequence defines a sequence class that
 * the testbench uses to provide slave response to the Slave agent present in
 * the System agent. The sequence receives a response object of type
 * svt_axi_slave_transaction from slave sequencer. The sequence class then
 * randomizes the response with constraints and provides it to the slave driver
 * within the slave agent. The sequence also instantiates the slave built-in
 * memory, and writes into or reads from the slave memory.
 *
 * Execution phase: main_phase
 * Sequencer: Slave agent sequencer
 */

`ifndef GUARD_AXI_SLAVE_MEM_RESPONSE_SEQUENCE_SV
`define GUARD_AXI_SLAVE_MEM_RESPONSE_SEQUENCE_SV

class sysrp_axi_slave_mem_response_sequence extends svt_axi_slave_base_sequence;

  svt_axi_slave_transaction req_resp;
  int wready_dly = 0;
  int m_wready_dly;

  /** UVM Object Utility macro */
  `uvm_object_utils(sysrp_axi_slave_mem_response_sequence)

  /** Class Constructor */
  function new(string name="sysrp_axi_slave_mem_response_sequence");
    super.new(name);
  endfunction

  virtual task body();
    integer status;
    svt_configuration get_cfg;

    `uvm_info("body", "Entered ...", UVM_LOW)

    if (!uvm_config_db#(int)::get(null, get_full_name(), "wready_dly", wready_dly))
      `uvm_info("sysrp_axi_slave_mem_response_sequence",
                $sformatf(" considersing wread_dly = %0d", wready_dly), UVM_LOW)
    else
      `uvm_info("sysrp_axi_slave_mem_response_sequence",
                $sformatf(" taking new value of wread_dly = %0d", wready_dly), UVM_LOW)

    // consumes responses sent by driver
    sink_responses();

    forever begin
      /**
       * Get the response request from the slave sequencer. The response request is
       * provided to the slave sequencer by the slave port monitor, through
       * TLM port.
       */
      p_sequencer.response_request_port.peek(req_resp);

      /**
       * Randomize the response and delays
       */
      m_wready_dly = (wready_dly > 0)? $urandom_range(1,15) : 0;
      `uvm_info("sysrp_axi_slave_mem_response_sequence", $sformatf("ST1: m_wread_dly = %0d", m_wready_dly), UVM_LOW)

      status=req_resp.randomize with {
        bresp == svt_axi_slave_transaction::OKAY;
        foreach (rresp[index])  {
          rresp[index] == svt_axi_slave_transaction::OKAY;
        foreach (wready_delay[i])
          wready_delay[i] == m_wready_dly;
        foreach (tready_delay[i])
	  tready_delay[i] == m_wready_dly;
          }
       };
       if(!status)
        `uvm_fatal("body","Unable to randomize a response")

      /**
       * If write transaction, write data into slave built-in memory, else get
       * data from slave built-in memory
       */
      if(req_resp.get_transmitted_channel() == svt_axi_slave_transaction::WRITE) begin
        `protect      
        put_write_transaction_data_to_mem(req_resp);
        `endprotect
      end
      else if (req_resp.get_transmitted_channel() == svt_axi_slave_transaction::READ) begin
        `protect
        get_read_data_from_mem_to_transaction(req_resp);
        `endprotect
      end
    
      $cast(req,req_resp);

      /**
       * send to driver
       */
      `uvm_send(req)

    end

    `uvm_info("body", "Exiting...", UVM_LOW)
  endtask: body

endclass: sysrp_axi_slave_mem_response_sequence

`endif // GUARD_AXI_SLAVE_MEM_RESPONSE_SEQUENCE_SV
