#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )

SHAPE_FLOW_APP=${ROOT_FOLDER}/ext-projects/cmake-build-release/bin/shape-flow
SUMMARY_FLOW_APP=${ROOT_FOLDER}/ext-projects/cmake-build-release/bin/summary-flow

function flow()
{
    SHAPE=$1
    GRID_STEP=$2
    FACTOR=$3
    PREFIX=$4
    UNIFORM=$5

    RADIUS=$(( 3*${FACTOR} ))
    LEVEL=$(( ${RADIUS}-2 ))
    OUTPUT_FOLDER=${SCRIPT_PATH}/output/$PREFIX/$SHAPE/h${GRID_STEP}

    if [ -z $UNIFORM ]
    then
        OUTPUT_FOLDER=${OUTPUT_FOLDER}/nonUniform
    else
        OUTPUT_FOLDER=${OUTPUT_FOLDER}/Uniform
    fi

    $SHAPE_FLOW_APP -i400 -r$RADIUS -l$LEVEL -q1 -t0 -g0 -S $SHAPE -h$GRID_STEP -faround-contour $UNIFORM -O1 $OUTPUT_FOLDER
    $SUMMARY_FLOW_APP $OUTPUT_FOLDER ${OUTPUT_FOLDER}/summary.eps -j10

    $( cd $OUTPUT_FOLDER && mogrify -format png *.pgm && rm *.pgm )
}



function flow_prop()
{
    SHAPE=$1
    GRID_STEP=$2
    FACTOR=$3
    PREFIX=$4
    UNIFORM=$5

    RADIUS=$(( 3*${FACTOR} ))
    LEVEL=$(( ${RADIUS}-${FACTOR} ))
    OUTPUT_FOLDER=${SCRIPT_PATH}/output/$PREFIX/$SHAPE/h${GRID_STEP}

    if [ -z $UNIFORM ]
    then
        OUTPUT_FOLDER=${OUTPUT_FOLDER}/nonUniform
    else
        OUTPUT_FOLDER=${OUTPUT_FOLDER}/Uniform
    fi

    $SHAPE_FLOW_APP -i400 -r$RADIUS -l$LEVEL -q1 -t0 -g0 -S $SHAPE -h$GRID_STEP -faround-contour $UNIFORM -O1 $OUTPUT_FOLDER
    $SUMMARY_FLOW_APP $OUTPUT_FOLDER ${OUTPUT_FOLDER}/summary.eps -j10

    $( cd $OUTPUT_FOLDER && mogrify -format png *.pgm && rm *.pgm )
}