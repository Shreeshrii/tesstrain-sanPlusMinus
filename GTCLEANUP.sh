find data/Sanskrit-ground-truth/ -type f -name "*.gt.txt" \
-exec sh -c 'ls "${0%.gt.txt}.lstmf" 2>>myfile' {} \;
sed -i -e "s/ls: cannot access '/rm /" myfile
sed -i -e "s/lstmf': No such file or directory/*/" myfile
bash myfile

find data/Sanskrit-ground-truth/ -type f -name "*.lstmf" \
-exec sh -c 'ls "${0%.lstmf}.box" 2>>pngfile' {} \;
sed -i -e "s/ls: cannot access '/rm /" pngfile
sed -i -e "s/box': No such file or directory/*/" pngfile
bash pngfile

find data/Sanskrit-ground-truth/ -type f -name "*.lstmf" |wc -l
find data/Sanskrit-ground-truth/ -type f -name "*.box" |wc -l
find data/Sanskrit-ground-truth/ -type f -name "*.png" |wc -l
find data/Sanskrit-ground-truth/ -type f -name "*.gt.txt" |wc -l

rm myfile
rm pngfile

find data/Sanskrit-ground-truth/ -type f -name "*.gt.txt" -exec grep -E '̥|ḏ|Ḹ|ऍ|Ṝ|¡|Ġ|ü|ï| '  {} /dev/null \; > del.sh
sed -i  's/gt\.txt.*/*/' del.sh
sed -i  's/^/rm /' del.sh
bash del.sh
rm del.sh

find  data/Sanskrit-ground-truth/*/ -type f -size 0 > gtzerosize.sh
bash gtzerosize.sh
rm gtzerosize.sh

find  data/Sanskrit-ground-truth/*/  -name '*.gt.txt' | xargs -I{} sh -c "cat {}; echo ''" > data/Sanskrit/all-gt
python ./count_chars.py data/Sanskrit/all-gt | sort -n -r > data/Sanskrit/all-gt-charcount
