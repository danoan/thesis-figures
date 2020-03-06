#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd )
AUX_SCRIPT_PATH=$( cd $SCRIPT_PATH && cd ../aux-scripts && pwd )

DATA_BASE_FOLDER=${SCRIPT_PATH}/data
OUTPUT_BASE_FOLDER=${SCRIPT_PATH}/output/level-effect

SHAPE_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/shape-flow
SUMMARY_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/summary-flow
IMAGE_ESTIMATOR_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/app-image-estimator
GET_PATH=${SCRIPT_PATH}/get-path.sh

shape_flow()
{
    shape=$1; shift;
    lp=$1; shift;
    method=$1; shift
    radius=$1; shift;

    while [ -n "$1" ]
    do
        level=$1; shift;
        DATA_FOLDER="${DATA_BASE_FOLDER}/$( $GET_PATH $shape $method $lp $radius $level )"
        mkdir -p ${DATA_FOLDER}
        $SHAPE_FLOW_APP -r$radius -i1000 -l$level -p double -n4 -q1 -t0 -g$lp -m$method -S$shape -h0.25 ${DATA_FOLDER} && \
        ${IMAGE_ESTIMATOR_APP} -mall-in-folder -f ${DATA_FOLDER} -esqc-ii -h0.25 -r5 -a$lp | sort > ${DATA_FOLDER}/ii.txt &
    done

    wait
}

experiment_sequence()
{
    shape=$1
    method=$2

    shape_flow $shape 0 $method 3 1 2 3 &
    shape_flow $shape 0 $method 5 1 3 4 5 &
    shape_flow $shape 0 $method 9 1 3 5 7 8 9 &

    shape_flow $shape 0.5 $method 3 1 2 3 &
    shape_flow $shape 0.5 $method 5 1 3 4 5 &
    shape_flow $shape 0.5 $method 9 1 3 5 7 8 9

}


experiment_sequence triangle improve&
experiment_sequence square improve&
experiment_sequence ellipse improve&
experiment_sequence bean improve&
experiment_sequence flower improve


${AUX_SCRIPT_PATH}/summary-flow.sh $SUMMARY_FLOW_APP $DATA_BASE_FOLDER 10
${SCRIPT_PATH}/plots.sh "$DATA_BASE_FOLDER" "$DATA_BASE_FOLDER"
${AUX_SCRIPT_PATH}/move-convert-eps.sh $DATA_BASE_FOLDER $OUTPUT_BASE_FOLDER




