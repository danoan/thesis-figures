#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/shape-flow
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow


BASE_DATA_FOLDER=${SCRIPT_PATH}/data
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/potential-flow

RADIUS="9"
LEVELS="-3"
SHAPE="triangle flower bean"

flow_and_summary()
{
    r=$1
    level=$2
    shape=$3
    DATA_FOLDER=$4
    OUTPUT_FOLDER=$5

    mkdir -p $DATA_FOLDER
    mkdir -p $OUTPUT_FOLDER

    ${FLOW_APP} -r${r} -l${level} -i200 -q1 -t0 -g0 -S${shape} -h0.25 -faround-contour -O1 $DATA_FOLDER
    ${SUMMARY_APP} $DATA_FOLDER ${OUTPUT_FOLDER}/summary.eps -j10

    epstopdf ${OUTPUT_FOLDER}/summary.eps
    rm ${OUTPUT_FOLDER}/summary.eps

    cp ${DATA_FOLDER}/input-data.txt ${OUTPUT_FOLDER}/input-data.txt
}


for r in $RADIUS
do
    for shape in $SHAPE
    do
        for level in $LEVELS
        do
            DATA_FOLDER=${BASE_DATA_FOLDER}/${shape}/radius-${r}/level-${level}
            OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/${shape}

            flow_and_summary $r $level $shape $DATA_FOLDER $OUTPUT_FOLDER&
        done
    done
done