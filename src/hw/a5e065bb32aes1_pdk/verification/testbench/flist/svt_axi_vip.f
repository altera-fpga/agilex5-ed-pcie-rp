+define+SVT_AXI_INCLUDE_USER_DEFINES 
+define+SVT_AXI_QVN_ENABLE
+define+SVT_EXCLUDE_METHODOLOGY_PKG_INCLUDE
+define+UVM_PACKER_MAX_BYTES=1500000
+define+SVT_AXI_MAX_TDATA_WIDTH=512
+define+SVT_AXI_MAX_TUSER_WIDTH=1024
+define+SVT_UVM_TECHNOLOGY
+define+UVM_DISABLE_AUTO_ITEM_RECORDING
+define+SVT_VCS_INCLUDE_USER_DEFINES
+define+SYNOPSYS_SV
+define+SVT_AXI_MAX_TID_WIDTH=32
+define+SVT_AXI_MAX_TVALID_DELAY=512
+define+SVT_AXI_MAX_STREAM_BURST_LENGTH=4092

#=================================
# ADD AMBA related dirs for AXI
#=================================
+incdir+$SYNOPSYS_VIP_AMBA/src/sverilog/vcs/
+incdir+$SYNOPSYS_VIP_AMBA/include/sverilog/
+incdir+$SYNOPSYS_VIP_AMBA/include/

//+incdir+$DESIGNWARE_HOME/vip/svt/amba_svt/latest/sverilog/include
//+incdir+$DESIGNWARE_HOME/vip/svt/amba_svt/latest/sverilog/src/vcs

#======
# Files
#======
$HOME_PATH/testbench/sysrp_user_definies.svh
$SYNOPSYS_VIP_AMBA/include/sverilog/svt_axi.uvm.pkg
$SYNOPSYS_VIP_AMBA/include/sverilog/svt_axi_if.svi
