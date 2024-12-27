#!/bin/bash

widths=(8 16 32 64 128 256 512 1024)
log_ws=(3 4 5 6 7 8 9 10)

for ((i = 0; i < 8; i++)); do
  ./synopsys.sh -r ppe_com "${widths[$i]}" "${log_ws[$i]}"
done
