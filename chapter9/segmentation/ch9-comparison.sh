#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

INPUT_FOLDER=${SCRIPT_PATH}/input

BASE_DATA_FOLDER=${SCRIPT_PATH}/data/comparison
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/segmentation/comparison

INPUT_NAME="airplane birds brown-snake camel coala eagle green-snake kite-surf long-snake man-hat mans-music mushroom peacock statues tiger"

exp_comparison()
{
    g_alpha="0.0002"
    g_beta="1.0"
    g_gamma="1.0"

    f_alpha="0.5"
    f_beta="1.0"
    f_gamma="1.0"

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
        F_REL_PATH="${input}/alpha-${f_alpha}/beta-${f_beta}/gamma-${f_gamma}/radius-${radius}"
	G_REL_PATH="${input}/alpha-${g_alpha}/beta-${g_beta}/gamma-${g_gamma}/radius-${radius}"

        $( $FLIP_APP -r${radius} -i${it} -l-2 -q${f_beta} -t${f_gamma} -g${f_alpha} -mimprove -d0 -o "${FLIP_DATA}/${F_REL_PATH}" ${INPUT_FOLDER}/${input}.xml && \
        mkdir -p ${FLIP_OUT}/${F_REL_PATH} && \
        cp ${FLIP_DATA}/${F_REL_PATH}/corrected-seg.png ${FLIP_OUT}/${F_REL_PATH}/corrected-seg.png && \
        cp ${FLIP_DATA}/${F_REL_PATH}/gc-seg.png ${FLIP_OUT}/${F_REL_PATH}/gc-seg.png)&

        $( $BALANCE_APP -r${radius} -i${it} -l-2 -q${f_beta} -t${f_gamma} -g${f_alpha} -mimprove -O1 -d0 -o "${BALANCE_DATA}/${F_REL_PATH}" ${INPUT_FOLDER}/${input}.xml && \
        mkdir -p ${BALANCE_OUT}/${F_REL_PATH} && \
        cp ${BALANCE_DATA}/${F_REL_PATH}/corrected-seg.png ${BALANCE_OUT}/${F_REL_PATH}/corrected-seg.png)


        $( $GRAPH_APP -r${radius} -i${it} -eelastica -h1.0 -d0 -a${g_alpha} -g${g_gamma} -b${g_gamma} -k${g_beta} ${INPUT_FOLDER}/${input}.xml "${GRAPH_DATA}/${G_REL_PATH}" && \
        mkdir -p ${GRAPH_OUT}/${G_REL_PATH} && \
        cp ${GRAPH_DATA}/${G_REL_PATH}/corrected-seg.png ${GRAPH_OUT}/${G_REL_PATH}/corrected-seg.png)&


    done

}

exp_comparison



