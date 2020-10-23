#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../.. && pwd)

source ${PROJECT_PATH}/slides/utils.sh

APP_GRAPH_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/graph-flow-v0.2/bin/graph-flow-app
APP_SUMMARY_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow

DATA_OUTPUT_FOLDER=${SCRIPT_PATH}/data
mkdir -p ${DATA_OUTPUT_FOLDER}

OUTPUT_FOLDER=${SCRIPT_PATH}/output/no-neighborhood-flow
mkdir -p ${OUTPUT_FOLDER}

#Optimum radius = 22
ALPHA="0.0020661157"
ropt=$( python3 -c "print('{}'.format(1.0/pow($ALPHA,0.5)))" )

SHAPES="triangle square flower bean"
for SHAPE in ${SHAPES}
do
    $APP_GRAPH_FLOW -S${SHAPE} -h0.125 -b1 -a${ALPHA} -r16 -v5 -O2 -N0 -n4 -i500 -B30 -s ${DATA_OUTPUT_FOLDER}/${SHAPE}
    $APP_SUMMARY_FLOW ${DATA_OUTPUT_FOLDER}/${SHAPE} ${DATA_OUTPUT_FOLDER}/${SHAPE}/summary.eps -j10 -e.png

    cp ${DATA_OUTPUT_FOLDER}/${SHAPE}/summary.eps ${OUTPUT_FOLDER}/${SHAPE}.eps
    convert_to_png ${OUTPUT_FOLDER}/${SHAPE}.eps ${OUTPUT_FOLDER}/${SHAPE}.png
    rm ${OUTPUT_FOLDER}/${SHAPE}.eps
done