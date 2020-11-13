MODEL=Sanskrit
TYPE=
PREFIX=${MODEL}${TYPE}
START_MODEL=/home/ubuntu/tessdata_best/script/Devanagari.traineddata
LISTNAME=scanned

## run eval against START_MODEL
make -f Makefile-Eval fasteval MODEL_NAME=${MODEL} LISTNAME=${LISTNAME} FAST_FILES=${START_MODEL} >plot/tmp-plot-${MODEL}-startmodel.LOG   2>&1
egrep "\*\*\*\*$|iteration" plot/tmp-plot-${MODEL}-startmodel.LOG > plot/${PREFIX}-startmodel.LOG
rm plot/tmp-plot-${MODEL}-startmodel.LOG

### bash plot_cer.sh ${PREFIX}
