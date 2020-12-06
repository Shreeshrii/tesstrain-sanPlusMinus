#!/bin/bash

MODEL_NAME=sanPlusMinus
MODEL_LOG=plot/${MODEL_NAME}.LOG

## PLOT the LOGS

grep 'best model' ${MODEL_LOG} |  sed  -e 's/^.*\///' |  sed  -e 's/\.checkpoint.*$//' | sed  -e 's/_/\t/g' > plot/tmp-${MODEL_NAME}-plot-best.csv
grep 'Eval Char' ${MODEL_LOG} | sed -e 's/^.*[0-9]At iteration //' | \sed -e 's/,.* Eval Char error rate=/\t\t/'  | sed -e 's/, Word.*$//' | sed -e 's/^/\t\t/'> plot/tmp-${MODEL_NAME}-plot-eval.csv
grep 'At iteration' ${MODEL_LOG} |  sed -e '/^Sub/d' |  sed -e '/^Update/d' | sed  -e 's/At iteration \([0-9]*\)\/\([0-9]*\)\/.*char train=/\t\t\1\t\2\t\t/' |  sed  -e 's/%, word.*$//'   > plot/tmp-${MODEL_NAME}-plot-iteration.csv

echo "Name	CheckpointCER	LearningIteration	TrainingIteration	EvalCER	IterationCER	ValidationCER" > plot/tmp-${MODEL_NAME}-plot-header.csv
cat plot/tmp-${MODEL_NAME}-plot-header.csv  plot/tmp-${MODEL_NAME}-plot-iteration.csv plot/tmp-${MODEL_NAME}-plot-best.csv plot/tmp-${MODEL_NAME}-plot-eval.csv  > plot/${MODEL_NAME}-plot_cer.csv

python PLOT_CER.py -m ${MODEL_NAME} 

rm plot/tmp-${MODEL_NAME}-plot-*  
