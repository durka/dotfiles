#!/usr/bin/env bash

source $(dirname $0)/utilities.bash

ghz=$(awk '/cpu MHz/ {sum+=$NF; num+=1} END {print sum/num/1024}' /proc/cpuinfo)
echo $(si_prefix $(calc "$ghz*1024*1024"))Hz

