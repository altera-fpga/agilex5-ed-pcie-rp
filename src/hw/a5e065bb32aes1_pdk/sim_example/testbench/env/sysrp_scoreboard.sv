//************************************************************************************************
// Copyright (C) 2025 - 2025 Altera Corporation
//
// This code and the related documents are Altera copyrighted materials and your use 
// of them is governed by the express license under which they were provided to you ("License"). 
// This code and the related documents are provided as is, with no express or implied 
// warranties other than those that are expressly stated in the License.
//************************************************************************************************

`uvm_analysis_imp_decl(_pcie_port_tx)
`uvm_analysis_imp_decl(_pcie_port_rx)
`uvm_analysis_imp_decl(_pcie_port_rx_from_slave)
`uvm_analysis_imp_decl(_axi_port_rx)
`uvm_analysis_imp_decl(_axi_port_tx)
`uvm_analysis_imp_decl(_axi_port_tx_from_slave)

class sysrp_scoreboard extends uvm_scoreboard;

   svt_axi_transaction axi_tx_trans,axi_tx_read_trans;
   svt_pcie_dl_tlp_monitor_transaction pcie_tx_read_trans,pcie_rx_read_trans;

   bit[31:0] pcie_payload_tx_q[$];
   bit[31:0] axi_payload_rx_q[$];
   bit[31:0] pcie_payload_rx_q[$];
   bit[31:0] axi_payload_tx_q[$];
   int       has_pcie_tx, has_axi_tx;
   bit       unaligned_enb;
   bit       error_case;
   int unsigned pcie_tx_wr_count, pcie_tx_rd_count;
   int unsigned pcie_rx_wr_count, pcie_rx_slavecpl_count;
   int unsigned axi_rx_wr_count, axi_rx_rd_count;
   int unsigned axi_tx_wr_count, axi_tx_rd_count;
   int unsigned axi_tx_slave_count; 

   svt_pcie_dl_tlp_monitor_transaction   pcie_tx_readpkt_q[$];
   svt_pcie_dl_tlp_monitor_transaction   pcie_rx_readpkt_q[$];
   svt_pcie_dl_tlp_monitor_transaction   pcie_tx_read_fifo_q[$];
   svt_pcie_dl_tlp_monitor_transaction   pcie_tx_write_fifo_q[$];

   svt_axi_transaction    axi_tx_readpkt_q[$];
   svt_axi_transaction    axi_tx_read_fifo_q[$], axi_tx_write_fifo_q[$];
   int                    dwords_sent_from_axi_master_q[$];

   `uvm_component_utils(sysrp_scoreboard)

   //port from pcie vip
   uvm_analysis_imp_pcie_port_tx#(svt_pcie_dl_tlp_monitor_transaction, sysrp_scoreboard) pcie_port_tx;
   uvm_analysis_imp_pcie_port_rx#(svt_pcie_dl_tlp_monitor_transaction, sysrp_scoreboard) pcie_port_rx;
   uvm_analysis_imp_pcie_port_rx_from_slave#(svt_pcie_dl_tlp_monitor_transaction, sysrp_scoreboard) pcie_port_rx_from_slave;
   //port from AXI4
   uvm_analysis_imp_axi_port_rx#(svt_axi_transaction, sysrp_scoreboard) axi_port_rx;
   uvm_analysis_imp_axi_port_tx#(svt_axi_transaction, sysrp_scoreboard) axi_port_tx;
   uvm_analysis_imp_axi_port_tx_from_slave#(svt_axi_transaction, sysrp_scoreboard) axi_port_tx_from_slave;

   //TLM FIFO for pcie and axi
   uvm_tlm_analysis_fifo #(svt_pcie_dl_tlp_monitor_transaction) pcie_tx_fifo;
   uvm_tlm_analysis_fifo #(svt_pcie_dl_tlp_monitor_transaction) pcie_tx_read_fifo;
   uvm_tlm_analysis_fifo #(svt_pcie_dl_tlp_monitor_transaction) pcie_rx_fifo;
   uvm_tlm_analysis_fifo #(svt_pcie_dl_tlp_monitor_transaction) pcie_rx_read_fifo;
   uvm_tlm_analysis_fifo #(svt_axi_transaction) axi_tx_fifo,axi_tx_read_fifo;
   uvm_tlm_analysis_fifo #(svt_axi_transaction) axi_rx_fifo;

    bit[4095:0] pcie_address_wdata_assoc_array[bit [63:0]];
    bit[4095:0] pcie_address_rdata_assoc_array[bit [63:0]];
    bit[4095:0] axi_address_wdata_assoc_array[bit [63:0]];
    bit[4095:0] axi_address_rdata_assoc_array[bit [63:0]];
    int check_pcie_counter=0; 
    int check_axi_counter=0; 

   ////function new
   function new(string name, uvm_component parent);
      super.new(name, parent);

      pcie_tx_wr_count = 0;
      pcie_tx_rd_count = 0;
      pcie_rx_wr_count = 0;
      pcie_rx_slavecpl_count = 0;
      axi_rx_wr_count = 0;
      axi_rx_rd_count = 0;
      axi_tx_wr_count = 0;
      axi_tx_wr_count = 0;
      axi_tx_slave_count = 0;
   endfunction : new


   ////build_phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      pcie_port_tx            = new("pcie_port_tx", this);
      pcie_port_rx            = new("pcie_port_rx", this);
      pcie_port_rx_from_slave = new("pcie_port_rx_from_slave", this);
      axi_port_rx             = new("axi_port_rx", this);
      axi_port_tx             = new("axi_port_tx", this);
      axi_port_tx_from_slave  = new("axi_port_tx_from_slave", this);
      pcie_rx_fifo            = new("pcie_rx_fifo", this);
      pcie_rx_read_fifo       = new("pcie_rx_read_fifo", this);
      pcie_tx_fifo            = new("pcie_tx_fifo", this);
      pcie_tx_read_fifo       = new("pcie_tx_read_fifo", this);
      axi_tx_fifo             = new("axi_tx_fifo", this);
      axi_tx_read_fifo        = new("axi_tx_read_fifo", this);
      axi_rx_fifo             = new("axi_rx_fifo", this);
   endfunction : build_phase


     //--------------------------------------------------------------
     // write_pcie_port_tx (Packets from Pcie-EP) 
     //--------------------------------------------------------------
     virtual function void write_pcie_port_tx(svt_pcie_dl_tlp_monitor_transaction trans);
        bit[63:0]  address_pcie_write_trans;
	int        z;
	bit[3:0]   first_last_be;
	int        payload_size;
	bit[31:0]  byte_enable_data_at_pcie, out_data_at_pcie;


        //1. Check pcie MWr
        if(trans.tlp.tlp_type == 5'h0 && ($size(trans.tlp.payload)!=0)) begin //{ 
           `uvm_info(get_type_name(),$sformatf("write_pcie_port_tx: Write Pkt transmitted by PCIe VIP \n %s",trans.sprint()),UVM_LOW)
	   pcie_tx_wr_count++;
	   `uvm_info(get_type_name(),$sformatf("write_pcie_port_tx: pcie_tx_wr_count=%0d",pcie_tx_wr_count),UVM_LOW)
           payload_size = $size(trans.tlp.payload);
           `uvm_info(get_type_name(),$sformatf("write_pcie_port_tx: PAYLOAD SIZE=%0h\n",payload_size),UVM_LOW)
	   pcie_tx_write_fifo_q.push_back(trans);

           for(int i=0;i<payload_size;i++) begin //{
              if((i==0) || (i==payload_size-1)) begin //{
                 if(i==0) first_last_be = trans.tlp.first_dw_be;
                 else  first_last_be = trans.tlp.last_dw_be;
	       
                 out_data_at_pcie = trans.tlp.payload[i];
                 z = 3;
	         for(int k=0;k<=3;k++)  begin //{
                    if(first_last_be[k] == 'b1)
                       byte_enable_data_at_pcie = {byte_enable_data_at_pcie,out_data_at_pcie[8*z +: 8]};
                    else
                       byte_enable_data_at_pcie = {byte_enable_data_at_pcie,8'h0};

                    z--;  
                 end //}
                 address_pcie_write_trans = trans.tlp.address;
                 `uvm_info(get_type_name(),$sformatf("write_pcie_port_tx: DATA sent by PCIE VIP=%0h\n",byte_enable_data_at_pcie),UVM_LOW)
                 pcie_payload_tx_q.push_back(byte_enable_data_at_pcie);
                 pcie_address_wdata_assoc_array[address_pcie_write_trans] = {pcie_address_wdata_assoc_array[address_pcie_write_trans],byte_enable_data_at_pcie};
              end //}
              else begin //{
                 address_pcie_write_trans = trans.tlp.address;
                 `uvm_info(get_type_name(),$sformatf("write_pcie_port_tx: DATA sent by PCIE VIP=%0h\n",trans.tlp.payload[i]),UVM_LOW)
                 pcie_payload_tx_q.push_back(trans.tlp.payload[i]);
                 pcie_address_wdata_assoc_array[address_pcie_write_trans] = {pcie_address_wdata_assoc_array[address_pcie_write_trans],trans.tlp.payload[i]};
              end //}
           end  //}
              `uvm_info(get_type_name(),$sformatf("write_pcie_port_tx: PCIe Address-Data Associative Array [%0h] = %0h",address_pcie_write_trans,pcie_address_wdata_assoc_array[address_pcie_write_trans]),UVM_LOW);
        end //}
	//2. Check pcie MRd
	else if(trans.tlp.tlp_type == 5'h0 && ($size(trans.tlp.payload)==0))  begin  //{
           `uvm_info(get_type_name(),$sformatf("write_pcie_port_tx: Read Pkt transmitted by PCIe VIP \n %s",trans.sprint()),UVM_LOW)
	   pcie_tx_readpkt_q.push_back(trans);
	   pcie_tx_read_fifo_q.push_back(trans);
	   pcie_tx_rd_count++;
	   `uvm_info(get_type_name(),$sformatf("write_pcie_port_tx: pcie_tx_rd_count=%0d",pcie_tx_rd_count),UVM_LOW)
      end //}

   endfunction :write_pcie_port_tx


   //-----------------------------------------------------
   // write_pcie_port_rx_from_slave 
   //-----------------------------------------------------
   virtual function void write_pcie_port_rx_from_slave(svt_pcie_dl_tlp_monitor_transaction trans);
      /* Intended to leave blank */

   endfunction :write_pcie_port_rx_from_slave


   //------------------------------------------------------------------
   // Write_pcie_port_rx (packet arrive to Pcie-EP from DUT) 
   //------------------------------------------------------------------
   virtual function void write_pcie_port_rx(svt_pcie_dl_tlp_monitor_transaction trans);
      int       dwords_sent_from_master_2;
      bit[63:0] addr_pcie_read_trans;
      bit[3:0]  l_first_last_be;
      int       j, payload_size;
      bit[9:0]  length_pcie_read_trans;
      int       dwords_received_at_pcie;
      bit[63:0] axi_tx_pkt_address;
      svt_axi_transaction    axi_tx_trans;
      bit[3:0]  axi_strobe_tx;


      pcie_rx_wr_count++;
      `uvm_info(get_type_name(),$sformatf("write_pcie_port_rx: pcie_rx_wr_count=%0d\n",pcie_rx_wr_count),UVM_LOW)

      //1. Check read transaction out to HPS-AXI interface
      if((trans.tlp.tlp_type == 5'h0) && ($size(trans.tlp.payload) == 0) && (axi_tx_readpkt_q.size() > 0))  begin  //{
	 axi_tx_read_trans = axi_tx_readpkt_q.pop_front();
	 axi_tx_pkt_address = axi_tx_read_trans.addr;
         addr_pcie_read_trans = trans.tlp.address;
         length_pcie_read_trans  = trans.tlp.length;
	 //
	 //
      end //}

      //2. Check write transaction at received at pcie
      if((trans.tlp.tlp_type == 5'h0) && ($size(trans.tlp.payload) != 0))  begin  //{
         dwords_received_at_pcie = 0;               
         payload_size = $size(trans.tlp.payload);
         `uvm_info(get_type_name(),$sformatf(" SCB:: PAYLOAD SIZE=%0h\n",payload_size),UVM_LOW)
	 
         for(int i=0;i<payload_size;i++) begin //{
            if((i==0) || (i==payload_size-1)) begin //{
	       if(i==0) l_first_last_be = trans.tlp.first_dw_be;
	       else  l_first_last_be = trans.tlp.last_dw_be;

               //Check First_BE vs. wstrb
	       if( (i == 0) && (axi_tx_write_fifo_q.size() > 0) ) begin  //{
	          axi_tx_trans = axi_tx_write_fifo_q.pop_front();
		  j = 0;
                  while(j < 8)  begin //{
                     axi_strobe_tx = axi_tx_trans.wstrb[i][4*j +: 4];
		     if(axi_strobe_tx > 0) j = 8 ;
		     else j++;
	          end //}

	          `uvm_info(get_type_name(),$sformatf("write_pcie_port_rx: Exp First_be=0x%0h, Act First_be =0x%0h", axi_strobe_tx, l_first_last_be),UVM_LOW)

	          if(l_first_last_be !==  axi_strobe_tx)
	              `uvm_error(get_type_name(), $sformatf("write_pcie_port_rx: Mismatch Exp First_be=0x%0h, Act First_be =0x%0h", axi_strobe_tx, l_first_last_be));
	       end //}

	       //
	       if(l_first_last_be != 0) begin //{
                  `uvm_info(get_type_name(),$sformatf("write_pcie_port_rx: MWr received at PCIE Endpoint VIP=%0h\n",trans.tlp.payload[i]),UVM_LOW)
                  pcie_payload_rx_q.push_back(trans.tlp.payload[i]);
                  dwords_received_at_pcie++;
	       end //}
	    end //}
	    else begin //{
              `uvm_info(get_type_name(),$sformatf("write_pcie_port_rx: MWr received at PCIE Endpoint VIP=%0h\n",trans.tlp.payload[i]),UVM_LOW)
               pcie_payload_rx_q.push_back(trans.tlp.payload[i]);
	       dwords_received_at_pcie++;
            end //}
         end  //}

         check_axi_counter++;
         `uvm_info(get_type_name(),$sformatf("QUEUE RX [Received at PCIE]     = %p",pcie_payload_rx_q),UVM_LOW);
         `uvm_info(get_type_name(),$sformatf("QUEUE TX [Transmitted from AXI] = %p",axi_payload_tx_q),UVM_LOW);
         `uvm_info(get_type_name(),$sformatf(" FOREACH COUNTER = %d \n",check_axi_counter),UVM_LOW)
	 compare_data_from_axi();
      end  //}

   endfunction :write_pcie_port_rx


   //---------------------------------------------------------------------
   // write_axi_port_rx (Packets arrived to HPS-AXI from DUT)
   //---------------------------------------------------------------------
   virtual function void write_axi_port_rx(svt_axi_transaction trans);
       svt_pcie_dl_tlp_monitor_transaction   pcie_txwrite_trans;
       bit[63:0]  l_address_pcie_read_trans, l_address_pcie_write_trans ;
       int        data_array_size, payload_size;
       bit[31:0]  out,out_BE,byte_enable_data_at_slave;
       bit[3:0]   strobe;
       bit[9:0]   length_pcie_read_trans;
       int        dwords_received;
       bit[63:0]  axi_rx_pkt_address;


      `uvm_info(get_type_name(),$sformatf(" SCB:: Pkt received by AXI Slave \n %s",trans.sprint()),UVM_LOW)
      //1. Check read transaction out to HPS-AXI interface
      if((trans.xact_type == 0) && (pcie_tx_readpkt_q.size() > 0)) begin //{
	 axi_rx_rd_count++;

         axi_rx_pkt_address = trans.addr;
	 pcie_tx_read_trans = pcie_tx_readpkt_q.pop_front();
         l_address_pcie_read_trans = pcie_tx_read_trans.tlp.address;
         length_pcie_read_trans  = pcie_tx_read_trans.tlp.length;

	 if(l_address_pcie_read_trans[63:0] !== axi_rx_pkt_address[63:0]) 
            `uvm_error(get_type_name(), $sformatf("write_axi_port_rx: Mismatch Exp address_pcie_read_trans=0x%0h, Act axi_rx_pkt_address =0x%0h", l_address_pcie_read_trans, axi_rx_pkt_address));

      end //}

      //2. Check write transaction out to HPS-AXI interface
      if(trans.xact_type == 'h1)  begin //{ 
         axi_rx_wr_count++;

         dwords_received = 0;
         data_array_size = $size(trans.data);
         axi_rx_pkt_address = trans.addr;
	 pcie_txwrite_trans = pcie_tx_write_fifo_q.pop_front();
	 l_address_pcie_write_trans = pcie_txwrite_trans.tlp.address;

	 if( (!unaligned_enb) && (l_address_pcie_write_trans[63:0] !== axi_rx_pkt_address[63:0]) ) begin
            if( (axi_rx_pkt_address[63:0] >= ('h9_FFFF_F000 -4)) && (axi_rx_pkt_address[63:0] <'h9_FFFF_FFFF) )
	        `uvm_info(get_type_name(),$sformatf("write_axi_port_rx: MSI Interrupt Addr =%0h", axi_rx_pkt_address),UVM_LOW)
             else
                `uvm_error(get_type_name(), $sformatf("write_axi_port_rx: Mismatch Exp address_pcie_write_trans=0x%0h, Act axi_rx_pkt_address =0x%0h", l_address_pcie_write_trans, axi_rx_pkt_address));
	 end

	 if( (unaligned_enb) && (l_address_pcie_write_trans[63:8] !== axi_rx_pkt_address[63:8]) )  begin
            if( (axi_rx_pkt_address[63:0] >= ('h9_FFFF_F000 -4)) && (axi_rx_pkt_address[63:0] <'h9_FFFF_FFFF) )
	        `uvm_info(get_type_name(),$sformatf("write_axi_port_rx: MSI Interrupt Addr =%0h", axi_rx_pkt_address),UVM_LOW)
             else
                `uvm_error(get_type_name(), $sformatf("write_axi_port_rx: Mismatch Exp address_pcie_write_trans=0x%0h, Act axi_rx_pkt_address =0x%0h", l_address_pcie_write_trans, axi_rx_pkt_address));
	 end

         for(int i=0;i<data_array_size;i++) begin //{
	    for(int j=0;j<16;j++) begin // {
               strobe = trans.wstrb[i][4*j +: 4];
	       if(strobe == 'hF) begin //{
                  out    = trans.data[i][32*j +: 32];
                  out_BE = {out[7:0], out[15:8], out[23:16], out[31:24]};
                  `uvm_info(get_type_name(),$sformatf("write_axi_port_rx: I=%0d J=%0d ADDR=%0h DATA received at SLAVE=%0h\n",i,j,axi_rx_pkt_address,out_BE),UVM_LOW)
                  axi_payload_rx_q.push_back(out_BE);
                  dwords_received++;
               end  //}
	       else if(strobe != 'h0) begin //{
                  out  = trans.data[i][32*j +: 32];
	 	  for(int k=0;k<=3;k++) begin  //{
                     if(strobe[k] == 'b1) 
                        byte_enable_data_at_slave = {byte_enable_data_at_slave,out[8*k +: 8]};
                     else
                        byte_enable_data_at_slave = {byte_enable_data_at_slave,8'h0};
                  end //}
                  `uvm_info(get_type_name(),$sformatf("write_axi_port_rx: I=%0d J=%0d ADDR=%0h DATA received at SLAVE=%0h\n",i,j,axi_rx_pkt_address,byte_enable_data_at_slave),UVM_LOW)
                  axi_payload_rx_q.push_back(byte_enable_data_at_slave);
                  dwords_received++;
               end //}
            end //}
         end //}
      end //}

       check_pcie_counter++;
       `uvm_info(get_type_name(),$sformatf("write_axi_port_rx: QUEUE TX [Transmitted from PCIe] = %p",pcie_payload_tx_q),UVM_LOW);
       `uvm_info(get_type_name(),$sformatf("write_axi_port_rx: QUEUE RX [Received at AXI Slave] = %p",axi_payload_rx_q),UVM_LOW);
       `uvm_info(get_type_name(),$sformatf(" FOREACH COUNTER = %d \n",check_pcie_counter),UVM_LOW)
       if( (axi_rx_pkt_address[63:0] >= ('h9_FFFF_F000 -4)) && (axi_rx_pkt_address[63:0] <'h9_FFFF_FFFF) )
          `uvm_info(get_type_name(),$sformatf("write_axi_port_rx: Not checking data for MSI Interrupt Addr =%0h", axi_rx_pkt_address),UVM_LOW)
       else compare_data_from_pcie();

   endfunction :write_axi_port_rx

   //-------------------------------------------------------
   // write_axi_port_tx (packets from HPS-AXI) 
   //-------------------------------------------------------
   virtual function void write_axi_port_tx(svt_axi_transaction trans);
      bit[63:0]  address_axi_write_trans;
      int        data_array_size, payload_size;
      bit[31:0]  out,out_BE;
      bit[3:0]   axi_strobe_tx;
      int        dwords_sent_from_master;


      //Directed towards Endpoint and a write transaction
      if((trans.addr > 'h1000_0000) && (trans.xact_type == 'h1) && ((trans.addr[31:16] !== 'h2008)))  begin //{
         `uvm_info(get_type_name(),$sformatf("write_axi_port_tx:  Write Pkt sent by AXI Master \n %s",trans.sprint()),UVM_LOW)
 	 axi_tx_wr_count++;

	 axi_tx_write_fifo_q.push_back(trans);
         dwords_sent_from_master = 0;
         data_array_size = $size(trans.data);
         if(axi_tx_wr_count == 1) axi_payload_tx_q = {};

         for(int i=0;i<data_array_size;i++) begin //{
 	    for(int j=0;j<4;j++)  begin //{
               axi_strobe_tx = trans.wstrb[i][4*j +: 4];
               address_axi_write_trans = trans.addr;

	       if(axi_strobe_tx != 'h0) begin //{
                  out  = trans.data[i][32*j +: 32];
	 	  for(int k=0;k<=3;k++) begin  //{
                     if(axi_strobe_tx[k] == 'b1) 
                        out_BE = {out_BE, out[8*k +: 8]};
                     else
                        out_BE = {out_BE,8'h0};
                  end //}
	          `uvm_info(get_type_name(),$sformatf(" SCB:: I=%0d J=%0d MWr sent by AXI MASTER towards PCIe Endpoint=%0h\n",i,j,out_BE),UVM_LOW)
                  axi_payload_tx_q.push_back(out_BE);
                  axi_address_wdata_assoc_array[address_axi_write_trans] = {axi_address_wdata_assoc_array[address_axi_write_trans],out_BE};
                  dwords_sent_from_master++;
               end //}
               `uvm_info(get_type_name(),$sformatf("AXI Address-Data Associative Array [%0h] = %0h",address_axi_write_trans,axi_address_wdata_assoc_array[address_axi_write_trans]),UVM_LOW);
	    end //}
         end //}  
         dwords_sent_from_axi_master_q.push_back(dwords_sent_from_master);
      end // }

      //Directed towards Endpoint and a read transaction
      if((trans.addr > 'h1000_0000) && (trans.xact_type == 'h0) && (trans.addr[31:16] !== 'h2008)) begin //{
         `uvm_info(get_type_name(),$sformatf(" SCB::Read Pkt sent by AXI Master \n %s",trans.sprint()),UVM_LOW)
	 axi_tx_rd_count++;
	 axi_tx_readpkt_q.push_back(trans);
	 axi_tx_read_fifo_q.push_back(trans);
      end //} 

   endfunction :write_axi_port_tx


   //----------------------------------------------------------
   // Write_axi_port_tx_from_slave(svt_axi_transaction trans);
   //----------------------------------------------------------
   virtual function void write_axi_port_tx_from_slave(svt_axi_transaction trans);
      /* Intended to leave blank */

   endfunction :write_axi_port_tx_from_slave


   //-----------------------------------------
   // compare_data_from_pcie();
   //-----------------------------------------
   function compare_data_from_pcie();
      bit [31:0]  exp_data, obs_data;     
      int         index;

      while (pcie_payload_tx_q.size()!==0 && axi_payload_rx_q.size()!==0) begin
          obs_data = axi_payload_rx_q.pop_front();
          exp_data = pcie_payload_tx_q.pop_front();
          if (exp_data == obs_data) begin
             `uvm_info(get_type_name(),$sformatf("[compare_data_from_pcie] : DATA MATCHED EXP_DATA = 'h%h: OBS_DATA = `h%h", exp_data, obs_data),UVM_LOW);
          end 
          else begin
             `uvm_error(get_type_name(), $sformatf("[compare_data_from_pcie] : DATA MISMATCHED EXP_DATA = `h%h, OBS_DATA = `h%h ",exp_data, obs_data));
          end
       end
   endfunction : compare_data_from_pcie


   //---------------------------------------
   // compare_data_from_axi();
   //---------------------------------------
   function compare_data_from_axi();
      bit [31:0]  exp_data, obs_data;     
      int         index;

      while (pcie_payload_rx_q.size()!==0 && axi_payload_tx_q.size()!==0) begin
          exp_data = axi_payload_tx_q.pop_front();
          obs_data = pcie_payload_rx_q.pop_front();
          if (exp_data == obs_data) begin
             `uvm_info(get_type_name(),$sformatf("[compare_data_from_axi] : DATA MATCHED EXP_DATA = 'h%h: OBS_DATA = `h%h", exp_data, obs_data),UVM_LOW);
          end 
          else begin
             `uvm_error(get_type_name(), $sformatf("[compare_data_from_axi] : DATA MISMATCHED EXP_DATA = `h%h, OBS_DATA = `h%h ",exp_data, obs_data));
          end
      end
   endfunction : compare_data_from_axi


   //-----------------------------------------
   // report_phase(uvm_phase phase);
   //-----------------------------------------
   function void report_phase(uvm_phase phase);

      super.report_phase(phase);

      // End of Simulation checks for any non-empty queue
      `uvm_info(get_type_name(), $sformatf("INFO: pcie_tx_wr_count=%0d, pcie_tx_rd_count=%0d", pcie_tx_wr_count, pcie_tx_rd_count), UVM_LOW)
      `uvm_info(get_type_name(), $sformatf("INFO: axi_rx_wr_count=%0d, axi_rx_rd_count=%0d", axi_rx_wr_count, axi_rx_rd_count), UVM_LOW)
      `uvm_info(get_type_name(), $sformatf("INFO: axi_tx_wr_count=%0d, axi_tx_rd_count=%0d", axi_tx_wr_count, axi_tx_rd_count), UVM_LOW)

      if(has_pcie_tx == 1) begin //{
	 if((pcie_tx_wr_count == 0) || (axi_rx_wr_count == 0))
            `uvm_error(get_type_name(),$sformatf("No EP-to-RP traffic: has_pcie_tx=%0d, pcie_tx_wr_count=%0d, axi_rx_wr_count=%0d", has_pcie_tx, pcie_tx_wr_count, axi_rx_wr_count));
      end //}

      if(has_axi_tx == 1) begin //{
	 if((axi_tx_wr_count == 0) || (pcie_rx_wr_count == 0))
            `uvm_error(get_type_name(),$sformatf("No RP-to-EP traffic: has_axi_tx=%0d, axi_tx_wr_count=%0d, pcie_rx_wr_count=%0d", has_axi_tx, axi_tx_wr_count, pcie_rx_wr_count));
      end //}

   endfunction:report_phase

endclass : sysrp_scoreboard
