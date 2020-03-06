#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd )
AUX_SCRIPT_PATH=$( cd $SCRIPT_PATH && cd ../aux-scripts && pwd )

DATA_BASE_FOLDER=${SCRIPT_PATH}/data
OUTPUT_BASE_FOLDER=${SCRIPT_PATH}/output/resolution-shrinking

SHAPE_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/shape-flow
SUMMARY_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/summary-flow

shape_flow()
{
    shape=$1
    level=$2

    H="1.0 0.5 0.25 0.125 0.0625"
    for h in $H
    do
        DATA_FOLDER="${DATA_BASE_FOLDER}/$shape/level-$level/gs-$h"
        mkdir -p ${DATA_FOLDER}
        $SHAPE_FLOW_APP -r5 -i10 -l$level -p double -n4 -q1 -t0 -g0 -mimprove -S$shape -h$h ${DATA_FOLDER}&
    done

    wait
}

shape_flow ball 5&
shape_flow ball 4&
shape_flow ball 3


${AUX_SCRIPT_PATH}/summary-flow.sh $SUMMARY_FLOW_APP $DATA_BASE_FOLDER 10
${AUX_SCRIPT_PATH}/move-convert-eps.sh $DATA_BASE_FOLDER $OUTPUT_BASE_FOLDER


