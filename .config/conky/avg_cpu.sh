#!/usr/bin/env bash

awk '/cpu MHz/ {sum+=$NF; num+=1} END {print sum/num/1024}' /proc/cpuinfo

