MODEL=Sanskrit
TYPE=
PREFIX=${MODEL}${TYPE}
START_MODEL=/home/ubuntu/tessdata_best/script/Devanagari.traineddata
LISTNAME=scanned

## make all traineddata files
make traineddata MODEL_NAME=${MODEL}  
## run eval against validate list with the best CER models (%range as in Makefile-Eval)
make -f Makefile-Eval fasteval MODEL_NAME=${MODEL} LISTNAME=${LISTNAME}  >plot/tmp-plot-${MODEL}-fastvalidate.LOG   2>&1
egrep "\*\*\*\*$|iteration" plot/tmp-plot-${MODEL}-fastvalidate.LOG > plot/${PREFIX}-validate.LOG
rm plot/tmp-plot-${MODEL}-fastvalidate.LOG

### bash plot_cer.sh{PREFIX}
