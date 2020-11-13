#!/bin/bash
# single line -psm 13, use gt to wordstrbox to lstmf,DO NOT remove box file, needed by makefile

	cd data/Sanskrit-ground-truth
	my_files=$(find  */ -type f -name *.png)
	for my_file in ${my_files}; do
			echo -e "\n${my_file%.*}"
			PYTHONIOENCODING=UTF-8  python3 ~/tesstrain/generate_wordstr_box.py -i "${my_file}" -t "${my_file%.*}.gt.txt" > "${my_file%.*}.box"
			OMP_THREAD_LIMIT=1 tesseract ${my_file}  ${my_file%.*}   --dpi 300 --psm 13  lstm.train
	done
