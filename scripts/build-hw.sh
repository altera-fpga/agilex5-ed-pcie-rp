#!/bin/sh
set -eux

cd src/hw/a5e065bb32aes1_pdk/syn/sm_4x4/
arc shell acdskit/25.1/124 -- 'quartus_sh --flow compile top'
arc shell acds/25.1 socfpga_refdes/mainline/625 -- 'quartus_pfg -c -o hps=on -o hps_path="$SOCFPGA_REFDES_ROOT"/designs/agilex5_devkit_soc_ghrd/u-boot-spl-dtb.hex output_files/top.sof output_files/top.rbf'
