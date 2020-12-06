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

nohup make training MODEL_NAME=sanPlusMinus START_MODEL=san TESSDATA=/home/ubuntu/tessdata_best MAX_ITERATIONS=9999999  LANG_TYPE=Indic  DEBUG_INTERVAL=-1  > plot/sanPlusMinus.LOG &
