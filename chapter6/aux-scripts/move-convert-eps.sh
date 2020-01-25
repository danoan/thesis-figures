#!/usr/bin/env bash

DATA_FOLDER=$(realpath $1)
OUTPUT_FOLDER=$2

find $DATA_FOLDER -name "*.eps" | \
xargs -I {} realpath --relative-to $DATA_FOLDER {} | \
xargs -I{} bash -c "mkdir -p $OUTPUT_FOLDER/$( dirname {} ) && mv $DATA_FOLDER/{} $OUTPUT_FOLDER/{}"

find $OUTPUT_FOLDER -name *.eps | xargs -I{} epstopdf {}
find ${OUTPUT_FOLDER} -name "*.eps" | xargs -I{} rm {}
