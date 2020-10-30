#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../.. && pwd)

source ${PROJECT_PATH}/slides/utils.sh

APP_GRAPH_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/graph-flow-v0.2/bin/graph-flow-app
APP_SUMMARY_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow

DATA_OUTPUT_FOLDER=${SCRIPT_PATH}/data
mkdir -p ${DATA_OUTPUT_FOLDER}

OUTPUT_FOLDER=${SCRIPT_PATH}/output/no-neighborhood-flow-always-evolve
mkdir -p ${OUTPUT_FOLDER}

flow()
{
    ALPHA=$1
    ropt=$( python3 -c "print('{}'.format(1.0/pow($ALPHA,0.5)))" )

# For bean I should change the code to avoid premature stop in case difference between iterations is small (graph-flow.hpp)
    SHAPES="triangle square flower bean"
    for SHAPE in ${SHAPES}
    do
        FLOW_OUTPUT_FOLDER="${DATA_OUTPUT_FOLDER}/${SHAPE}/${ALPHA}"
        $APP_GRAPH_FLOW -S${SHAPE} -h0.125 -b1 -a${ALPHA} -r16 -v5 -O2 -N0 -n4 -i500 -B30 -s ${FLOW_OUTPUT_FOLDER}
        $APP_SUMMARY_FLOW ${FLOW_OUTPUT_FOLDER} ${FLOW_OUTPUT_FOLDER}/summary.eps -j10 -r${ropt} -h0.125 -e.png

        RESULTS_OUTPUT_FOLDER="${OUTPUT_FOLDER}/${ALPHA}"
        mkdir -p ${RESULTS_OUTPUT_FOLDER}
        cp ${FLOW_OUTPUT_FOLDER}/summary.eps ${RESULTS_OUTPUT_FOLDER}/${SHAPE}.eps
        convert_to_png ${RESULTS_OUTPUT_FOLDER}/${SHAPE}.eps ${RESULTS_OUTPUT_FOLDER}/${SHAPE}.png
        rm ${RESULTS_OUTPUT_FOLDER}/${SHAPE}.eps
    done
}

flow "0.0020661157"
flow "0.015625"