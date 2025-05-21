#****************************************************************************
#
# SPDX-License-Identifier: MIT-0
# Copyright(c) 2019-2021 Intel Corporation.
#
#****************************************************************************

# SM PCIe RP constraints
set_clock_groups -asynchronous -group outclk_100 -group *|intel_pcie_gts|intel_pcie_gts_0|coreclkout_hip_pld_clk
set_clock_groups -asynchronous -group outclk_250 -group *|intel_pcie_gts|intel_pcie_gts_0|coreclkout_hip_pld_clk
set_clock_groups -asynchronous -group MAIN_CLOCK -group outclk_250
set_clock_groups -asynchronous -group *qsys_top_wrapper|soc_inst|pcie_clk_rst_subsys_0|iopll_0|iopll_0|tennm_ph2_iopll|ref_clk0 -group outclk_250

