#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

CELLULAR_GRID_APP=${PROJECT_PATH}/cmake-build-release/chapter5/cellular-grid/ch5-cellular-grid

OUTPUT_FOLDER=${SCRIPT_PATH}/output/cellular-grid
$CELLULAR_GRID_APP $OUTPUT_FOLDER

cp ${SCRIPT_PATH}/input/flower.png ${OUTPUT_FOLDER}/flower.png
epstopdf ${OUTPUT_FOLDER}/cellular-grid-illustration.eps
rm ${OUTPUT_FOLDER}/cellular-grid-illustration.eps


