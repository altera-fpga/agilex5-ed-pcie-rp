#************************************************************************************************
# Copyright (C) 2025 - 2025 Altera Corporation
#
# This code and the related documents are Altera copyrighted materials and your use 
# of them is governed by the express license under which they were provided to you ("License"). 
# This code and the related documents are provided as is, with no express or implied 
# warranties other than those that are expressly stated in the License.
#************************************************************************************************

export WORKDIR=$(RP_ROOTDIR)/sim_example
export SVT_PCIE_VIP=/p/psg/EIP/synopsys/vip/vg_Q-2020.03A/vip/svt/pcie_svt/Q-2020.12/design_dir
export SYNOPSYS_VIP_AMBA=/p/psg/EIP/synopsys/vip/vg_Q-2020.03A
SCRIPTS_DIR = $(WORKDIR)/scripts/g4x4
QUARTUS_INSTALL_DIR = $(QUARTUS_HOME)
VIPDIR = $(SYNOPSYS_VIP_AMBA)
VCDFILE = $(SCRIPTS_DIR)/vpd_dump.key

VLOG_OPT = -kdb -ntb_opts uvm-1.2 -sverilog -full64 +vcs+lic+wait -l $(WORKDIR)/run_sim/sim4x4/vlog.log -Mdir=$(WORKDIR)/run_sim/sim4x4/output/csrc +warn=noBCNACMBP -CFLAGS +error+100 +define+UVM_DISABLE_AUTO_ITEM_RECORDING +define+UVM_NO_DEPRECATED +define+UVM_PACKER_MAX_BYTES=1500000 +define+SVT_PCIE_ENABLE_GEN4 -debug_acc -timescale=1ns/1fs +libext+.v+.sv +define+UVM_VERDI_NO_COMPWAVE -debug_acc +define+SVT_UVM_TECHNOLOGY +define+SYNOPSYS_SV -work work +incdir+./ 

VLOG_OPT += +incdir+$(SVT_PCIE_VIP)/src/sverilog/vcs +incdir+$(SVT_PCIE_VIP)/include/sverilog +incdir+$(SVT_PCIE_VIP)/src/verilog/vcs +incdir+$(SVT_PCIE_VIP)/include/verilog -y $(SVT_PCIE_VIP)/src/verilog/vcs -y $(SVT_PCIE_VIP)/src/sverilog/vcs +incdir+$(WORKDIR)/testbench +incdir+$(WORKDIR)/testbench/env +incdir+$(WORKDIR)/testbench/axi_env/ +incdir+$(WORKDIR)/tests/ +incdir+$(WORKDIR)/tests/sequences/ +incdir+/p/psg/eda/synopsys/vcsmx/V-2023.12-SP2-1/linux64/suse/etc/uvm-1.2/vcs +incdir+$(VIPDIR)/include/sverilog/ +incdir+$(VIPDIR)/src/sverilog/vcs +incdir+/p/psg/EIP/synopsys/vip_common/vip_Q-2020.03A/vip/svt/amba_svt/Q-2020.03/sverilog/src/vcs/ $(VIPDIR)/include/sverilog/svt_axi_if.svi 

VLOG_OPT += +define+SM_X4 +define+SM_RP_SIM_ENABLE +define+SVT_AXI_INCLUDE_USER_DEFINES +define+__ALTERA_STD__METASTABLE_SIM +define+IP7581SERDES_UX_SIMSPEED

VLOG_OPT += -f $(SCRIPTS_DIR)/rtl_filelist.f -f $(SCRIPTS_DIR)/verif_filelist.f

VCS_OPT = -full64 -ntb_opts uvm-1.2 -licqueue  +vcs+lic+wait -l vcs.log -debug_access+all +error+100
VCS_OPT  += $(QUARTUS_INSTALL_DIR)/eda/sim_lib/quartus_dpi.c $(QUARTUS_INSTALL_DIR)/eda/sim_lib/simsf_dpi.cpp -debug_region+cell+lib

SIMV_OPT = +UVM_TESTNAME=$(TESTNAME) -l ./sim.log run +UVM_VERBOSITY=HIGH +UVM_MAX_QUIT_COUNT=10 +UVM_NO_RELNOTES
SIMV_OPT += $(QUARTUS_INSTALL_DIR)/eda/sim_lib/quartus_dpi.c

ifdef DUMP
    VLOG_OPT += -debug_access+all +define+DUMP
    VCS_OPT += -debug_access+all
    SIMV_OPT += -ucli -i $(VCDFILE)
endif

ifndef SEED
    SIMV_OPT += +ntb_random_seed_automatic
else
    SIMV_OPT += +ntb_random_seed=$(SEED)
endif

create_new_flist:
	@echo ''
	@echo RP_ROOTDIR=$(RP_ROOTDIR)
	@echo QUARTUS_HOME=$(QUARTUS_HOME)
	@echo QUARTUS_INSTALL_DIR=$(QUARTUS_INSTALL_DIR)
	@echo ''


cmplib:	create_new_flist gen_ip gen_ip_lib 

gen_ip:
	cd $(WORKDIR)/../syn/g4x4 && qsys-generate --quartus-project=top.qpf --clear-output-directory ../../src/g4x4/qsys_top/qsys_top.qsys --synthesis=VERILOG --simulation=VERILOG --allow-mixed-language-simulation --simulator=VCSMX
	cd $(WORKDIR)/../src/g4x4/qsys_top/qsys_top/sim/ && perl $(SCRIPTS_DIR)/sm_hps_modify.pl qsys_top.v qsys_top_mod.v --cct_prefix=ace5lite_cache_coherency_translator_0_m_ace5lite && mv qsys_top.v qsys_top.v_org && mv qsys_top_mod.v qsys_top.v

gen_ip_lib:
	cd $(WORKDIR)/../src/g4x4/qsys_top/qsys_top/sim/synopsys/vcsmx && ./vcsmx_setup.sh SKIP_SIM=1 QUARTUS_INSTALL_DIR=$(QUARTUS_HOME)
	@echo '===== Finished generating IPs ====='

vlog:
	sh rename_prev_sim.sh
	mkdir -p ../../run_sim && cd ../../run_sim && mkdir -p sim4x4 && cd sim4x4 && mkdir -p output logs 
	rsync -avz --checksum --ignore-times $(RP_ROOTDIR)/src/g4x4/qsys_top/qsys_top/sim/synopsys/vcsmx/* $(WORKDIR)/run_sim/sim4x4/
	cd $(WORKDIR)/run_sim/sim4x4 && vlogan $(VLOG_OPT)
		
vcs: 
	cd $(WORKDIR)/run_sim/sim4x4/ && vcs $(VCS_OPT) sysrp_top_tb

run:
	cd $(WORKDIR)/run_sim/sim4x4/ && mkdir -p $(TESTNAME) && cd $(TESTNAME) && cp -f ../*.hex . && cp -f ../*.mif . && ../simv $(SIMV_OPT)

build: vlog vcs
