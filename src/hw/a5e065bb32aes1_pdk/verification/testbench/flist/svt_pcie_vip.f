#=========================================
# PCIE related DEFINES
#=========================================
+define+SYNOPSYS_SV 
+define+UVM_DISABLE_AUTO_ITEM_RECORDING
+define+UVM_NO_DEPRECATED
+define+UVM_PACKER_MAX_BYTES=1500000
+define+SVT_PCIE_ENABLE_GEN4 -debug_acc -timescale=1ns/1fs
+define+GEN4 +libext+.v+.sv
+define+UVM_VERDI_NO_COMPWAVE -debug_acc 
+define+SVT_UVM_TECHNOLOGY 

#========================================
# ADD Synopsys PCIE VIP related dirs
#========================================
+incdir+$SVT_PCIE_VIP/src/verilog/vcs
+incdir+$SVT_PCIE_VIP/src/sverilog/vcs
+incdir+$VCS_HOME/etc/uvm-1.2/vcs

-y $SVT_PCIE_VIP/src/verilog/vcs
-y $SVT_PCIE_VIP/src/sverilog/vcs

#======
# Files
#======
$VCS_HOME/etc/uvm-1.2/uvm_pkg.sv
$VCS_HOME/etc/uvm-1.2/vcs/uvm_custom_install_vcs_recorder.sv

$SVT_PCIE_VIP/include/sverilog/svt.uvm.pkg
$SVT_PCIE_VIP/include/sverilog/svt_pcie.uvm.pkg
