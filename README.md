# tesstrain-sanPlusMinus

This uses a custom version of [tesstrain](https://github.com/tesseract-ocr/tesstrain) repo for demonstration of PlusMinus training for Sanskrit, in Devanagari script only, using [tessdata_best/san](https://github.com/tesseract-ocr/tessdata_best/blob/master/san.traineddata) as the START_MODEL. The [ground-truth data](data/sanPlusMinus-ground-truth) is included as part of this repo. 

The training is currently ongoing. See [data directory](data) for the latest traineddata available.

## Characters included in groundtruth

The following table shows the [character counts](data/sanPlusMinus/all-gt-charcount) in `all-gt` training text. Obviously, all the characters with a low frequency will not be recognized as well as others.

```
110908 	   SPACE
75229 	 ् DEVANAGARI SIGN VIRAMA
45201 	 ा DEVANAGARI VOWEL SIGN AA
35837 	 र DEVANAGARI LETTER RA
32796 	 त DEVANAGARI LETTER TA
26770 	 ि DEVANAGARI VOWEL SIGN I
24099 	 न DEVANAGARI LETTER NA
23246 	 य DEVANAGARI LETTER YA
22167 	 म DEVANAGARI LETTER MA
21491 	 व DEVANAGARI LETTER VA
20751 	 स DEVANAGARI LETTER SA
20477 	 क DEVANAGARI LETTER KA
19356 	 े DEVANAGARI VOWEL SIGN E
16548 	 प DEVANAGARI LETTER PA
15838 	 ं DEVANAGARI SIGN ANUSVARA
14911 	 द DEVANAGARI LETTER DA
14640 	 ु DEVANAGARI VOWEL SIGN U
11650 	 ो DEVANAGARI VOWEL SIGN O
11239 	 ी DEVANAGARI VOWEL SIGN II
10488 	 ल DEVANAGARI LETTER LA
10397 	 ह DEVANAGARI LETTER HA
10375 	 ः DEVANAGARI SIGN VISARGA
9683 	 श DEVANAGARI LETTER SHA
9223 	 ग DEVANAGARI LETTER GA
8798 	 ज DEVANAGARI LETTER JA
8567 	 च DEVANAGARI LETTER CA
8565 	 ष DEVANAGARI LETTER SSA
7566 	 भ DEVANAGARI LETTER BHA
7477 	 । DEVANAGARI DANDA
7238 	 ण DEVANAGARI LETTER NNA
6879 	 ध DEVANAGARI LETTER DHA
6833 	 अ DEVANAGARI LETTER A
6574 	 ब DEVANAGARI LETTER BA
6474 	 - HYPHEN-MINUS
6100 	 . FULL STOP
5532 	 ू DEVANAGARI VOWEL SIGN UU
5243 	 ृ DEVANAGARI VOWEL SIGN VOCALIC R
5072 	 ै DEVANAGARI VOWEL SIGN AI
4764 	 थ DEVANAGARI LETTER THA
4584 	 ‌ ZERO WIDTH NON-JOINER
4557 	 ट DEVANAGARI LETTER TTA
3988 	 ॥ DEVANAGARI DOUBLE DANDA
3915 	 , COMMA
3829 	 1 DIGIT ONE
3789 	 १ DEVANAGARI DIGIT ONE
3414 	 ड DEVANAGARI LETTER DDA
3106 	 2 DIGIT TWO
2935 	 ख DEVANAGARI LETTER KHA
2779 	 | VERTICAL LINE
2736 	 0 DIGIT ZERO
2735 	 आ DEVANAGARI LETTER AA
2661 	 इ DEVANAGARI LETTER I
2648 	 ) RIGHT PARENTHESIS
2521 	 ौ DEVANAGARI VOWEL SIGN AU
2402 	 ० DEVANAGARI DIGIT ZERO
2351 	 उ DEVANAGARI LETTER U
2311 	 २ DEVANAGARI DIGIT TWO
2304 	 ए DEVANAGARI LETTER E
2304 	 ( LEFT PARENTHESIS
2284 	 ञ DEVANAGARI LETTER NYA
1982 	 3 DIGIT THREE
1790 	 ३ DEVANAGARI DIGIT THREE
1784 	 फ DEVANAGARI LETTER PHA
1758 	 ङ DEVANAGARI LETTER NGA
1747 	 ठ DEVANAGARI LETTER TTHA
1727 	 4 DIGIT FOUR
1679 	 : COLON
1621 	 ५ DEVANAGARI DIGIT FIVE
1596 	 ४ DEVANAGARI DIGIT FOUR
1585 	 9 DIGIT NINE
1566 	 5 DIGIT FIVE
1555 	 घ DEVANAGARI LETTER GHA
1541 	 छ DEVANAGARI LETTER CHA
1523 	 ८ DEVANAGARI DIGIT EIGHT
1494 	 ७ DEVANAGARI DIGIT SEVEN
1492 	 ६ DEVANAGARI DIGIT SIX
1479 	 7 DIGIT SEVEN
1477 	 8 DIGIT EIGHT
1471 	 6 DIGIT SIX
1445 	 ़ DEVANAGARI SIGN NUKTA
1436 	 ९ DEVANAGARI DIGIT NINE
1343 	 / SOLIDUS
1241 	 ऽ DEVANAGARI SIGN AVAGRAHA
1229 	 ' APOSTROPHE
1188 	 = EQUALS SIGN
1096 	 ; SEMICOLON
893 	 ई DEVANAGARI LETTER II
818 	 ढ DEVANAGARI LETTER DDHA
639 	 ] RIGHT SQUARE BRACKET
607 	 ॒ DEVANAGARI STRESS SIGN ANUDATTA
572 	 [ LEFT SQUARE BRACKET
532 	 > GREATER-THAN SIGN
522 	 ओ DEVANAGARI LETTER O
511 	 ॑ DEVANAGARI STRESS SIGN UDATTA
464 	 ँ DEVANAGARI SIGN CANDRABINDU
458 	 " QUOTATION MARK
440 	 < LESS-THAN SIGN
412 	 + PLUS SIGN
389 	 ॉ DEVANAGARI VOWEL SIGN CANDRA O
386 	 ? QUESTION MARK
384 	 ! EXCLAMATION MARK
362 	 औ DEVANAGARI LETTER AU
326 	 ऋ DEVANAGARI LETTER VOCALIC R
326 	 ऊ DEVANAGARI LETTER UU
318 	 ॐ DEVANAGARI OM
301 	 * ASTERISK
288 	 _ LOW LINE
279 	 $ DOLLAR SIGN
269 	 ” RIGHT DOUBLE QUOTATION MARK
267 	 “ LEFT DOUBLE QUOTATION MARK
263 	 % PERCENT SIGN
263 	 ` GRAVE ACCENT
255 	 @ COMMERCIAL AT
247 	 झ DEVANAGARI LETTER JHA
223 	 ₹ INDIAN RUPEE SIGN
221 	 } RIGHT CURLY BRACKET
209 	 { LEFT CURLY BRACKET
178 	 ~ TILDE
140 	 ꣳ DEVANAGARI SIGN CANDRABINDU VIRAMA
134 	 & AMPERSAND
129 	 # NUMBER SIGN
117 	 ऐ DEVANAGARI LETTER AI
110 	 ^ CIRCUMFLEX ACCENT
94 	 ॰ DEVANAGARI ABBREVIATION SIGN
90 	 • BULLET
86 	 ऑ DEVANAGARI LETTER CANDRA O
85 	 ळ DEVANAGARI LETTER LLA
79 	 § SECTION SIGN
78 	 ऍ DEVANAGARI LETTER CANDRA E
78 	 ‡ DOUBLE DAGGER
75 	 „ DOUBLE LOW-9 QUOTATION MARK
74 	 \ REVERSE SOLIDUS
60 	 … HORIZONTAL ELLIPSIS
12 	 ॄ DEVANAGARI VOWEL SIGN VOCALIC RR
11 	 ॅ DEVANAGARI VOWEL SIGN CANDRA E
```

## Plotting of Character Error Rates

MatPlotLib can be used to visualize the CER from training iterations, checkpoints, evaluation test and validation test. 

### CER from lstmtraining log: 

![Sanskrit PlusMinus Training CER Plot](/plot/sanPlusMinus-plot_cer.png)

### CER from lstmtraining log and lstmeval logs: 

![Sanskrit PlusMinus Training Validation CER Plot](/plot/sanPlusMinus-validate-plot_cer.png)

## To run training on your system

To reproduce above results and run training on your system, you need a latest working version of `tesseract` (use master branch from github for 5.0.0.Alpha or higher). Training to achieve a low CER will take at least a few days. Be patient.

```
git clone --depth 1 https://github.com/Shreeshrii/tesstrain-sanPlusMinus
cd tesstrain-sanPlusMinus
bash TRAIN.sh
```

## To check progress of training

```
cd tesstrain-sanPlusMinus
tail -f plot/sanPlusMinus.LOG
```

## To create CER plots

For plotting you need `python3`, `matplotlib`, `pandas`, `numpy` and other dependencies. Run the following to create the `tsv` files with CER information and the plots. You can run these while the training is running. Preferably, run these after a few hours after starting training so that there is some data to be displayed. Generation of `tsv` data for validation can take a while, specially as training progresses. Be patient.

```
cd tesstrain-sanPlusMinus/plot
make traineddata MODEL_NAME=sanPlusMinus
make MODEL_NAME=sanPlusMinus VALIDATE_LIST=validate
```

At times, you may want to adjust the x and y axis limits on the plots to improve the visual representation. In that case you need not create the tsv files again. Just rerun the python scripts after modifying the required values.

```
cd tesstrain-sanPlusMinus/plot
python plot-eval-validate-cer.py -m sanPlusMinus -v validate
```

## Choosing the Best Model

If the training, eval and validation sets are similar in nature, the minimum CER in all cases will be for the same checkpoint. However, if the validation set is very different from training set or is just one font set from a multitude of fonts used in training then the best model to OCR images similar to the validation set would be the checkpoint with minimum CER for validation set. 
