#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )

source "${ROOT_FOLDER}/plot-scripts/graph-plot.sh"

DATA_FOLDER=$(realpath $1)
OUTPUT_FILEPATH=$2

$(mkdir -p $(dirname $OUTPUT_FILEPATH) )

create_multiplot "$OUTPUT_FILEPATH" "Balance Coefficients Evolution" \
"${DATA_FOLDER}/inner.txt" "Inner" \
"${DATA_FOLDER}/outer.txt" "Outer"

