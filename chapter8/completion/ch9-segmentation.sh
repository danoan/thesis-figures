#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

INPUT_FOLDER=${SCRIPT_PATH}/input
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/completion
DATA_FOLDER=${SCRIPT_PATH}/data

exp_long_snake()
{
    alpha="0.01"
    beta="1.0"
    lb="3.0"
    lr="3.0"
    it=200
    RADIUS="3 5"

    GRAPH_DATA="${DATA_FOLDER}/graphseg"
    GRAPH_OUT="${BASE_OUTPUT_FOLDER}/graphseg"
    GRAPH_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/graph-seg-app

    for radius in $RADIUS
    do
        REL_PATH="alpha-${alpha}/beta-${beta}/gamma-${lr}/radius-${radius}"

        $( $GRAPH_APP -r${radius} -i${it} -eelastica -h0.25 -d0 -a${alpha} -g${lr} -b${lb} -k${beta} ${INPUT_FOLDER}/long-snake.xml "${GRAPH_DATA}/${REL_PATH}" && \
        mkdir -p ${GRAPH_OUT}/${REL_PATH} && \
        cp ${GRAPH_DATA}/${REL_PATH}/corrected-seg.png ${GRAPH_OUT}/${REL_PATH}/corrected-seg.png)
    done


    alpha="0.0"
    beta="0.0"
    REL_PATH="alpha-${alpha}/beta-${beta}/gamma-${lr}/radius-${radius}"

    $( $GRAPH_APP -r${radius} -i${it} -eelastica -h0.25 -d0 -a${alpha} -g${lr} -b${lb} -k${beta} ${INPUT_FOLDER}/long-snake.xml "${GRAPH_DATA}/${REL_PATH}" && \
    mkdir -p ${GRAPH_OUT}/${REL_PATH} && \
    cp ${GRAPH_DATA}/${REL_PATH}/corrected-seg.png ${GRAPH_OUT}/${REL_PATH}/corrected-seg.png)


    alpha="0.0"
    beta="0.0"
    REL_PATH="G10/alpha-${alpha}/beta-${beta}/gamma-${lr}/radius-${radius}"

    $( $GRAPH_APP -r${radius} -i1 -eelastica -h0.25 -d0 -a${alpha} -g${lr} -b${lb} -k${beta} ${INPUT_FOLDER}/long-snake.xml -G10 "${GRAPH_DATA}/${REL_PATH}" && \
    mkdir -p ${GRAPH_OUT}/${REL_PATH} && \
    cp ${GRAPH_DATA}/${REL_PATH}/gc-seg.png ${GRAPH_OUT}/${REL_PATH}/gc-seg.png)

}

exp_long_snake



