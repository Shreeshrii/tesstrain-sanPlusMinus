MODEL=sanPlusMinus
TYPE=
PREFIX=${MODEL}${TYPE}
LISTNAME=validate

## make all traineddata files
make traineddata MODEL_NAME=${MODEL}  
## run eval against validate list with the best CER models (%range as in Makefile-Eval)
make -f Makefile-Validate fasteval MODEL_NAME=${MODEL} LISTNAME=${LISTNAME}
## Add name to Validation log file
find data/${MODEL}/tessdata_fast/ -type f -name "*.validate.log" | sort -n | xargs -I % bash -c "echo ''; echo '----------------------'; echo %; echo '----------------------'; cat %; echo '';" >plot/plot-${MODEL}-fastvalidate.LOG

## PLOT the LOGS
cd plot
    echo "Name	CheckpointCER	LearningIteration	TrainingIteration	EvalCER	IterationCER	ValidationCER" > tmp-plot-header.csv
    grep 'best model' ${PREFIX}.LOG |  sed  -e 's/^.*\///' |  sed  -e 's/\.checkpoint.*$//' | sed  -e 's/_/\t/g' > tmp-plot-best.csv
    grep 'Eval Char' ${PREFIX}.LOG | sed -e 's/^.*[0-9]At iteration //' | \sed -e 's/,.* Eval Char error rate=/\t\t/'  | sed -e 's/, Word.*$//' | sed -e 's/^/\t\t/'> tmp-plot-eval.csv
    grep 'At iteration' ${PREFIX}.LOG |  sed -e '/^Sub/d' |  sed -e '/^Update/d' | sed  -e 's/At iteration \([0-9]*\)\/\([0-9]*\)\/.*char train=/\t\t\1\t\2\t\t/' |  sed  -e 's/%, word.*$//'   > tmp-plot-iteration.csv
    egrep "validate.log$|iteration" plot-${MODEL}-fastvalidate.LOG > tmp-plot-${PREFIX}-validate.LOG
    sed 'N;s/\nAt iteration 0, stage 0, /At iteration 0, stage 0, /;P;D'  tmp-plot-${PREFIX}-validate.LOG | grep 'Eval Char' | sed -e 's/.validate.log.*Eval Char error rate=/\t\t\t/' | sed -e 's/, Word.*$//' | sed  -e 's/\(^.*\)_\([0-9].*\)_\([0-9].*\)_\([0-9].*\)\t/\1\t\2\t\3\t\4\t/g' >  tmp-plot-validation.csv
    cat tmp-plot-header.csv  tmp-plot-iteration.csv tmp-plot-best.csv tmp-plot-eval.csv    tmp-plot-validation.csv  > plot_cer.csv
    python plot_cer.py
    rm ${PREFIX}-plot*.png
    rename "s/plot/${PREFIX}-plot/" plot_cer*.png
    rm tmp-plot-*  
cd ..