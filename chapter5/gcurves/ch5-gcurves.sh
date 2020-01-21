#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

DATA_OUTPUT_FOLDER=${SCRIPT_PATH}/data
OUTPUT_FOLDER=${SCRIPT_PATH}/output/gcurves

mkdir -p ${OUTPUT_FOLDER}/gc

GCURVES_APP=${PROJECT_PATH}/cmake-build-release/chapter5/gcurves/ch5-gcurves
$GCURVES_APP $DATA_OUTPUT_FOLDER

move_data()
{
    while [ -n "$1" ]
    do
        origin=$1; shift;
        destiny=$1; shift;

        mv ${DATA_OUTPUT_FOLDER}/gc/${origin}.eps ${OUTPUT_FOLDER}/gc/${destiny}.eps
    done
}

move_data 1 main-inner 65 inner-main 117 main-outer 197 outer-main
mv ${DATA_OUTPUT_FOLDER}/distance-transform.eps ${OUTPUT_FOLDER}/distance-transform.eps

find $OUTPUT_FOLDER -name "*.eps" | xargs -I{} epstopdf {}
find $OUTPUT_FOLDER -name "*.eps" | xargs -I{} rm {}



