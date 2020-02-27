#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../.. && pwd )

APP=${PROJECT_PATH}/cmake-build-release/chapter7/outer-ball-estimator/ch7-outer-ball-estimator
DATA_BASE_FOLDER=${SCRIPT_PATH}/data

#H="0.5 0.25 0.125 0.0625"
#R="3 1 0.5"

H="0.1 0.01 0.001"
R="0.5"

DATA_PLOT_FILES=""
for r in $R
do
    for h in $H
    do
        echo "Computing for r=$r and h=$h"
        DATA_OUTPUT_FILE=${DATA_BASE_FOLDER}/R${r}-H${h}.data
        $APP $r $h $o ${DATA_OUTPUT_FILE}
        ${SCRIPT_PATH}/plots.sh "${SCRIPT_PATH}/output" $DATA_OUTPUT_FILE $r $h
    done
done