# Name of the model to be evaluated. Default: $(MODEL_NAME)
MODEL_NAME = sanPlusMinus

# Suffix of list of lstmf files to be used as validation set e.g. list.validate. Default: $(VALIDATE_LIST)
VALIDATE_LIST=validate

# Whole integer part of maximum CER for checkpoints to be evaluated, use values between 0-9. Default: $(VALIDATE_CER)
VALIDATE_CER=9

# Training log file. This should match value given while starting training. Default: $(MODEL_LOG)
MODEL_LOG = $(MODEL_NAME).LOG

# Temporary Validation logs and TSV files.
FAST_VALIDATE_LOG = $(MODEL_NAME)-fast-$(VALIDATE_LIST).log
TMP_VALIDATE_LOG = tmp-$(MODEL_NAME)-$(VALIDATE_LIST).log
TMP_100_ITERATIONS = tmp-${MODEL_NAME}-plot-iteration.tsv
TMP_CHECKPOINT = tmp-${MODEL_NAME}-plot-checkpoint.tsv
TMP_EVAL = tmp-${MODEL_NAME}-plot-eval.tsv
TMP_HEADER = tmp-${MODEL_NAME}-plot-header.tsv
TMP_VALIDATE = tmp-${MODEL_NAME}-plot-validate.tsv
TMP_VALIDATE_LIST =  tmp-${MODEL_NAME}-list.$(VALIDATE_LIST)

# TSV file with header, iteration, checkpoint and eval CER. Default: $(TSV_CER)
TSV_CER = ${MODEL_NAME}-plot_cer.tsv

# TSV file with header, iteration, checkpoint, eval and validation CER. Default: $(TSV_VALIDATE_CER)
TSV_VALIDATE_CER = ${MODEL_NAME}-${VALIDATE_LIST}-plot_cer.tsv

.PHONY:  $(TSV_CER) $(TMP_HEADER) $(TMP_100_ITERATIONS) $(TMP_CHECKPOINT) $(TMP_EVAL) $(TMP_VALIDATE) $(TSV_VALIDATE_CER) $(TMP_VALIDATE_LOG) $(FAST_VALIDATE_LOG)

all: traineddata validatelist plotcer plotvalidatecer

# Run Makefile in main directory to create traineddata from all checkpoints.
traineddata:
	$(MAKE) -C ../ traineddata MODEL_NAME=$(MODEL_NAME)

# Add ../ to lstmf file names in validate list relative to plot subdirectory.
validatelist:
	cp ../data/$(MODEL_NAME)/list.${VALIDATE_LIST} $(TMP_VALIDATE_LIST)
	sed -i -e 's/^data/..\/data/' $(TMP_VALIDATE_LIST)

plotvalidatecer: $(TSV_VALIDATE_CER)

# Combine TSV files with all required CER values, generated from training log and validation logs. Plot.
$(TSV_VALIDATE_CER): $(TMP_VALIDATE) $(TSV_CER)
	cat $(TSV_CER) $(TMP_VALIDATE) > "$@"
	python plot-eval-validate-cer.py -m $(MODEL_NAME)  -v $(VALIDATE_LIST)
	rm $(TMP_VALIDATE) $(TMP_VALIDATE_LOG) $(FAST_VALIDATE_LOG) $(TMP_VALIDATE_LIST)

# Make TSV with Validate CER.
$(TMP_VALIDATE): $(TMP_VALIDATE_LOG)
	sed 'N;s/\nAt iteration 0, stage 0, /At iteration 0, stage 0, /;P;D'  $(TMP_VALIDATE_LOG) \
		| grep 'Eval Char' \
		| sed -e "s/.$(VALIDATE_LIST).log.*Eval Char error rate=/\t\t\t/" \
		| sed -e 's/, Word.*$$//' \
		| sed -e 's/\(^.*\)_\([0-9].*\)_\([0-9].*\)_\([0-9].*\)\t/\1\t\2\t\3\t\4\t/g' >  "$@"

# Extract Filename and CER infrom from Validate log for building Validate TSV file.
$(TMP_VALIDATE_LOG): $(FAST_VALIDATE_LOG)
	grep -E "$(VALIDATE_LIST).log$$|iteration" $(FAST_VALIDATE_LOG) > "$@"

# Build fast traineddata file list with CER in range [0-VALIDATE_CER].[0-9].
FAST_DATA_FILES := $(shell find ../data/$(MODEL_NAME)/tessdata_fast/ -type f -name *_[0-$(VALIDATE_CER)].[0-9]*.traineddata | sort -n)

# Build validate log files list based on above traineddata list.
FAST_VALIDATE_LOG_FILES := $(subst tessdata_fast,tessdata_fast,$(patsubst %.traineddata,%.$(VALIDATE_LIST).log,$(FAST_DATA_FILES)))

# Concatenate all validate.log files along with their filenames so as to include iteration number for TSV.
$(FAST_VALIDATE_LOG): $(FAST_VALIDATE_LOG_FILES)
	for i in $^; do \
		echo Filename : "$$i";echo;cat "$$i"; \
	done > $@

#TODO: This does not reflect the changed list of files from `make traineddata`. 
#	Hence `make` needs to be run twice to generate new validate.log files.

$(FAST_VALIDATE_LOG_FILES): %.$(VALIDATE_LIST).log: %.traineddata
	OMP_THREAD_LIMIT=1 lstmeval  \
		--verbosity=0 \
		--model $< \
		--eval_listfile $(TMP_VALIDATE_LIST)    > $@ 2>&1

plotcer: $(TSV_CER)

# Combine TSV files generated from training log.
# Uncomment python script to generate separate eval plot.
$(TSV_CER): $(TMP_HEADER) $(TMP_100_ITERATIONS) $(TMP_CHECKPOINT) $(TMP_EVAL)
	cat $(TMP_HEADER) $(TMP_100_ITERATIONS) $(TMP_CHECKPOINT) $(TMP_EVAL)  > "$@"
	rm $(TMP_HEADER) $(TMP_100_ITERATIONS) $(TMP_CHECKPOINT) $(TMP_EVAL)
#	python plot-eval-cer.py -m $(MODEL_NAME)

# Make TSV header with all column headings.
$(TMP_HEADER):
	echo "Name	CheckpointCER	LearningIteration	TrainingIteration	EvalCER	IterationCER	ValidationCER" > "$@"

# Make TSV with CER at every 100 iterations.
$(TMP_100_ITERATIONS): $(MODEL_LOG)
	grep 'At iteration' $(MODEL_LOG) \
		| sed -e '/^Sub/d' \
		| sed -e '/^Update/d' \
		| sed -e 's/At iteration \([0-9]*\)\/\([0-9]*\)\/.*char train=/\t\t\1\t\2\t\t/' \
		| sed -e 's/%, word.*/\t/' >  "$@"

# Make TSV with Checkpoint CER.
$(TMP_CHECKPOINT): $(MODEL_LOG)
	grep 'best model' $(MODEL_LOG) \
		| sed -e 's/^.*\///' \
		| sed -e 's/\.checkpoint.*$$/\t\t\t/' \
		| sed -e 's/_/\t/g' >  "$@"

# Make TSV with Eval CER.
$(TMP_EVAL): $(MODEL_LOG)
	grep 'Eval Char' $(MODEL_LOG) \
		| sed -e 's/^.*[0-9]At iteration //' \
		| sed -e 's/,.* Eval Char error rate=/\t\t/'  \
		| sed -e 's/, Word.*$$/\t\t/' \
		| sed -e 's/^/\t\t/' >  "$@"
