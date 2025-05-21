#!/bin/bash

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
