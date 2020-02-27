#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

APP_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/graph-flow-app
APP_SUMMARY_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow

LEN_PEN="0.1 0.01 0.001"

INPUT_FOLDER=${SCRIPT_PATH}/input

BASE_DATA_FOLDER=${SCRIPT_PATH}/data
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/constrained-elastica

for lp in $LEN_PEN
do
    IN_FOLDER=${INPUT_FOLDER}/curve-3
    DATA_FOLDER=${BASE_DATA_FOLDER}/curve-3/lp-${lp}
    OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/curve-3/lp-${lp}

    mkdir -p ${DATA_FOLDER}
    mkdir -p ${OUTPUT_FOLDER}

    $APP_FLOW -S${IN_FOLDER}/input.pgm -i100 -N0 -r7 -a${lp} -P${IN_FOLDER}/pixelMask.pgm ${DATA_FOLDER}
    $APP_SUMMARY_FLOW ${DATA_FOLDER} -p${IN_FOLDER}/pixelMaskBig.pgm -d${IN_FOLDER}/dirMask.pgm ${OUTPUT_FOLDER}/summary.eps

    epstopdf ${OUTPUT_FOLDER}/summary.eps
    rm ${OUTPUT_FOLDER}/summary.eps
done

for lp in $LEN_PEN
do
    IN_FOLDER=${INPUT_FOLDER}/flower-1
    DATA_FOLDER=${BASE_DATA_FOLDER}/flower-1/lp-${lp}
    OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/flower-1/lp-${lp}

    mkdir -p ${DATA_FOLDER}
    mkdir -p ${OUTPUT_FOLDER}

    $APP_FLOW -S${IN_FOLDER}/input.pgm -i100 -N0 -h1 -P${IN_FOLDER}/pixelMask.pgm ${DATA_FOLDER}
    $APP_SUMMARY_FLOW ${DATA_FOLDER} -d${IN_FOLDER}/pixelMask.pgm ${OUTPUT_FOLDER}/summary.eps

    epstopdf ${OUTPUT_FOLDER}/summary.eps
    rm ${OUTPUT_FOLDER}/summary.eps
done

