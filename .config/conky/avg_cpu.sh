#!/usr/bin/env bash

source $(dirname $0)/utilities.bash

avg_ghz=$(awk '/cpu MHz/ {sum+=$NF; num+=1} END {print sum/num/1024}' /proc/cpuinfo)
max_ghz=$(awk 'BEGIN {max=0} /cpu MHz/ {if ($NF>max) max=$NF} END {print max/1024}' /proc/cpuinfo)
min_ghz=$(awk 'BEGIN {min=10000} /cpu MHz/ {if ($NF<min) min=$NF} END {print min/1024}' /proc/cpuinfo)
echo $(si_prefix $(calc "$avg_ghz*1024*1024"))Hz "($(si_prefix $(calc "$min_ghz*1024*1024") 0) - $(si_prefix $(calc "$max_ghz*1024*1024"))Hz)"

