#!/bin/bash
# $1 - MODEL_NAME
# $2 - maximum CER for y axis - adjust based on graph
# example: bash -x plot.sh IASTNEW  10

# info
grep 'Sub trainer' plot/$1.LOG
grep 'learning rate' plot/$1.LOG
tail -10 plot/$1.LOG

# plotting
cd plot
make  MODEL_NAME=$1 Y_MAX_CER=$2
