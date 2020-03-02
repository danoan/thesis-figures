#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

INPUT_FOLDER=${SCRIPT_PATH}/input
BASE_DATA_FOLDER=${SCRIPT_PATH}/data
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/segmentation

GRAPH_SEG_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/graph-seg-app

CURVATURE="0.0 1.0"

for k in $CURVATURE
do
    DATA_FOLDER=${BASE_DATA_FOLDER}/coala/k-${k}
    OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/coala/k-${k}

    mkdir -p $DATA_FOLDER
    mkdir -p $OUTPUT_FOLDER

    $GRAPH_SEG_APP -i-1 -r9 -h0.25 -a0.5 -g2.0 -b2.0 -k${k} -O3 -n8 -N3 ${INPUT_FOLDER}/coala.xml ${DATA_FOLDER}

    cp ${DATA_FOLDER}/energy.txt ${OUTPUT_FOLDER}/energy.txt
    cp ${DATA_FOLDER}/inputData.txt ${OUTPUT_FOLDER}/inputData.txt
    cp ${DATA_FOLDER}/gc-seg.png ${OUTPUT_FOLDER}/gc-seg.png
    cp ${DATA_FOLDER}/corrected-seg.png ${OUTPUT_FOLDER}/corrected-seg.png
    cp ${DATA_FOLDER}/seeds.png ${OUTPUT_FOLDER}/seeds.png

done



