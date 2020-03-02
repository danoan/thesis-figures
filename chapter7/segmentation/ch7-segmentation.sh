#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

BC_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/boundary-correction-app

BASE_DATA_FOLDER=${SCRIPT_PATH}/data
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/segmentation

INPUT_FOLDER=${SCRIPT_PATH}/input

CURVATURE="0.0 1.0"
for k in $CURVATURE
do
    DATA_FOLDER=${BASE_DATA_FOLDER}/coala/k-${k}
    OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/coala/k-${k}

    mkdir -p $DATA_FOLDER
    mkdir -p $OUTPUT_FOLDER

    $BC_APP -r5 -i50 -q${k} -t0.5 -g2.0 -l-1 -O1 ${INPUT_FOLDER}/coala.xml -o $DATA_FOLDER

    cp ${DATA_FOLDER}/gc-seg.png ${OUTPUT_FOLDER}/gc-seg.png
    cp ${DATA_FOLDER}/corrected-seg.png ${OUTPUT_FOLDER}/corrected-seg.png
done