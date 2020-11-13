#!/bin/bash
PREFIX=$1
cd plot
    echo "Name	CheckpointCER	LearningIteration	TrainingIteration	EvalCER	IterationCER	ValidationCER" > tmp-plot-header.csv
    grep 'best model' ${PREFIX}.LOG |  sed  -e 's/^.*\///' |  sed  -e 's/\.checkpoint.*$//' | sed  -e 's/_/\t/g' > tmp-plot-best.csv
    grep 'Eval Char' ${PREFIX}.LOG | sed -e 's/^.*[0-9]At iteration //' | \sed -e 's/,.* Eval Char error rate=/\t\t/'  | sed -e 's/, Word.*$//' | sed -e 's/^/\t\t/'> tmp-plot-eval.csv
    grep 'At iteration' ${PREFIX}.LOG |  sed -e '/^Sub/d' |  sed -e '/^Update/d' | sed  -e 's/At iteration \([0-9]*\)\/\([0-9]*\)\/.*char train=/\t\t\1\t\2\t\t/' |  sed  -e 's/%, word.*$//'   > tmp-plot-iteration.csv
    cat tmp-plot-header.csv  tmp-plot-iteration.csv tmp-plot-best.csv tmp-plot-eval.csv > plot_cer.csv
    ###
    echo "Name	CheckpointCER	LearningIteration	TrainingIteration	ScriptCER	StartModelCER	ValidationCER" > tmp-plot-header-validation.csv
    sed 'N;s/\nAt iteration 0, stage 0, /At iteration 0, stage 0, /;P;D'  ${PREFIX}-eval.LOG | grep 'Eval Char' | sed -e 's/.traineddata.*Eval Char error rate=/\t\t\t/' | sed -e 's/, Word.*$//' | sed  -e 's/\(^.*\)_\([0-9].*\)_\([0-9].*\)_\([0-9].*\)\t/\1\t\2\t\3\t\4\t/g' >  tmp-plot-validation.csv
    sed 'N;s/\nAt iteration 0, stage 0, /At iteration 0, stage 0, /;P;D'  ${PREFIX}-startmodel.LOG | grep 'Eval Char' | sed -e 's/.traineddata.*Eval Char error rate=/\t\t100\t\t/' | sed -e 's/, Word.*$//' | sed  -e 's/\(^.*\)best\/\(.*\)\(.*\)\t/\2\t\t\3/g' >   tmp-plot-startmodel.csv
    cat tmp-plot-header-validation.csv    tmp-plot-validation.csv  > plot_cer_validation.csv
    cat tmp-plot-header-validation.csv     tmp-plot-startmodel.csv  > plot_cer_startmodel.csv
    rm tmp-plot-*
    ## python plot_cer_validation.py
    python plot_cer.py
    rm ${PREFIX}-plot*.png
    rename "s/plot/${PREFIX}-plot/" plot_cer*.png
    mv plot_cer.csv ${PREFIX}-plot_cer.csv
    mv plot_cer_validation.csv ${PREFIX}-plot_cer_validation.csv
cd ..
