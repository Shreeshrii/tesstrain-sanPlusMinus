# Name of the model to be evaluated. Default: $(MODEL_NAME)
MODEL_NAME = foo

# Directory for plot and tsv files for the model.
PLOT_DIR =../data/$(MODEL_NAME)/plots

# TSV file with header, iteration, checkpoint, eval and validation CER. Default: $(TSV_ALL_CER)
# Info only, not used for plotting.
TSV_ALL_CER = $(PLOT_DIR)/$(MODEL_NAME)-cer.tsv

# Temporary files.
TMP_100_ITERATIONS = tmp-$(MODEL_NAME)-iteration.tsv
TMP_CHECKPOINT = tmp-$(MODEL_NAME)-checkpoint.tsv
TMP_EVAL = tmp-$(MODEL_NAME)-eval.tsv
TMP_SUB = tmp-$(MODEL_NAME)-sub.tsv

all: traineddata plotvalidatecer

# BEGIN-EVAL makefile-parser --make-help Makefile

help:
	@echo ""
	@echo "  Targets"
	@echo ""
	@echo "    traineddata      Create best and fast .traineddata files from each .checkpoint file"
	@echo "    plotvalidatecer  Make plots from TSV files generated from training and eval logs"
	@echo ""
	@echo "  Variables"
	@echo ""
	@echo "    MODEL_NAME         Name of the model to be built. Default: $(MODEL_NAME)"
	@echo ""

# END-EVAL

.PHONY:  $(TMP_100_ITERATIONS) $(TMP_CHECKPOINT) $(TMP_EVAL) $(TMP_SUB)

# Training log file. This should match logfile name from training. Default: $(MODEL_LOG)
MODEL_LOG = $(MODEL_NAME).LOG

# Rename checkpoints with one/two decimal digits to 3 decimal digts for correct sorting later.
# Run Makefile in main directory to create traineddata from all checkpoints.

traineddata:
	@find ../data/$(MODEL_NAME)/checkpoints/ -regex ^.*$(MODEL_NAME)_[0-9]\.[0-9]_.*_.*.checkpoint -exec rename -v 's/(.[0-9])_/$${1}00_/' {} \;
	@find ../data/$(MODEL_NAME)/checkpoints/ -regex ^.*$(MODEL_NAME)_[0-9]*\.[0-9][0-9]_.*_.*.checkpoint -exec rename -v 's/(.[0-9][0-9])_/$${1}0_/' {} \;
	$(MAKE) -C ../ traineddata MODEL_NAME=$(MODEL_NAME)
	@mkdir -p $(PLOT_DIR)

plotvalidatecer:  $(TMP_100_ITERATIONS) $(TMP_CHECKPOINT) $(TMP_EVAL) $(TMP_SUB) $(TSV_ALL_CER)

# Make TSV with CER at every 100 iterations.
$(TMP_100_ITERATIONS):
	@echo "Name	CheckpointCER	LearningIteration	TrainingIteration	EvalCER	IterationCER	SubtrainerCER" > "$@"
	@grep 'At iteration' $(MODEL_LOG) \
		| sed -e '/^Sub/d' \
		| sed -e '/^Update/d' \
		| sed -e '/^ New worst BCER/d' \
		| sed -e 's/At iteration \([0-9]*\)\/\([0-9]*\)\/.*BCER train=/\t\t\1\t\2\t\t/' \
		| sed -e 's/%, BWER.*/\t/' >>  "$@"

# Make TSV with Checkpoint CER.
$(TMP_CHECKPOINT):
	@echo "Name	CheckpointCER	LearningIteration	TrainingIteration	EvalCER	IterationCER	SubtrainerCER" > "$@"
	@grep 'best model' $(MODEL_LOG) \
		| sed -e 's/^.*\///' \
		| sed -e 's/\.checkpoint.*$$/\t\t\t/' \
		| sed -e 's/_/\t/g' >>  "$@"

# Make TSV with Eval CER.
$(TMP_EVAL):
	@echo "Name	CheckpointCER	LearningIteration	TrainingIteration	EvalCER	IterationCER	SubtrainerCER" > "$@"
	@grep 'BCER eval' $(MODEL_LOG) \
		| sed -e 's/^.*[0-9]At iteration //' \
		| sed -e 's/,.* BCER eval=/\t\t/'  \
		| sed -e 's/, BWER.*$$/\t\t/' \
		| sed -e 's/^/\t\t/' >>  "$@"

# Make TSV with Subtrainer CER.
$(TMP_SUB):
	@echo "Name	CheckpointCER	LearningIteration	TrainingIteration	EvalCER	IterationCER	SubtrainerCER" > "$@"
	@grep '^UpdateSubtrainer' $(MODEL_LOG) \
		| sed -e 's/^.*At iteration \([0-9]*\)\/\([0-9]*\)\/.*BCER train=/\t\t\1\t\2\t\t\t/' \
		| sed -e 's/%, BWER.*//' >>  "$@"
		
# Combine TSV files with all required CER values, generated from training log and validation logs. Plot.
$(TSV_ALL_CER): $(TMP_100_ITERATIONS) $(TMP_CHECKPOINT) $(TMP_EVAL) $(TMP_SUB)
	@cat $(TMP_100_ITERATIONS) $(TMP_CHECKPOINT) $(TMP_EVAL) $(TMP_SUB) > "$@"
	python plot-eval-validate-cer.py -m $(MODEL_NAME) -y $(Y_MAX_CER)
	@rm tmp-$(MODEL_NAME)*.*
