#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../.. && pwd )

APP=${PROJECT_PATH}/cmake-build-release/chapter7/outer-ball-estimator/ch7-outer-ball-estimator
DATA_BASE_FOLDER=${SCRIPT_PATH}/data


run_sequence()
{

    SHAPE=$1;shift;
    ER=$1; shift;
    R=$1; shift;
    ORDER=$1; shift;
    ET=$1; shift;

    DATA_PLOT_FILES=""
    while [ -n "$1" ]
    do
        h=$1; shift;
        echo "Computing for ${SHAPE^} ER=$ER r=$R and h=$h"
        DATA_OUTPUT_FILE=${DATA_BASE_FOLDER}/ET-${ET}-O${ORDER}/${SHAPE^}-ER-$ER-R${R}-H${h}.data
        $APP $SHAPE $ER $R $h $ORDER $ET ${DATA_OUTPUT_FILE}
        ${SCRIPT_PATH}/plots.sh "${SCRIPT_PATH}/output/ET-${ET}-O${ORDER}/${SHAPE^}-ER-$ER" $DATA_OUTPUT_FILE $R $h
    done
}

run_sequence ball 5 2 8 half_r 1.0  0.5 0.25 0.125 0.0625 0.03125&
run_sequence ball 5 1 8 half_r1.0 0.5 0.25 0.125 0.0625 0.03125 0.015125&
run_sequence ball 5 0.5 8 half_r 0.50.25 0.125 0.0625 0.03125 0.015125 0.0075625 0.001&


run_sequence flower 10 5 8 half_r 1.00.5 0.25 0.125 0.0625 0.03125&
run_sequence flower 10 3 8 half_r 1.0 0.5 0.25 0.125 0.0625 0.03125&
run_sequence flower 10 1 8 half_r 1.0 0.5 0.25 0.125 0.0625 0.03125 0.015125&
run_sequence flower 10 0.5 8 half_r 0.5 0.25 0.125 0.0625 0.03125 0.015125 0.0075625
