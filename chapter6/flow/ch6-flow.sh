#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd )
AUX_SCRIPT_PATH=$( cd $SCRIPT_PATH && cd ../aux-scripts && pwd )

DATA_BASE_FOLDER=${SCRIPT_PATH}/data
OUTPUT_BASE_FOLDER=${SCRIPT_PATH}/output/flow

SHAPE_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/shape-flow
SUMMARY_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/summary-flow

shape_flow()
{
    shape=$1
    method=$2
    level=$3

    H="1.0 0.5 0.25"
    for h in $H
    do
        DATA_FOLDER="${DATA_BASE_FOLDER}/$shape/$method/level-$level/gs-$h"
        mkdir -p ${DATA_FOLDER}
        $SHAPE_FLOW_APP -r5 -i1000 -l$level -p double -n4 -q1 -t0 -g0 -m$method -S$shape -h$h ${DATA_FOLDER}&
    done

    wait
}


shape_flow triangle improve 5 &
shape_flow square improve 5 &
shape_flow flower improve 5 &
shape_flow bean improve 5 &
shape_flow ellipse improve 5 &

shape_flow triangle improve 4 &
shape_flow square improve 4 &
shape_flow flower improve 4 &
shape_flow bean improve 4 &
shape_flow ellipse improve 4


${AUX_SCRIPT_PATH}/summary-flow.sh $SUMMARY_FLOW_APP $DATA_BASE_FOLDER 10
${AUX_SCRIPT_PATH}/move-convert-eps.sh $DATA_BASE_FOLDER $OUTPUT_BASE_FOLDER


