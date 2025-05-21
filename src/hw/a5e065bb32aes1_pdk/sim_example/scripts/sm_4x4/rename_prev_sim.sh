#!/bin/bash
#************************************************************************************************
# Copyright (C) 2025 - 2025 Altera Corporation
#
# This code and the related documents are Altera copyrighted materials and your use 
# of them is governed by the express license under which they were provided to you ("License"). 
# This code and the related documents are provided as is, with no express or implied 
# warranties other than those that are expressly stated in the License.
#************************************************************************************************

count="${2:-1}"

printf -v dname "%02d" "$count"

while [ -d "../../run_sim/sim4x4.$dname" ]
do
  ((count++))
  printf -v dname "%02d" "$count"
done

if [ -d "../../run_sim/sim4x4" ]
then
  printf "renaming last sim4x4 to %s\n" "sim4x4.$dname"
  mv ../../run_sim/sim4x4 ../../run_sim/"sim4x4.$dname"
fi
