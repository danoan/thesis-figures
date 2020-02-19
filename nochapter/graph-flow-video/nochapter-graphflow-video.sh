#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

GRAPH_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/graph-flow-app
DATA_FOLDER=${SCRIPT_PATH}/data

CACHE_TEMP_PATH=/home/dantu/temp
SHAPES="square triangle flower bean"
SHAPESR5="square triangle"
SHAPESR9="flower bean"

for s in $SHAPESR5
do
    echo "Executing flow for shape ${s^}"
    ${GRAPH_FLOW_APP} -S$s -i500 -n10 -r5  ${DATA_FOLDER}/${s}&
done

for s in $SHAPESR9
do
    echo "Executing flow for shape ${s^}"
    ${GRAPH_FLOW_APP} -S$s -i500 -n10 -r9  ${DATA_FOLDER}/${s}&
done

wait

for s in $SHAPES
do
    OUTPUT_FOLDER=${SCRIPT_PATH}/output
    ${SCRIPT_PATH}/make-plot-frames.sh ${s} ${OUTPUT_FOLDER} ${CACHE_TEMP_PATH}

    ${SCRIPT_PATH}/join-gifs.sh ${OUTPUT_FOLDER}/${s}/flow.gif ${OUTPUT_FOLDER}/${s}/plot.gif ${s} ${OUTPUT_FOLDER}/${s}/flow-plot.gif ${CACHE_TEMP_PATH}
done