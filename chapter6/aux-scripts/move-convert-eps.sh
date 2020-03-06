#!/usr/bin/env bash

DATA_FOLDER=$(realpath $1)
OUTPUT_FOLDER=$2
FILENAME=$3

find $DATA_FOLDER -name "*.eps" | \
xargs -I {} bash -c 'echo $(dirname "{}")' | \
xargs -I {} realpath --relative-to $DATA_FOLDER {} | \
xargs -I{} bash -c "mkdir -p $OUTPUT_FOLDER/{} && mv $DATA_FOLDER/{}/${FILENAME} $OUTPUT_FOLDER/{}/${FILENAME}"

find $OUTPUT_FOLDER -name *.eps | xargs -I{} epstopdf {}
find ${OUTPUT_FOLDER} -name "*.eps" | xargs -I{} rm {}
