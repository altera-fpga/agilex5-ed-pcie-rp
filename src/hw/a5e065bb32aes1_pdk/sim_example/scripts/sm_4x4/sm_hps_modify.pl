#************************************************************************************************
# Copyright (C) 2025 - 2025 Altera Corporation
#
# This code and the related documents are Altera copyrighted materials and your use 
# of them is governed by the express license under which they were provided to you ("License"). 
# This code and the related documents are provided as is, with no express or implied 
# warranties other than those that are expressly stated in the License.
#************************************************************************************************

# Example Usage: perl sm_hps_modify.pl qsys_top.v qsys_top_mod.v

# SM_RP_SIM_ENABLE macro to be defined for simulation
# HPS_ENABLE macro to be defined during synthesis


my $in_file  = $ARGV[0];
my $out_file = $ARGV[1];

open( my $read_fh, "<", $in_file ) || die "Can't open $in_file\n";
open( my $write_fh, ">", $out_file ) || die "Can't open $out_file\n";


my $comment_flag = 0;
while(<$read_fh>)
{
  # -----------------------------------------------------------------------
  # QSYS_TOP: Add SM_RP_SIM_ENABLE macro for exported interfaces
  # -----------------------------------------------------------------------
  if($_ =~ m/module qsys_top \(/)
   {
      print $write_fh "$_";
      print $write_fh "        `ifdef SM_RP_SIM_ENABLE\n";
      # cache_coherency_translator interface
	  print $write_fh "        // cache_coherency_translator interface\n";            
	  print $write_fh "        output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_wuser,\n";            
	  print $write_fh "        output wire   [10:0] altera_ace5lite_cache_coherency_translator_0_m0_awstashnid,\n";       
	  print $write_fh "        output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arsnoop,\n";          
	  print $write_fh "        output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awsnoop,\n";          
	  print $write_fh "        output wire   [31:0] altera_ace5lite_cache_coherency_translator_0_m0_wstrb,\n";            
	  print $write_fh "        input  wire          altera_ace5lite_cache_coherency_translator_0_m0_wready,\n";           
	  print $write_fh "        input  wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_rid,\n";              
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_rready,\n";           
	  print $write_fh "        output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_awlen,\n";            
	  print $write_fh "        output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awqos,\n";            
	  print $write_fh "        output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arcache,\n";          
	  print $write_fh "        output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_arprot,\n";           
	  print $write_fh "        output wire  [255:0] altera_ace5lite_cache_coherency_translator_0_m0_wdata,\n";            
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_arvalid,\n";          
	  print $write_fh "        output wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_arid,\n";             
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_arlock,\n";           
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_awlock,\n";           
	  print $write_fh "        input wire    [1:0]  altera_ace5lite_cache_coherency_translator_0_m0_bresp,\n";             
	  print $write_fh "        input wire           altera_ace5lite_cache_coherency_translator_0_m0_arready,\n";           
	  print $write_fh "        output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_arsize,\n";           
	  print $write_fh "        output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_awdomain,\n";         
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_bready,\n";           
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_wlast,\n";            
	  print $write_fh "        output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awregion,\n";         
	  print $write_fh "        input wire    [7:0]  altera_ace5lite_cache_coherency_translator_0_m0_buser,\n";             
	  print $write_fh "        input wire    [1:0]  altera_ace5lite_cache_coherency_translator_0_m0_rresp,\n";             
	  print $write_fh "        input wire           altera_ace5lite_cache_coherency_translator_0_m0_bvalid,\n";            
	  print $write_fh "        input wire    [7:0]  altera_ace5lite_cache_coherency_translator_0_m0_ruser,\n";             
	  print $write_fh "        output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_awburst,\n";          
	  print $write_fh "        output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arregion,\n";         
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_awstashlpiden,\n";    
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_awstashniden,\n";     
	  print $write_fh "        output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_arlen,\n";            
	  print $write_fh "        output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arqos,\n";            
	  print $write_fh "        output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_awuser,\n";           
	  print $write_fh "        output wire    [5:0] altera_ace5lite_cache_coherency_translator_0_m0_awatop,\n";           
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_wvalid,\n";           
	  print $write_fh "        output wire   [35:0] altera_ace5lite_cache_coherency_translator_0_m0_araddr,\n";           
	  print $write_fh "        output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_awprot,\n";           
	  print $write_fh "        output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awcache,\n";          
	  print $write_fh "        output wire   [35:0] altera_ace5lite_cache_coherency_translator_0_m0_awaddr,\n";           
	  print $write_fh "        output wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_awstashlpid,\n";      
	  print $write_fh "        input wire  [255:0]  altera_ace5lite_cache_coherency_translator_0_m0_rdata,\n";             
	  print $write_fh "        input wire           altera_ace5lite_cache_coherency_translator_0_m0_awready,\n";           
	  print $write_fh "        output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_arburst,\n";          
	  print $write_fh "        input wire           altera_ace5lite_cache_coherency_translator_0_m0_rlast,\n";             
	  print $write_fh "        output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_ardomain,\n";         
	  print $write_fh "        output wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_awid,\n";             
	  print $write_fh "        input wire    [4:0]  altera_ace5lite_cache_coherency_translator_0_m0_bid,\n";               
	  print $write_fh "        output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_awsize,\n";           
	  print $write_fh "        output wire          altera_ace5lite_cache_coherency_translator_0_m0_awvalid,\n";          
	  print $write_fh "        input wire           altera_ace5lite_cache_coherency_translator_0_m0_rvalid,\n";            
	  print $write_fh "        output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_aruser,\n";           
      print $write_fh "\n";

      # hps2fpga interface
	  print $write_fh "        //  hps2fpga interface\n";
	  print $write_fh "        input wire    [1:0]  subsys_hps_hps2fpga_awburst,\n";
	  print $write_fh "        input wire    [7:0]  subsys_hps_hps2fpga_arlen,\n";  
	  print $write_fh "        input wire   [15:0]  subsys_hps_hps2fpga_wstrb,\n";  
	  print $write_fh "        output wire          subsys_hps_hps2fpga_wready,\n";
	  print $write_fh "        output wire    [3:0] subsys_hps_hps2fpga_rid,\n";   
	  print $write_fh "        input wire           subsys_hps_hps2fpga_rready,\n"; 
	  print $write_fh "        input wire    [7:0]  subsys_hps_hps2fpga_awlen,\n";  
	  print $write_fh "        input wire    [3:0]  subsys_hps_hps2fpga_arcache,\n";
	  print $write_fh "        input wire           subsys_hps_hps2fpga_wvalid,\n"; 
	  print $write_fh "        input wire   [37:0]  subsys_hps_hps2fpga_araddr,\n"; 
	  print $write_fh "        input wire    [2:0]  subsys_hps_hps2fpga_arprot,\n"; 
	  print $write_fh "        input wire    [2:0]  subsys_hps_hps2fpga_awprot,\n"; 
	  print $write_fh "        input wire  [127:0]  subsys_hps_hps2fpga_wdata,\n";  
	  print $write_fh "        input wire           subsys_hps_hps2fpga_arvalid,\n";
	  print $write_fh "        input wire    [3:0]  subsys_hps_hps2fpga_awcache,\n";
	  print $write_fh "        input wire    [3:0]  subsys_hps_hps2fpga_arid,\n";   
	  print $write_fh "        input wire           subsys_hps_hps2fpga_arlock,\n"; 
	  print $write_fh "        input wire           subsys_hps_hps2fpga_awlock,\n"; 
	  print $write_fh "        input wire   [37:0]  subsys_hps_hps2fpga_awaddr,\n"; 
	  print $write_fh "        output wire    [1:0] subsys_hps_hps2fpga_bresp,\n"; 
	  print $write_fh "        output wire          subsys_hps_hps2fpga_arready,\n";
	  print $write_fh "        output wire  [127:0] subsys_hps_hps2fpga_rdata,\n"; 
	  print $write_fh "        output wire          subsys_hps_hps2fpga_awready,\n";
	  print $write_fh "        input wire    [1:0]  subsys_hps_hps2fpga_arburst,\n";
	  print $write_fh "        input wire    [2:0]  subsys_hps_hps2fpga_arsize,\n"; 
	  print $write_fh "        input wire           subsys_hps_hps2fpga_bready,\n"; 
	  print $write_fh "        output wire          subsys_hps_hps2fpga_rlast,\n"; 
	  print $write_fh "        input wire           subsys_hps_hps2fpga_wlast,\n";  
	  print $write_fh "        output wire    [1:0] subsys_hps_hps2fpga_rresp,\n"; 
	  print $write_fh "        input wire    [3:0]  subsys_hps_hps2fpga_awid,\n";   
	  print $write_fh "        output wire    [3:0] subsys_hps_hps2fpga_bid,\n";   
	  print $write_fh "        output wire          subsys_hps_hps2fpga_bvalid,\n";
	  print $write_fh "        input wire    [2:0]  subsys_hps_hps2fpga_awsize,\n"; 
	  print $write_fh "        input wire           subsys_hps_hps2fpga_awvalid,\n";
	  print $write_fh "        output wire          subsys_hps_hps2fpga_rvalid,\n";
	  print $write_fh "\n";  

      # lwhps2fpga interface
	  print $write_fh "        // lwhps2fpga interface\n";  
	  print $write_fh "        input wire    [1:0]  subsys_hps_lwhps2fpga_awburst,\n";  
	  print $write_fh "        input wire    [7:0]  subsys_hps_lwhps2fpga_arlen,\n";    
	  print $write_fh "        input wire    [3:0]  subsys_hps_lwhps2fpga_wstrb,\n";    
	  print $write_fh "        output wire          subsys_hps_lwhps2fpga_wready,\n";  
	  print $write_fh "        output wire    [3:0] subsys_hps_lwhps2fpga_rid,\n";     
	  print $write_fh "        input wire           subsys_hps_lwhps2fpga_rready,\n";   
	  print $write_fh "        input wire    [7:0]  subsys_hps_lwhps2fpga_awlen,\n";    
	  print $write_fh "        input wire    [3:0]  subsys_hps_lwhps2fpga_arcache,\n";  
	  print $write_fh "        input wire           subsys_hps_lwhps2fpga_wvalid,\n";   
	  print $write_fh "        input wire   [28:0]  subsys_hps_lwhps2fpga_araddr,\n";   
	  print $write_fh "        input wire    [2:0]  subsys_hps_lwhps2fpga_arprot,\n";   
	  print $write_fh "        input wire    [2:0]  subsys_hps_lwhps2fpga_awprot,\n";   
	  print $write_fh "        input wire   [31:0]  subsys_hps_lwhps2fpga_wdata,\n";    
	  print $write_fh "        input wire           subsys_hps_lwhps2fpga_arvalid,\n";  
	  print $write_fh "        input wire    [3:0]  subsys_hps_lwhps2fpga_awcache,\n";  
	  print $write_fh "        input wire    [3:0]  subsys_hps_lwhps2fpga_arid,\n";     
	  print $write_fh "        input wire           subsys_hps_lwhps2fpga_arlock,\n";   
	  print $write_fh "        input wire           subsys_hps_lwhps2fpga_awlock,\n";   
	  print $write_fh "        input wire   [28:0]  subsys_hps_lwhps2fpga_awaddr,\n";   
	  print $write_fh "        output wire    [1:0] subsys_hps_lwhps2fpga_bresp,\n";   
	  print $write_fh "        output wire          subsys_hps_lwhps2fpga_arready,\n"; 
	  print $write_fh "        output wire   [31:0] subsys_hps_lwhps2fpga_rdata,\n";   
	  print $write_fh "        output wire          subsys_hps_lwhps2fpga_awready,\n"; 
	  print $write_fh "        input wire    [1:0]  subsys_hps_lwhps2fpga_arburst,\n";  
	  print $write_fh "        input wire    [2:0]  subsys_hps_lwhps2fpga_arsize,\n";   
	  print $write_fh "        input wire           subsys_hps_lwhps2fpga_bready,\n";   
	  print $write_fh "        output wire          subsys_hps_lwhps2fpga_rlast,\n";   
	  print $write_fh "        input wire           subsys_hps_lwhps2fpga_wlast,\n";    
	  print $write_fh "        output wire    [1:0] subsys_hps_lwhps2fpga_rresp,\n";   
	  print $write_fh "        input wire    [3:0]  subsys_hps_lwhps2fpga_awid,\n";     
	  print $write_fh "        output wire    [3:0] subsys_hps_lwhps2fpga_bid,\n";     
	  print $write_fh "        output wire          subsys_hps_lwhps2fpga_bvalid,\n";  
	  print $write_fh "        input wire    [2:0]  subsys_hps_lwhps2fpga_awsize,\n";   
	  print $write_fh "        input wire           subsys_hps_lwhps2fpga_awvalid,\n";  
	  print $write_fh "        output wire          subsys_hps_lwhps2fpga_rvalid,\n";  
	  print $write_fh "\n";  

      # subsys_hps_f2h_irq0 interface
	  print $write_fh "        // subsys_hps_f2h_irq0 interface\n";  
 	  print $write_fh "        // output wire    [31:0]  subsys_hps_f2h_irq0_in_irq,\n";  

      print $write_fh "        `endif\n\n"
   }

  # -----------------------------------------------------------------------
  # QSYS_TOP_WRAPPER: Add SM_RP_SIM_ENABLE macro for exported interfaces
  # -----------------------------------------------------------------------
   elsif($_ =~ m/module qsys_top_wrapper \(/)
   {
      print $write_fh "$_";
      print $write_fh "`ifdef SM_RP_SIM_ENABLE\n";
      # cache_coherency_translator interface
	  print $write_fh "// cache_coherency_translator interface\n";            
	  print $write_fh "output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_wuser,\n";            
	  print $write_fh "output wire   [10:0] altera_ace5lite_cache_coherency_translator_0_m0_awstashnid,\n";       
	  print $write_fh "output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arsnoop,\n";          
	  print $write_fh "output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awsnoop,\n";          
	  print $write_fh "output wire   [31:0] altera_ace5lite_cache_coherency_translator_0_m0_wstrb,\n";            
	  print $write_fh "input  wire          altera_ace5lite_cache_coherency_translator_0_m0_wready,\n";           
	  print $write_fh "input  wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_rid,\n";              
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_rready,\n";           
	  print $write_fh "output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_awlen,\n";            
	  print $write_fh "output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awqos,\n";            
	  print $write_fh "output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arcache,\n";          
	  print $write_fh "output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_arprot,\n";           
	  print $write_fh "output wire  [255:0] altera_ace5lite_cache_coherency_translator_0_m0_wdata,\n";            
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_arvalid,\n";          
	  print $write_fh "output wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_arid,\n";             
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_arlock,\n";           
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_awlock,\n";           
	  print $write_fh "input wire    [1:0]  altera_ace5lite_cache_coherency_translator_0_m0_bresp,\n";             
	  print $write_fh "input wire           altera_ace5lite_cache_coherency_translator_0_m0_arready,\n";           
	  print $write_fh "output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_arsize,\n";           
	  print $write_fh "output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_awdomain,\n";         
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_bready,\n";           
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_wlast,\n";            
	  print $write_fh "output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awregion,\n";         
	  print $write_fh "input wire    [7:0]  altera_ace5lite_cache_coherency_translator_0_m0_buser,\n";             
	  print $write_fh "input wire    [1:0]  altera_ace5lite_cache_coherency_translator_0_m0_rresp,\n";             
	  print $write_fh "input wire           altera_ace5lite_cache_coherency_translator_0_m0_bvalid,\n";            
	  print $write_fh "input wire    [7:0]  altera_ace5lite_cache_coherency_translator_0_m0_ruser,\n";             
	  print $write_fh "output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_awburst,\n";          
	  print $write_fh "output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arregion,\n";         
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_awstashlpiden,\n";    
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_awstashniden,\n";     
	  print $write_fh "output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_arlen,\n";            
	  print $write_fh "output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_arqos,\n";            
	  print $write_fh "output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_awuser,\n";           
	  print $write_fh "output wire    [5:0] altera_ace5lite_cache_coherency_translator_0_m0_awatop,\n";           
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_wvalid,\n";           
	  print $write_fh "output wire   [31:0] altera_ace5lite_cache_coherency_translator_0_m0_araddr,\n";           
	  print $write_fh "output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_awprot,\n";           
	  print $write_fh "output wire    [3:0] altera_ace5lite_cache_coherency_translator_0_m0_awcache,\n";          
	  print $write_fh "output wire   [31:0] altera_ace5lite_cache_coherency_translator_0_m0_awaddr,\n";           
	  print $write_fh "output wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_awstashlpid,\n";      
	  print $write_fh "input wire  [255:0]  altera_ace5lite_cache_coherency_translator_0_m0_rdata,\n";             
	  print $write_fh "input wire           altera_ace5lite_cache_coherency_translator_0_m0_awready,\n";           
	  print $write_fh "output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_arburst,\n";          
	  print $write_fh "input wire           altera_ace5lite_cache_coherency_translator_0_m0_rlast,\n";             
	  print $write_fh "output wire    [1:0] altera_ace5lite_cache_coherency_translator_0_m0_ardomain,\n";         
	  print $write_fh "output wire    [4:0] altera_ace5lite_cache_coherency_translator_0_m0_awid,\n";             
	  print $write_fh "input wire    [4:0]  altera_ace5lite_cache_coherency_translator_0_m0_bid,\n";               
	  print $write_fh "output wire    [2:0] altera_ace5lite_cache_coherency_translator_0_m0_awsize,\n";           
	  print $write_fh "output wire          altera_ace5lite_cache_coherency_translator_0_m0_awvalid,\n";          
	  print $write_fh "input wire           altera_ace5lite_cache_coherency_translator_0_m0_rvalid,\n";            
	  print $write_fh "output wire    [7:0] altera_ace5lite_cache_coherency_translator_0_m0_aruser,\n";           
      print $write_fh "\n";

      # hps2fpga interface
	  print $write_fh "//  hps2fpga interface\n";
	  print $write_fh "input wire    [1:0]  subsys_hps_hps2fpga_awburst,\n";
	  print $write_fh "input wire    [7:0]  subsys_hps_hps2fpga_arlen,\n";  
	  print $write_fh "input wire   [15:0]  subsys_hps_hps2fpga_wstrb,\n";  
	  print $write_fh "output wire          subsys_hps_hps2fpga_wready,\n";
	  print $write_fh "output wire    [3:0] subsys_hps_hps2fpga_rid,\n";   
	  print $write_fh "input wire           subsys_hps_hps2fpga_rready,\n"; 
	  print $write_fh "input wire    [7:0]  subsys_hps_hps2fpga_awlen,\n";  
	  print $write_fh "input wire    [3:0]  subsys_hps_hps2fpga_arcache,\n";
	  print $write_fh "input wire           subsys_hps_hps2fpga_wvalid,\n"; 
	  print $write_fh "input wire   [37:0]  subsys_hps_hps2fpga_araddr,\n"; 
	  print $write_fh "input wire    [2:0]  subsys_hps_hps2fpga_arprot,\n"; 
	  print $write_fh "input wire    [2:0]  subsys_hps_hps2fpga_awprot,\n"; 
	  print $write_fh "input wire  [127:0]  subsys_hps_hps2fpga_wdata,\n";  
	  print $write_fh "input wire           subsys_hps_hps2fpga_arvalid,\n";
	  print $write_fh "input wire    [3:0]  subsys_hps_hps2fpga_awcache,\n";
	  print $write_fh "input wire    [3:0]  subsys_hps_hps2fpga_arid,\n";   
	  print $write_fh "input wire           subsys_hps_hps2fpga_arlock,\n"; 
	  print $write_fh "input wire           subsys_hps_hps2fpga_awlock,\n"; 
	  print $write_fh "input wire   [37:0]  subsys_hps_hps2fpga_awaddr,\n"; 
	  print $write_fh "output wire    [1:0] subsys_hps_hps2fpga_bresp,\n"; 
	  print $write_fh "output wire          subsys_hps_hps2fpga_arready,\n";
	  print $write_fh "output wire  [127:0] subsys_hps_hps2fpga_rdata,\n"; 
	  print $write_fh "output wire          subsys_hps_hps2fpga_awready,\n";
	  print $write_fh "input wire    [1:0]  subsys_hps_hps2fpga_arburst,\n";
	  print $write_fh "input wire    [2:0]  subsys_hps_hps2fpga_arsize,\n"; 
	  print $write_fh "input wire           subsys_hps_hps2fpga_bready,\n"; 
	  print $write_fh "output wire          subsys_hps_hps2fpga_rlast,\n"; 
	  print $write_fh "input wire           subsys_hps_hps2fpga_wlast,\n";  
	  print $write_fh "output wire    [1:0] subsys_hps_hps2fpga_rresp,\n"; 
	  print $write_fh "input wire    [3:0]  subsys_hps_hps2fpga_awid,\n";   
	  print $write_fh "output wire    [3:0] subsys_hps_hps2fpga_bid,\n";   
	  print $write_fh "output wire          subsys_hps_hps2fpga_bvalid,\n";
	  print $write_fh "input wire    [2:0]  subsys_hps_hps2fpga_awsize,\n"; 
	  print $write_fh "input wire           subsys_hps_hps2fpga_awvalid,\n";
	  print $write_fh "output wire          subsys_hps_hps2fpga_rvalid,\n";
	  print $write_fh "\n";  

      # lwhps2fpga interface
	  print $write_fh "// lwhps2fpga interface\n";  
	  print $write_fh "input wire    [1:0]  subsys_hps_lwhps2fpga_awburst,\n";  
	  print $write_fh "input wire    [7:0]  subsys_hps_lwhps2fpga_arlen,\n";    
	  print $write_fh "input wire    [3:0]  subsys_hps_lwhps2fpga_wstrb,\n";    
	  print $write_fh "output wire          subsys_hps_lwhps2fpga_wready,\n";  
	  print $write_fh "output wire    [3:0] subsys_hps_lwhps2fpga_rid,\n";     
	  print $write_fh "input wire           subsys_hps_lwhps2fpga_rready,\n";   
	  print $write_fh "input wire    [7:0]  subsys_hps_lwhps2fpga_awlen,\n";    
	  print $write_fh "input wire    [3:0]  subsys_hps_lwhps2fpga_arcache,\n";  
	  print $write_fh "input wire           subsys_hps_lwhps2fpga_wvalid,\n";   
	  print $write_fh "input wire   [28:0]  subsys_hps_lwhps2fpga_araddr,\n";   
	  print $write_fh "input wire    [2:0]  subsys_hps_lwhps2fpga_arprot,\n";   
	  print $write_fh "input wire    [2:0]  subsys_hps_lwhps2fpga_awprot,\n";   
	  print $write_fh "input wire   [31:0]  subsys_hps_lwhps2fpga_wdata,\n";    
	  print $write_fh "input wire           subsys_hps_lwhps2fpga_arvalid,\n";  
	  print $write_fh "input wire    [3:0]  subsys_hps_lwhps2fpga_awcache,\n";  
	  print $write_fh "input wire    [3:0]  subsys_hps_lwhps2fpga_arid,\n";     
	  print $write_fh "input wire           subsys_hps_lwhps2fpga_arlock,\n";   
	  print $write_fh "input wire           subsys_hps_lwhps2fpga_awlock,\n";   
	  print $write_fh "input wire   [28:0]  subsys_hps_lwhps2fpga_awaddr,\n";   
	  print $write_fh "output wire    [1:0] subsys_hps_lwhps2fpga_bresp,\n";   
	  print $write_fh "output wire          subsys_hps_lwhps2fpga_arready,\n"; 
	  print $write_fh "output wire   [31:0] subsys_hps_lwhps2fpga_rdata,\n";   
	  print $write_fh "output wire          subsys_hps_lwhps2fpga_awready,\n"; 
	  print $write_fh "input wire    [1:0]  subsys_hps_lwhps2fpga_arburst,\n";  
	  print $write_fh "input wire    [2:0]  subsys_hps_lwhps2fpga_arsize,\n";   
	  print $write_fh "input wire           subsys_hps_lwhps2fpga_bready,\n";   
	  print $write_fh "output wire          subsys_hps_lwhps2fpga_rlast,\n";   
	  print $write_fh "input wire           subsys_hps_lwhps2fpga_wlast,\n";    
	  print $write_fh "output wire    [1:0] subsys_hps_lwhps2fpga_rresp,\n";   
	  print $write_fh "input wire    [3:0]  subsys_hps_lwhps2fpga_awid,\n";     
	  print $write_fh "output wire    [3:0] subsys_hps_lwhps2fpga_bid,\n";     
	  print $write_fh "output wire          subsys_hps_lwhps2fpga_bvalid,\n";  
	  print $write_fh "input wire    [2:0]  subsys_hps_lwhps2fpga_awsize,\n";   
	  print $write_fh "input wire           subsys_hps_lwhps2fpga_awvalid,\n";  
	  print $write_fh "output wire          subsys_hps_lwhps2fpga_rvalid,\n"; 
	  print $write_fh "\n";  
      # subsys_hps_f2h_irq0 interface
	  print $write_fh "// subsys_hps_f2h_irq0 interface\n";  
	  print $write_fh "output wire    [31:0]  subsys_hps_f2h_irq0_in_irq,\n";   
      print $write_fh "`endif\n"
   }
  # -----------------------------------------------------------------------
  # Add SM_RP_SIM_ENABLE macro for wire declarations
  # -----------------------------------------------------------------------
  #elsif($_ =~ m/(wire (.*) altera_ace5lite_cache_coherency_translator_0_m0(.*))|(wire (.*) subsys_hps_hps2fpga_(.*))|(wire (.*) subsys_hps_lwhps2fpga_(.*))|(wire (.*) subsys_hps_f2h_irq0_in_irq(.*))/
  elsif($_ =~ m/(wire (.*) altera_ace5lite_cache_coherency_translator_0_m0(.*))|(wire (.*) subsys_hps_hps2fpga_(.*))|(wire (.*) subsys_hps_lwhps2fpga_(.*))/
        )
   {
      print $write_fh "    `ifdef SM_RP_SIM_ENABLE \n";
      print $write_fh "    // $_";
      print $write_fh "    `else\n";
      print $write_fh "    $_";
      print $write_fh "    `endif\n";
   }

   #elsif ($_ =~ m/altera_ace5lite_cache_coherency_translator_0 altera_ace5lite_cache_coherency_translator_0 (.*)/) 
   # {
   #   print $write_fh "    `ifdef SM_RP_SIM_ENABLE \n";
   #   print $write_fh "  assign mm_interconnect_0_subsys_hps_f2sdram_adapter_axi4_sub_arready = '0;\n";
   #   print $write_fh "  assign mm_interconnect_0_subsys_hps_f2sdram_adapter_axi4_sub_awready = '0;\n";
   #   print $write_fh "  assign mm_interconnect_0_subsys_hps_f2sdram_adapter_axi4_sub_bvalid = '0;\n";
   #   print $write_fh "  assign mm_interconnect_0_subsys_hps_f2sdram_adapter_axi4_sub_rvalid = '0;\n";
   #   print $write_fh "  assign mm_interconnect_0_subsys_hps_f2sdram_adapter_axi4_sub_wready = '0;\n";
   #   print $write_fh "    `endif\n\n";
   #   print $write_fh "    $_";
   # }


  # -----------------------------------------------------------------------
  # Add HPS_ENABLE macro for module instances
  # -----------------------------------------------------------------------
  # if($_ =~ m/agilex_hps \(|emif_calbus_0 \(|emif_hps \(|subsys_sgmii_emac1 \(/)
  elsif($_ =~ m/(hps_subsys|emif_calbus)/)
   {
      print $write_fh "    `ifndef SM_RP_SIM_ENABLE\n";
      print $write_fh "$_";
      $comment_flag = 1;
   }
  elsif(($_ =~ m/\);/) && $comment_flag==1)
   {
      print $write_fh "$_";
      print $write_fh "    `endif\n";
      $comment_flag = 0;
   }
  # -----------------------------------------------------------------------
  # Add SM_RP_SIM_ENABLE macro for module instance connections
  # -----------------------------------------------------------------------
  elsif($_ =~ m/qsys_top soc_inst \(/)
   {
      print $write_fh "$_";
      print $write_fh "`ifdef SM_RP_SIM_ENABLE\n";
      # cache_coherency_translator interface
	  print $write_fh "// cache_coherency_translator interface\n";            
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_wuser         (altera_ace5lite_cache_coherency_translator_0_m0_wuser        ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awstashnid    (altera_ace5lite_cache_coherency_translator_0_m0_awstashnid   ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arsnoop       (altera_ace5lite_cache_coherency_translator_0_m0_arsnoop      ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awsnoop       (altera_ace5lite_cache_coherency_translator_0_m0_awsnoop      ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_wstrb         (altera_ace5lite_cache_coherency_translator_0_m0_wstrb        ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_wready        (altera_ace5lite_cache_coherency_translator_0_m0_wready       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_rid           (altera_ace5lite_cache_coherency_translator_0_m0_rid          ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_rready        (altera_ace5lite_cache_coherency_translator_0_m0_rready       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awlen         (altera_ace5lite_cache_coherency_translator_0_m0_awlen        ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awqos         (altera_ace5lite_cache_coherency_translator_0_m0_awqos        ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arcache       (altera_ace5lite_cache_coherency_translator_0_m0_arcache      ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arprot        (altera_ace5lite_cache_coherency_translator_0_m0_arprot       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_wdata         (altera_ace5lite_cache_coherency_translator_0_m0_wdata        ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arvalid       (altera_ace5lite_cache_coherency_translator_0_m0_arvalid      ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arid          (altera_ace5lite_cache_coherency_translator_0_m0_arid         ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arlock        (altera_ace5lite_cache_coherency_translator_0_m0_arlock       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awlock        (altera_ace5lite_cache_coherency_translator_0_m0_awlock       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_bresp         (altera_ace5lite_cache_coherency_translator_0_m0_bresp        ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arready       (altera_ace5lite_cache_coherency_translator_0_m0_arready      ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arsize        (altera_ace5lite_cache_coherency_translator_0_m0_arsize       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awdomain      (altera_ace5lite_cache_coherency_translator_0_m0_awdomain     ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_bready        (altera_ace5lite_cache_coherency_translator_0_m0_bready       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_wlast         (altera_ace5lite_cache_coherency_translator_0_m0_wlast        ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awregion      (altera_ace5lite_cache_coherency_translator_0_m0_awregion     ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_buser         (altera_ace5lite_cache_coherency_translator_0_m0_buser        ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_rresp         (altera_ace5lite_cache_coherency_translator_0_m0_rresp        ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_bvalid        (altera_ace5lite_cache_coherency_translator_0_m0_bvalid       ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_ruser         (altera_ace5lite_cache_coherency_translator_0_m0_ruser        ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awburst       (altera_ace5lite_cache_coherency_translator_0_m0_awburst      ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arregion      (altera_ace5lite_cache_coherency_translator_0_m0_arregion     ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awstashlpiden (altera_ace5lite_cache_coherency_translator_0_m0_awstashlpiden),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awstashniden  (altera_ace5lite_cache_coherency_translator_0_m0_awstashniden ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arlen         (altera_ace5lite_cache_coherency_translator_0_m0_arlen        ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arqos         (altera_ace5lite_cache_coherency_translator_0_m0_arqos        ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awuser        (altera_ace5lite_cache_coherency_translator_0_m0_awuser       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awatop        (altera_ace5lite_cache_coherency_translator_0_m0_awatop       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_wvalid        (altera_ace5lite_cache_coherency_translator_0_m0_wvalid       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_araddr        (altera_ace5lite_cache_coherency_translator_0_m0_araddr       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awprot        (altera_ace5lite_cache_coherency_translator_0_m0_awprot       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awcache       (altera_ace5lite_cache_coherency_translator_0_m0_awcache      ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awaddr        (altera_ace5lite_cache_coherency_translator_0_m0_awaddr       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awstashlpid   (altera_ace5lite_cache_coherency_translator_0_m0_awstashlpid  ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_rdata         (altera_ace5lite_cache_coherency_translator_0_m0_rdata        ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awready       (altera_ace5lite_cache_coherency_translator_0_m0_awready      ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_arburst       (altera_ace5lite_cache_coherency_translator_0_m0_arburst      ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_rlast         (altera_ace5lite_cache_coherency_translator_0_m0_rlast        ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_ardomain      (altera_ace5lite_cache_coherency_translator_0_m0_ardomain     ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awid          (altera_ace5lite_cache_coherency_translator_0_m0_awid         ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_bid           (altera_ace5lite_cache_coherency_translator_0_m0_bid          ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awsize        (altera_ace5lite_cache_coherency_translator_0_m0_awsize       ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_awvalid       (altera_ace5lite_cache_coherency_translator_0_m0_awvalid      ),\n";    
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_rvalid        (altera_ace5lite_cache_coherency_translator_0_m0_rvalid       ),\n";     
	  print $write_fh ".altera_ace5lite_cache_coherency_translator_0_m0_aruser        (altera_ace5lite_cache_coherency_translator_0_m0_aruser       ),\n";    
      print $write_fh "\n";

      # hps2fpga interface
	  print $write_fh "//  hps2fpga interface\n";
	  print $write_fh ".subsys_hps_hps2fpga_awburst (subsys_hps_hps2fpga_awburst),\n";
	  print $write_fh ".subsys_hps_hps2fpga_arlen   (subsys_hps_hps2fpga_arlen  ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_wstrb   (subsys_hps_hps2fpga_wstrb  ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_wready  (subsys_hps_hps2fpga_wready ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_rid     (subsys_hps_hps2fpga_rid    ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_rready  (subsys_hps_hps2fpga_rready ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_awlen   (subsys_hps_hps2fpga_awlen  ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_arcache (subsys_hps_hps2fpga_arcache),\n";
	  print $write_fh ".subsys_hps_hps2fpga_wvalid  (subsys_hps_hps2fpga_wvalid ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_araddr  (subsys_hps_hps2fpga_araddr ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_arprot  (subsys_hps_hps2fpga_arprot ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_awprot  (subsys_hps_hps2fpga_awprot ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_wdata   (subsys_hps_hps2fpga_wdata  ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_arvalid (subsys_hps_hps2fpga_arvalid),\n";
	  print $write_fh ".subsys_hps_hps2fpga_awcache (subsys_hps_hps2fpga_awcache),\n";
	  print $write_fh ".subsys_hps_hps2fpga_arid    (subsys_hps_hps2fpga_arid   ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_arlock  (subsys_hps_hps2fpga_arlock ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_awlock  (subsys_hps_hps2fpga_awlock ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_awaddr  (subsys_hps_hps2fpga_awaddr ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_bresp   (subsys_hps_hps2fpga_bresp  ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_arready (subsys_hps_hps2fpga_arready),\n";
	  print $write_fh ".subsys_hps_hps2fpga_rdata   (subsys_hps_hps2fpga_rdata  ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_awready (subsys_hps_hps2fpga_awready),\n";
	  print $write_fh ".subsys_hps_hps2fpga_arburst (subsys_hps_hps2fpga_arburst),\n";
	  print $write_fh ".subsys_hps_hps2fpga_arsize  (subsys_hps_hps2fpga_arsize ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_bready  (subsys_hps_hps2fpga_bready ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_rlast   (subsys_hps_hps2fpga_rlast  ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_wlast   (subsys_hps_hps2fpga_wlast  ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_rresp   (subsys_hps_hps2fpga_rresp  ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_awid    (subsys_hps_hps2fpga_awid   ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_bid     (subsys_hps_hps2fpga_bid    ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_bvalid  (subsys_hps_hps2fpga_bvalid ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_awsize  (subsys_hps_hps2fpga_awsize ),\n";
	  print $write_fh ".subsys_hps_hps2fpga_awvalid (subsys_hps_hps2fpga_awvalid),\n";
	  print $write_fh ".subsys_hps_hps2fpga_rvalid  (subsys_hps_hps2fpga_rvalid ),\n";
	  print $write_fh "\n";  

      # lwhps2fpga interface
	  print $write_fh "// lwhps2fpga interface\n";  
	  print $write_fh ".subsys_hps_lwhps2fpga_awburst (subsys_hps_lwhps2fpga_awburst),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_arlen   (subsys_hps_lwhps2fpga_arlen  ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_wstrb   (subsys_hps_lwhps2fpga_wstrb  ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_wready  (subsys_hps_lwhps2fpga_wready ),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_rid     (subsys_hps_lwhps2fpga_rid    ),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_rready  (subsys_hps_lwhps2fpga_rready ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_awlen   (subsys_hps_lwhps2fpga_awlen  ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_arcache (subsys_hps_lwhps2fpga_arcache),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_wvalid  (subsys_hps_lwhps2fpga_wvalid ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_araddr  (subsys_hps_lwhps2fpga_araddr ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_arprot  (subsys_hps_lwhps2fpga_arprot ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_awprot  (subsys_hps_lwhps2fpga_awprot ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_wdata   (subsys_hps_lwhps2fpga_wdata  ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_arvalid (subsys_hps_lwhps2fpga_arvalid),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_awcache (subsys_hps_lwhps2fpga_awcache),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_arid    (subsys_hps_lwhps2fpga_arid   ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_arlock  (subsys_hps_lwhps2fpga_arlock ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_awlock  (subsys_hps_lwhps2fpga_awlock ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_awaddr  (subsys_hps_lwhps2fpga_awaddr ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_bresp   (subsys_hps_lwhps2fpga_bresp  ),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_arready (subsys_hps_lwhps2fpga_arready),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_rdata   (subsys_hps_lwhps2fpga_rdata  ),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_awready (subsys_hps_lwhps2fpga_awready),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_arburst (subsys_hps_lwhps2fpga_arburst),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_arsize  (subsys_hps_lwhps2fpga_arsize ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_bready  (subsys_hps_lwhps2fpga_bready ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_rlast   (subsys_hps_lwhps2fpga_rlast  ),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_wlast   (subsys_hps_lwhps2fpga_wlast  ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_rresp   (subsys_hps_lwhps2fpga_rresp  ),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_awid    (subsys_hps_lwhps2fpga_awid   ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_bid     (subsys_hps_lwhps2fpga_bid    ),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_bvalid  (subsys_hps_lwhps2fpga_bvalid ),\n";
	  print $write_fh ".subsys_hps_lwhps2fpga_awsize  (subsys_hps_lwhps2fpga_awsize ),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_awvalid (subsys_hps_lwhps2fpga_awvalid),\n"; 
	  print $write_fh ".subsys_hps_lwhps2fpga_rvalid  (subsys_hps_lwhps2fpga_rvalid ),\n";
	  print $write_fh "\n";  
	  
      print $write_fh "// lwhps2fpga interface\n";  
	  print $write_fh ".subsys_hps_f2h_irq0_in_irq  (subsys_hps_f2h_irq0_in_irq ),\n";

      print $write_fh "`endif\n"
   }
  else
  {
      print $write_fh "$_";
  } 

 
}


close read_fh;
close write_fh;
