#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../.. && pwd)

source ${PROJECT_PATH}/slides/utils.sh

APP_GRAPH_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/graph-flow-v0.2/bin/graph-flow-app
APP_SUMMARY_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow

DATA_OUTPUT_FOLDER=${SCRIPT_PATH}/data
mkdir -p ${DATA_OUTPUT_FOLDER}

OUTPUT_FOLDER=${SCRIPT_PATH}/output/with-neighborhood-flow
mkdir -p ${OUTPUT_FOLDER}

#Optimum radius = 22
ALPHA="0.0020661157"
ropt=$( python3 -c "print('{}'.format(1.0/pow($ALPHA,0.5)))" )

SHAPES="triangle square flower bean"
for SHAPE in ${SHAPES}
do
    $APP_GRAPH_FLOW -S${SHAPE} -h0.125 -b1 -a${ALPHA} -r5 -v5 -O2 -N2 -n8 -i500 -B30 -s ${DATA_OUTPUT_FOLDER}/${SHAPE}/radius_5
    $APP_SUMMARY_FLOW ${DATA_OUTPUT_FOLDER}/${SHAPE}/radius_5 ${DATA_OUTPUT_FOLDER}/${SHAPE}/radius_5/summary.eps -j10 -e.png -r${ropt} -h0.125

    mkdir -p "${OUTPUT_FOLDER}/radius_5"

    cp ${DATA_OUTPUT_FOLDER}/${SHAPE}/radius_5/summary.eps ${OUTPUT_FOLDER}/radius_5/${SHAPE}.eps
    convert_to_png ${OUTPUT_FOLDER}/radius_5/${SHAPE}.eps ${OUTPUT_FOLDER}/radius_5/${SHAPE}.png
    rm ${OUTPUT_FOLDER}/radius_5/${SHAPE}.eps
done

for SHAPE in ${SHAPES}
do
    $APP_GRAPH_FLOW -S${SHAPE} -h0.125 -b1 -a${ALPHA} -r16 -v5 -O2 -N2 -n8 -i500 -B30 -s ${DATA_OUTPUT_FOLDER}/${SHAPE}/radius_16
    $APP_SUMMARY_FLOW ${DATA_OUTPUT_FOLDER}/${SHAPE}/radius_16 ${DATA_OUTPUT_FOLDER}/${SHAPE}/radius_16/summary.eps -j10 -e.png -r${ropt} -h0.125

    mkdir -p "${OUTPUT_FOLDER}/radius_16"

    cp ${DATA_OUTPUT_FOLDER}/${SHAPE}/radius_16/summary.eps ${OUTPUT_FOLDER}/radius_16/${SHAPE}.eps
    convert_to_png ${OUTPUT_FOLDER}/radius_16/${SHAPE}.eps ${OUTPUT_FOLDER}/radius_16/${SHAPE}.png
    rm ${OUTPUT_FOLDER}/radius_16/${SHAPE}.eps
done