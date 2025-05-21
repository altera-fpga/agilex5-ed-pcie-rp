class sysrp_h2f_write128_sequence extends svt_axi_master_base_sequence;

  `svt_xvm_declare_p_sequencer(svt_axi_master_sequencer)
  `svt_xvm_object_utils(sysrp_h2f_write128_sequence)

  /** Address to be written */
  rand bit [31:0] addr;

  /** Address to be written */
  rand bit [31:0] data [31:0] ;
  //rand bit [31:0] data ;
  rand bit [7:0] burst_length;
  rand bit [1:0] burst_type;

  /**Write strobe */
  rand bit [15:0] wstrb;


  constraint write_strobe {
    soft wstrb == 16'hFFFF;
  }

  svt_axi_transaction::atomic_type_enum atomic_type = svt_axi_transaction::NORMAL;

  function new(string name="sysrp_h2f_write128_sequence");
    super.new(name);
  endfunction

  virtual task body();
    bit[4:0] no_of_transfer;
    super.body();
    no_of_transfer = burst_length;
    if(no_of_transfer=='h1)
      begin
    `svt_xvm_do_with(req, {
      xact_type       == svt_axi_transaction::WRITE;
      addr            == local::addr;
      data.size()     == local::no_of_transfer;
      data[0][31:0]   == local::data[0];
      data[0][63:32]  == local::data[1];
      data[0][95:64]  == local::data[2];
      data[0][127:96] == local::data[3];
      burst_length    == local::burst_length;
      burst_size      == 'h4;
      burst_type      == local::burst_type;
      wstrb[0]        == local::wstrb;
      wvalid_delay[0] == 0; //to make wvalid and awvalid assert at the same time from VIP
    })
      end
    else if(no_of_transfer=='h2)
      begin
    `svt_xvm_do_with(req, {
      xact_type       == svt_axi_transaction::WRITE;
      addr            == local::addr;
      data.size()     == local::no_of_transfer;
      data[0][31:0]   == local::data[0];
      data[0][63:32]  == local::data[1];
      data[0][95:64]  == local::data[2];
      data[0][127:96] == local::data[3];
      data[1][31:0]   == local::data[4];
      data[1][63:32]  == local::data[5];
      data[1][95:64]  == local::data[6];
      data[1][127:96] == local::data[7];
      burst_length    == local::burst_length;
      burst_size      == 'h4;
      burst_type      == local::burst_type;
      wstrb[0]        == local::wstrb;
      wvalid_delay[0] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[1]        == local::wstrb;
      wvalid_delay[1] == 0; //to make wvalid and awvalid assert at the same time from VIP
    })
      end
    else if(no_of_transfer=='h3)
      begin
    `svt_xvm_do_with(req, {
      xact_type       == svt_axi_transaction::WRITE;
      addr            == local::addr;
      data.size()     == local::no_of_transfer;
      data[0][31:0]   == local::data[0];
      data[0][63:32]  == local::data[1];
      data[0][95:64]  == local::data[2];
      data[0][127:96] == local::data[3];
      data[1][31:0]   == local::data[4];
      data[1][63:32]  == local::data[5];
      data[1][95:64]  == local::data[6];
      data[1][127:96] == local::data[7];
      data[2][31:0]   == local::data[8];
      data[2][63:32]  == local::data[9];
      data[2][95:64]  == local::data[10];
      data[2][127:96] == local::data[11];
      burst_length    == local::burst_length;
      burst_size      == 'h4;
      burst_type      == local::burst_type;
      wstrb[0]        == local::wstrb;
      wvalid_delay[0] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[1]        == local::wstrb;
      wvalid_delay[1] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[2]        == local::wstrb;
      wvalid_delay[2] == 0; //to make wvalid and awvalid assert at the same time from VIP
    })
      end
    else if(no_of_transfer=='h4)
      begin
    `svt_xvm_do_with(req, {
      xact_type       == svt_axi_transaction::WRITE;
      addr            == local::addr;
      data.size()     == local::no_of_transfer;
      data[0][31:0]   == local::data[0];
      data[0][63:32]  == local::data[1];
      data[0][95:64]  == local::data[2];
      data[0][127:96] == local::data[3];
      data[1][31:0]   == local::data[4];
      data[1][63:32]  == local::data[5];
      data[1][95:64]  == local::data[6];
      data[1][127:96] == local::data[7];
      data[2][31:0]   == local::data[8];
      data[2][63:32]  == local::data[9];
      data[2][95:64]  == local::data[10];
      data[2][127:96] == local::data[11];
      data[3][31:0]   == local::data[12];
      data[3][63:32]  == local::data[13];
      data[3][95:64]  == local::data[14];
      data[3][127:96] == local::data[15];
      burst_length    == local::burst_length;
      burst_size      == 'h4;
      burst_type      == local::burst_type;
      wstrb[0]        == local::wstrb;
      wvalid_delay[0] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[1]        == local::wstrb;
      wvalid_delay[1] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[2]        == local::wstrb;
      wvalid_delay[2] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[3]        == local::wstrb;
      wvalid_delay[3] == 0; //to make wvalid and awvalid assert at the same time from VIP
    })
      end
    else if(no_of_transfer=='h5)
      begin
    `svt_xvm_do_with(req, {
      xact_type       == svt_axi_transaction::WRITE;
      addr            == local::addr;
      data.size()     == local::no_of_transfer;
      data[0][31:0]   == local::data[0];
      data[0][63:32]  == local::data[1];
      data[0][95:64]  == local::data[2];
      data[0][127:96] == local::data[3];
      data[1][31:0]   == local::data[4];
      data[1][63:32]  == local::data[5];
      data[1][95:64]  == local::data[6];
      data[1][127:96] == local::data[7];
      data[2][31:0]   == local::data[8];
      data[2][63:32]  == local::data[9];
      data[2][95:64]  == local::data[10];
      data[2][127:96] == local::data[11];
      data[3][31:0]   == local::data[12];
      data[3][63:32]  == local::data[13];
      data[3][95:64]  == local::data[14];
      data[3][127:96] == local::data[15];
      data[4][31:0]   == local::data[16];
      data[4][63:32]  == local::data[17];
      data[4][95:64]  == local::data[18];
      data[4][127:96] == local::data[19];
      burst_length    == local::burst_length;
      burst_size      == 'h4;
      burst_type      == local::burst_type;
      wstrb[0]        == local::wstrb;
      wvalid_delay[0] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[1]        == local::wstrb;
      wvalid_delay[1] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[2]        == local::wstrb;
      wvalid_delay[2] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[3]        == local::wstrb;
      wvalid_delay[3] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[4]        == local::wstrb;
      wvalid_delay[4] == 0; //to make wvalid and awvalid assert at the same time from VIP
    })
      end
    else if(no_of_transfer=='h6)
      begin
    `svt_xvm_do_with(req, {
      xact_type       == svt_axi_transaction::WRITE;
      addr            == local::addr;
      data.size()     == local::no_of_transfer;
      data[0][31:0]   == local::data[0];
      data[0][63:32]  == local::data[1];
      data[0][95:64]  == local::data[2];
      data[0][127:96] == local::data[3];
      data[1][31:0]   == local::data[4];
      data[1][63:32]  == local::data[5];
      data[1][95:64]  == local::data[6];
      data[1][127:96] == local::data[7];
      data[2][31:0]   == local::data[8];
      data[2][63:32]  == local::data[9];
      data[2][95:64]  == local::data[10];
      data[2][127:96] == local::data[11];
      data[3][31:0]   == local::data[12];
      data[3][63:32]  == local::data[13];
      data[3][95:64]  == local::data[14];
      data[3][127:96] == local::data[15];
      data[4][31:0]   == local::data[16];
      data[4][63:32]  == local::data[17];
      data[4][95:64]  == local::data[18];
      data[4][127:96] == local::data[19];
      data[5][31:0]   == local::data[20];
      data[5][63:32]  == local::data[21];
      data[5][95:64]  == local::data[22];
      data[5][127:96] == local::data[23];
      burst_length    == local::burst_length;
      burst_size      == 'h4;
      burst_type      == local::burst_type;
      wstrb[0]        == local::wstrb;
      wvalid_delay[0] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[1]        == local::wstrb;
      wvalid_delay[1] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[2]        == local::wstrb;
      wvalid_delay[2] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[3]        == local::wstrb;
      wvalid_delay[3] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[4]        == local::wstrb;
      wvalid_delay[4] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[5]        == local::wstrb;
      wvalid_delay[5] == 0; //to make wvalid and awvalid assert at the same time from VIP
    })
      end
    else if(no_of_transfer=='h7)
      begin
    `svt_xvm_do_with(req, {
      xact_type       == svt_axi_transaction::WRITE;
      addr            == local::addr;
      data.size()     == local::no_of_transfer;
      data[0][31:0]   == local::data[0];
      data[0][63:32]  == local::data[1];
      data[0][95:64]  == local::data[2];
      data[0][127:96] == local::data[3];
      data[1][31:0]   == local::data[4];
      data[1][63:32]  == local::data[5];
      data[1][95:64]  == local::data[6];
      data[1][127:96] == local::data[7];
      data[2][31:0]   == local::data[8];
      data[2][63:32]  == local::data[9];
      data[2][95:64]  == local::data[10];
      data[2][127:96] == local::data[11];
      data[3][31:0]   == local::data[12];
      data[3][63:32]  == local::data[13];
      data[3][95:64]  == local::data[14];
      data[3][127:96] == local::data[15];
      data[4][31:0]   == local::data[16];
      data[4][63:32]  == local::data[17];
      data[4][95:64]  == local::data[18];
      data[4][127:96] == local::data[19];
      data[5][31:0]   == local::data[20];
      data[5][63:32]  == local::data[21];
      data[5][95:64]  == local::data[22];
      data[5][127:96] == local::data[23];
      data[6][31:0]   == local::data[24];
      data[6][63:32]  == local::data[25];
      data[6][95:64]  == local::data[26];
      data[6][127:96] == local::data[27];
      burst_length    == local::burst_length;
      burst_size      == 'h4;
      burst_type      == local::burst_type;
      wstrb[0]        == local::wstrb;
      wvalid_delay[0] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[1]        == local::wstrb;
      wvalid_delay[1] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[2]        == local::wstrb;
      wvalid_delay[2] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[3]        == local::wstrb;
      wvalid_delay[3] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[4]        == local::wstrb;
      wvalid_delay[4] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[5]        == local::wstrb;
      wvalid_delay[5] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[6]        == local::wstrb;
      wvalid_delay[6] == 0; //to make wvalid and awvalid assert at the same time from VIP
    })
      end
    else if(no_of_transfer=='h8)
      begin
    `svt_xvm_do_with(req, {
      xact_type       == svt_axi_transaction::WRITE;
      addr            == local::addr;
      data.size()     == local::no_of_transfer;
      data[0][31:0]   == local::data[0];
      data[0][63:32]  == local::data[1];
      data[0][95:64]  == local::data[2];
      data[0][127:96] == local::data[3];
      data[1][31:0]   == local::data[4];
      data[1][63:32]  == local::data[5];
      data[1][95:64]  == local::data[6];
      data[1][127:96] == local::data[7];
      data[2][31:0]   == local::data[8];
      data[2][63:32]  == local::data[9];
      data[2][95:64]  == local::data[10];
      data[2][127:96] == local::data[11];
      data[3][31:0]   == local::data[12];
      data[3][63:32]  == local::data[13];
      data[3][95:64]  == local::data[14];
      data[3][127:96] == local::data[15];
      data[4][31:0]   == local::data[16];
      data[4][63:32]  == local::data[17];
      data[4][95:64]  == local::data[18];
      data[4][127:96] == local::data[19];
      data[5][31:0]   == local::data[20];
      data[5][63:32]  == local::data[21];
      data[5][95:64]  == local::data[22];
      data[5][127:96] == local::data[23];
      data[6][31:0]   == local::data[24];
      data[6][63:32]  == local::data[25];
      data[6][95:64]  == local::data[26];
      data[6][127:96] == local::data[27];
      data[7][31:0]   == local::data[28];
      data[7][63:32]  == local::data[29];
      data[7][95:64]  == local::data[30];
      data[7][127:96] == local::data[31];
      burst_length    == local::burst_length;
      burst_size      == 'h4;
      burst_type      == local::burst_type;
      wstrb[0]        == local::wstrb;
      wvalid_delay[0] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[1]        == local::wstrb;
      wvalid_delay[1] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[2]        == local::wstrb;
      wvalid_delay[2] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[3]        == local::wstrb;
      wvalid_delay[3] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[4]        == local::wstrb;
      wvalid_delay[4] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[5]        == local::wstrb;
      wvalid_delay[5] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[6]        == local::wstrb;
      wvalid_delay[6] == 0; //to make wvalid and awvalid assert at the same time from VIP
      wstrb[7]        == local::wstrb;
      wvalid_delay[7] == 0; //to make wvalid and awvalid assert at the same time from VIP
    })
      end
  
    get_response(rsp);
  endtask: body

  virtual function bit is_applicable(svt_configuration cfg);
    return 1;
  endfunction : is_applicable
endclass: sysrp_h2f_write128_sequence


