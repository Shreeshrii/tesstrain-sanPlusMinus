PREFIX=$1
mkdir -p data/$PREFIX
cp ~/langdata_lstm/san/san.config data/$PREFIX/$PREFIX.config
find  data/$PREFIX-ground-truth/  -name '*.gt.txt' | xargs -I{} sh -c "cat {}; echo ''" > data/$PREFIX/all-gt
python ./count_chars.py data/$PREFIX/all-gt | sort -n -r > data/$PREFIX/all-gt-charcount
## cleanup all-gt to remove characters occuring only 10-15 times
find  data/$PREFIX-ground-truth/ -type f -name *.lstmf > data/$PREFIX/all-lstmf
shuf -o data/$PREFIX/all-lstmf < data/$PREFIX/all-lstmf
lstmffile=data/$PREFIX/all-lstmf
lstmfcount=$(wc -l < "$lstmffile")
let "evalcount=lstmfcount/10"
cd data/$PREFIX
csplit  -f list. all-lstmf $evalcount {1} 
cd ../..
mv data/$PREFIX/list.00 data/$PREFIX/list.eval
mv data/$PREFIX/list.01 data/$PREFIX/list.validate
mv data/$PREFIX/list.02 data/$PREFIX/list.train

# Use 10 times the count of lstmf files in list.train as MAX_ITERATIONS

nohup make training MODEL_NAME=$PREFIX START_MODEL=san TESSDATA=/home/ubuntu/tessdata_best MAX_ITERATIONS=64530  LANG_TYPE=Indic  DEBUG_INTERVAL=-1  > plot/$PREFIX.LOG &

# nohup make training MODEL_NAME=sanPlusMinus START_MODEL=san TESSDATA=/home/ubuntu/tessdata_best MAX_ITERATIONS=645300  LANG_TYPE=Indic  DEBUG_INTERVAL=-1  >> plot/sanPlusMinus.LOG &
