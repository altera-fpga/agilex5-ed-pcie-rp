#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************

set_time_format -unit ns -decimal_places 3

# 100MHz board input clock, 150MHz for EMIF refclk
create_clock -name MAIN_CLOCK -period 10 [get_ports fpga_clk_100]
create_clock -name EMIF_REF_CLOCK -period 150MHz [get_ports emif_hps_emif_ref_clk_0_clk] 

set_false_path -from [get_ports {fpga_reset_n}]

# sourcing JTAG related SDC
source ./jtag.sdc

