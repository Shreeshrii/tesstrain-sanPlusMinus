# tesstrain-sanPlusMinus

For training from lstmf files which have already been generated earlier
from images and their ground truth transcription in `gt` directory.

`gt` directory has the groundtruth training data.

Only the `lstmf` files are used by lstmtraining.
*.gt.txt are concatenated to create all-gt which is used for building the unicharset.
*.png and *.gt.txt can be used for checking accuracy OCR evaluation tools.

Other files are there for reference.

`sanPlusMinus` directory has other files downloaded for training
and all generated files.

Generated finetuned traineddata is in `sanPlusMinus` directory.

`sanPlusMinus.log` has the console log from training for reference.
