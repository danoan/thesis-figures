#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd )
AUX_SCRIPT_PATH=$( cd $SCRIPT_PATH && cd ../aux-scripts && pwd )

DATA_BASE_FOLDER=${SCRIPT_PATH}/data
OUTPUT_BASE_FOLDER=${SCRIPT_PATH}/output/radius-effect

SHAPE_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/shape-flow
SUMMARY_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/summary-flow
IMAGE_ESTIMATOR_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/app-image-estimator
GET_PATH=${SCRIPT_PATH}/get-path.sh

shape_flow()
{
    shape=$1
    lp=$2
    method=$3

    R="3 5 9"
    for r in $R
    do
        DATA_FOLDER=${DATA_BASE_FOLDER}/$( $GET_PATH $shape $lp $method $r )
        mkdir -p ${DATA_FOLDER}
        $SHAPE_FLOW_APP -r$r -i1000 -l0 -p double-opt -n4 -q1 -t0 -g$lp -m$method -S$shape -h0.25 ${DATA_FOLDER} && \
        ${IMAGE_ESTIMATOR_APP} -mall-in-folder -f ${DATA_FOLDER} -esqc-ii -h0.25 -r5 -a$lp | sort > ${DATA_FOLDER}/ii.txt &
    done

    wait
}

experiment_sequence()
{
    shape=$1
    method=$2

    shape_flow $shape 0 $method &
    shape_flow $shape 0.5 $method &
    shape_flow $shape 1.0 $method
}

experiment_sequence triangle improve &
experiment_sequence flower improve

experiment_sequence triangle probe &
experiment_sequence flower probe

${AUX_SCRIPT_PATH}/summary-flow.sh $SUMMARY_FLOW_APP $DATA_BASE_FOLDER
${SCRIPT_PATH}/plots.sh "$DATA_BASE_FOLDER" "$DATA_BASE_FOLDER"

${AUX_SCRIPT_PATH}/move-convert-eps.sh "$DATA_BASE_FOLDER" "$OUTPUT_BASE_FOLDER" summary.eps
${AUX_SCRIPT_PATH}/move-convert-eps.sh "$DATA_BASE_FOLDER" "$OUTPUT_BASE_FOLDER" radius-effect.eps


