#!/bin/bash

MODEL_NAME=sanPlusMinus

#Change the settings so that lstmtraining does not CRASH

echo "---------------------------------------------------"
## to get a core dump - will be in tesseract subdirectory
ulimit -c unlimited
## https://stackoverflow.com/questions/344203/maximum-number-of-threads-per-process-in-linux/344292#344292
echo "---------/proc/sys/kernel/pid_max-----------------------------------"
echo 200000 | sudo tee -a /proc/sys/kernel/pid_max
echo "---------/proc/sys/vm/max_map_count-----------------------------------"
echo 600000 | sudo tee -a /proc/sys/vm/max_map_count
echo "---------/proc/sys/kernel/threads-max-----------------------------"
echo 120000 | sudo tee -a /proc/sys/kernel/threads-max
echo "--------- /etc/systemd/system.conf ------------------------------------------"
cat /etc/systemd/system.conf | grep Tasks
echo "----------/etc/systemd/logind.conf-----------------------------------------"
cat  /etc/systemd/logind.conf | grep Tasks
echo "---------------------------------------------------"
ulimit -a
echo "---------------------------------------------------"

## plot/${MODEL_NAME}.LOG is used for plotting of CER. Do NOT change its name.

nohup make training MODEL_NAME=${MODEL_NAME} START_MODEL=san TESSDATA=data MAX_ITERATIONS=9999999  LANG_TYPE=Indic  DEBUG_INTERVAL=-1  > plot/${MODEL_NAME}.LOG &
