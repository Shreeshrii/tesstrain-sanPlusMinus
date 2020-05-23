#!/bin/bash
my_files=$(ls test/*.png)
for my_file in ${my_files}; do
    echo -e "\n${my_file%.*}"
    OMP_THREAD_LIMIT=1 tesseract $my_file        ${my_file%.*} -l Grantha1 --tessdata-dir data --psm 6 wordstrbox
    mv "${my_file%.*}.box" "${my_file%.*}.wordstrbox" 
    sed -i -e "s/ \#.*/ \#/g"  ${my_file%.*}.wordstrbox
    sed -e '/^$/d' ${my_file%.*}.gt.txt > ${my_file%.*}.tmp
    sed -e  's/$/\n/g'  ${my_file%.*}.tmp > ${my_file%.*}.gt.txt
    paste --delimiters="\0"  ${my_file%.*}.wordstrbox  ${my_file%.*}.gt.txt > ${my_file%.*}.box
    rm ${my_file%.*}.wordstrbox  ${my_file%.*}.tmp
## make lstmf files
    OMP_THREAD_LIMIT=1 tesseract $my_file ${my_file%.*} -l Grantha1 --tessdata-dir data --psm 6 lstm.train
 done
