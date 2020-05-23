#!/bin/bash
# nohup bash sanPlusMinus.sh > sanPlusMinus.log & 

### fix path og GTDIR  below to  match your environment.
GTDIR=gt
echo "/n ****** Finetune one of the fully-trained existing models: ***********"
echo "/n ****** using tessdata_best/script/Devanagari.traineddata  ***********"

mkdir -p sanPlusMinus

### fix path below to  match your environment.
### cp -v  <path where your tessdata_best files are>/Devanagari.traineddata   sanPlusMinus/Devanagari.traineddata
cp -v   ~/tessdata_best/script/Devanagari.traineddata   sanPlusMinus/Devanagari.traineddata
combine_tessdata -e sanPlusMinus/Devanagari.traineddata  sanPlusMinus/san.lstm-unicharset
combine_tessdata -e sanPlusMinus/Devanagari.traineddata  sanPlusMinus/san.lstm
combine_tessdata -e sanPlusMinus/Devanagari.traineddata  sanPlusMinus/san.version

### fix path below to  match your environment.
### copy dictionary files from <path where your langdata_lstm files are>
cp -v  ~/langdata_lstm/san/san.punc sanPlusMinus/
cp -v  ~/langdata_lstm/san/san.numbers sanPlusMinus/
cp -v  ~/langdata_lstm/san/san.config sanPlusMinus/
cp -v  ~/langdata_lstm/Devanagari.unicharset sanPlusMinus/
cp -v  ~/langdata_lstm/Latin.unicharset sanPlusMinus/
cp -v  ~/langdata_lstm/radical-stroke.txt sanPlusMinus/

### ls -1 <path where your lstmf files are>/*.lstmf > sanPlusMinus/all-lstmf
for f in $GTDIR/*.lstmf; do ls -1 "${f}"; done | shuf > sanPlusMinus/all-lstmf
### Alternate 
### ls -1  $GTDIR/*.lstmf > sanPlusMinus/all-lstmf

###split 1/10 of total lstm files for eval, 90:10 ratio
lines=$(wc -l < sanPlusMinus/all-lstmf)
testlines=$(($lines/10))
trainlines=$(($lines-$testlines))
head -n $testlines sanPlusMinus/all-lstmf > sanPlusMinus/list.eval
tail -n $trainlines  sanPlusMinus/all-lstmf > sanPlusMinus/list.train

#### extract unicharset from groundtruth, no merge of lstm-unicharset
for f in $GTDIR/*.gt.txt; do cat "${f}"; echo; done  > sanPlusMinus/all-gt
### Alternate 
### cat  $GTDIR/*.gt.txt > sanPlusMinus/all-gt

unicharset_extractor --output_unicharset "sanPlusMinus/unicharset" --norm_mode 2  "sanPlusMinus/all-gt"
cp -v   sanPlusMinus/unicharset  sanPlusMinus/my.unicharset  

#### create starter traineddata
mkdir -p sanPlusMinus/san
## copy config file
cp -v  sanPlusMinus/san.config sanPlusMinus/san/
## create starter traineddata
combine_lang_model \
  --input_unicharset sanPlusMinus/my.unicharset \
  --script_dir sanPlusMinus \
  --numbers sanPlusMinus/san.numbers \
  --puncs sanPlusMinus/san.punc \
  --output_dir ./sanPlusMinus \
  --pass_through_recoder \
  --lang san

### number of iterations depend on amount of training data available. 
lstmtraining \
  --model_output sanPlusMinus/PlusMinus \
  --continue_from sanPlusMinus/san.lstm \
  --old_traineddata sanPlusMinus/Devanagari.traineddata \
  --traineddata sanPlusMinus/san/san.traineddata \
  --train_listfile sanPlusMinus/list.train \
  --eval_listfile sanPlusMinus/list.eval \
  --debug_interval -1 \
  --max_iterations 15000
  
echo -e "\n**************************** Stop Training and convert to best traineddata ******\n"

lstmtraining \
  --stop_training \
  --continue_from sanPlusMinus/PlusMinus_checkpoint \
  --traineddata sanPlusMinus/san/san.traineddata \
  --model_output sanPlusMinus/sanPlusMinus.traineddata

Version_Str="sanPlusMinus:best:shreeshrii`date +%Y%m%d`:from:Devanagari"
sed -e "s/^.*$/$Version_Str/" sanPlusMinus/san.version > sanPlusMinus/sanPlusMinus.version
combine_tessdata -o sanPlusMinus/sanPlusMinus.traineddata  sanPlusMinus/sanPlusMinus.version

echo -e "\n**************************** Stop Training and convert to fast traineddata ******\n"

lstmtraining \
  --stop_training \
  --convert_to_int \
  --continue_from sanPlusMinus/PlusMinus_checkpoint \
  --traineddata sanPlusMinus/san/san.traineddata \
  --model_output sanPlusMinus/sanPlusMinusfast.traineddata

Version_Str="sanPlusMinus:fast:shreeshrii`date +%Y%m%d`:from:Devanagari"
sed -e "s/^.*$/$Version_Str/" sanPlusMinus/san.version > sanPlusMinus/sanPlusMinus.version
combine_tessdata -o sanPlusMinus/sanPlusMinusfast.traineddata  sanPlusMinus/sanPlusMinus.version

echo -e "\n****************************  eval fast finetuned data ******\n"
  
OMP_THREAD_LIMIT=1 time -p lstmeval \
  --model  sanPlusMinus/sanPlusMinusfast.traineddata \
  --eval_listfile sanPlusMinus/list.eval  2>&1 |  egrep 'error|real|user|sys'

echo -e "\n****************************  eval best finetuned data ******\n"
  
OMP_THREAD_LIMIT=1 time -p lstmeval \
  --model  sanPlusMinus/sanPlusMinus.traineddata \
  --eval_listfile sanPlusMinus/list.eval  2>&1 |  egrep 'error|real|user|sys'

echo -e "\n**************************** eval tessdata_best/script/Devanagari  ******\n"
  
OMP_THREAD_LIMIT=1 time -p lstmeval \
  --model   sanPlusMinus/Devanagari.traineddata \
  --eval_listfile sanPlusMinus/list.eval 2>&1 |  egrep 'error|real|user|sys'

echo -e "\n**************************** eval tessdata_best/san  ******\n"
  
OMP_THREAD_LIMIT=1 time -p lstmeval \
  --model    ~/tessdata_best/san.traineddata \
  --eval_listfile sanPlusMinus/list.eval 2>&1 |  egrep 'error|real|user|sys'


