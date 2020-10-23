#!/usr/bin/env bash

function convert_to_png(){
    INPUT_FILE=$1
    OUTPUT_FILE=$2

    convert -density 100 -depth 8 -quality 85 ${INPUT_FILE} ${OUTPUT_FILE}
}