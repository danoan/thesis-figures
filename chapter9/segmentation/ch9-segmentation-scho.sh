#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

INPUT_FOLDER=${SCRIPT_PATH}/instance-generator/input

BASE_DATA_FOLDER=${SCRIPT_PATH}/instance-generator/data/comparison
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/segmentation/comparison

INPUT_NAME="airplane birds brown-snake camel coala eagle green-snake kite-surf long-snake man-hat mans-music mushroom peacock statues tiger"

exp_comparison()
{
    alpha="0.01"
    beta="1.0"
    lb="3.0"
    lr="3.0"
    it=200
    radius="7"

    FLIP_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/boundary-correction-app
    BALANCE_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/boundary-correction-app
    GRAPH_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/graph-seg-app

    FLIP_DATA="${BASE_DATA_FOLDER}/flipseg"
    BALANCE_DATA="${BASE_DATA_FOLDER}/balanceseg"
    GRAPH_DATA="${BASE_DATA_FOLDER}/graphseg"

    FLIP_OUT="${BASE_OUTPUT_FOLDER}/flipseg"
    BALANCE_OUT="${BASE_OUTPUT_FOLDER}/balanceseg"
    GRAPH_OUT="${BASE_OUTPUT_FOLDER}/graphseg"

    for input in $INPUT_NAME
    do
        REL_PATH="${input}/alpha-${alpha}/beta-${beta}/gamma-${lr}/radius-${radius}"

        $( $FLIP_APP -r${radius} -i${it} -l-2 -q${beta} -t${lr} -g${alpha} -mimprove -d0 -o "${FLIP_DATA}/${REL_PATH}" ${INPUT_FOLDER}/${input}.xml && \
        mkdir -p ${FLIP_OUT}/${REL_PATH} && \
        cp ${FLIP_DATA}/${REL_PATH}/corrected-seg.png ${FLIP_OUT}/${REL_PATH}/corrected-seg.png && \
        cp ${FLIP_DATA}/${REL_PATH}/gc-seg.png ${FLIP_OUT}/${REL_PATH}/gc-seg.png)&

        $( $BALANCE_APP -r${radius} -i${it} -l-2 -q${beta} -t${lr} -g${alpha} -mimprove -O1 -d0 -o "${BALANCE_DATA}/${REL_PATH}" ${INPUT_FOLDER}/${input}.xml && \
        mkdir -p ${BALANCE_OUT}/${REL_PATH} && \
        cp ${BALANCE_DATA}/${REL_PATH}/corrected-seg.png ${BALANCE_OUT}/${REL_PATH}/corrected-seg.png)


        $( $GRAPH_APP -r${radius} -i${it} -eelastica -h0.25 -d0 -a${alpha} -g${lr} -b${lb} -k${beta} ${INPUT_FOLDER}/${input}.xml "${GRAPH_DATA}/${REL_PATH}" && \
        mkdir -p ${GRAPH_OUT}/${REL_PATH} && \
        cp ${GRAPH_DATA}/${REL_PATH}/corrected-seg.png ${GRAPH_OUT}/${REL_PATH}/corrected-seg.png)&


    done

}

exp_comparison



