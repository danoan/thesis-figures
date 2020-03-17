#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

INPUT_FOLDER=${SCRIPT_PATH}/instance-generator/input
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/segmentation

DATA_GENERATOR=${SCRIPT_PATH}/instance-generator/generator.py
DATA_FOLDER=${SCRIPT_PATH}/instance-generator/data

python3 ${DATA_GENERATOR}

get_path()
{
    h=$1
    dalpha=$2
    neigh=$3
    alpha=$4
    beta=$5
    lb=$6
    lr=$7

    echo "h-${h}/dalpha-${dalpha}/neigh-${neigh}/alpha-${alpha}/beta-${beta}/lb-${lb}/lr-${lr}/coala"
}

export_files()
{
    h=$1
    dalpha=$2
    alpha=$3
    beta=$4
    lb=$5
    lr=$6
    prefix=$7

    rel_path_1="$(get_path $h $dalpha 0 $alpha $beta $lb $lr)"
    rel_path_2="$(get_path $h $dalpha 2 $alpha $beta $lb $lr)"

    FLIP_OUT="${BASE_OUTPUT_FOLDER}/${prefix}/flipseg/${rel_path_1}"
    BALANCE_OUT="${BASE_OUTPUT_FOLDER}/${prefix}/balanceseg/${rel_path_1}"
    GRAPH_OUT="${BASE_OUTPUT_FOLDER}/${prefix}/graphseg/${rel_path_2}"

    mkdir -p ${FLIP_OUT}
    mkdir -p ${BALANCE_OUT}
    mkdir -p ${GRAPH_OUT}

    cp ${DATA_FOLDER}/flipseg/${rel_path_1}/corrected-seg.png ${FLIP_OUT}/corrected_seg.png
    cp ${DATA_FOLDER}/balanceseg/${rel_path_1}/corrected-seg.png ${BALANCE_OUT}/corrected_seg.png


    cp ${DATA_FOLDER}/graphseg/${rel_path_2}/corrected-seg.png ${GRAPH_OUT}/corrected_seg.png

}

exp_alpha()
{
    h="1.0"
    dalpha="False"
    ALPHA="0.0 0.5 1.0"
    beta="0.0"
    lb="2.0"
    lr="2.0"

    for alpha in $ALPHA
    do
        export_files $h $dalpha $alpha $beta $lb $lr "exp-alpha"
    done
}

exp_beta()
{
    h="1.0"
    dalpha="False"
    alpha="0.1"
    BETA="0.1 1.0 3.0"
    lb="2.0"
    lr="2.0"

    for beta in $BETA
    do
        export_files $h $dalpha $alpha $beta $lb $lr "exp-beta"
    done
}

exp_gamma()
{
    h="1.0"
    dalpha="False"
    alpha="0.1"
    beta="1.0"
    lb="2.0"
    LR="0.0 1.0 5.0"

    for lr in $LR
    do
        export_files $h $dalpha $alpha $beta $lr $lr "exp-gamma"
    done
}

exp_radius()
{
    h="1.0"
    alpha="0.1"
    beta="1.0"
    lb="1.0"
    lr="1.0"
    it=200
    RADIUS="3 7 12"

    FLIP_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/boundary-correction-app
    BALANCE_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/boundary-correction-app
    GRAPH_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/graph-seg-app

    FLIP_DATA="${DATA_FOLDER}/exp-radius/flipseg"
    BALANCE_DATA="${DATA_FOLDER}/exp-radius/balanceseg"
    GRAPH_DATA="${DATA_FOLDER}/exp-radius/graphseg"

    FLIP_OUT="${BASE_OUTPUT_FOLDER}/exp-radius/flipseg"
    BALANCE_OUT="${BASE_OUTPUT_FOLDER}/exp-radius/balanceseg"
    GRAPH_OUT="${BASE_OUTPUT_FOLDER}/exp-radius/graphseg"

    for radius in $RADIUS
    do
        REL_PATH="h-${h}/alpha-${alpha}/beta-${beta}/gamma-${lr}/radius-${radius}"

        $( $FLIP_APP -r${radius} -i${it} -l-2 -q${beta} -t${lr} -g${alpha} -mimprove -d0 -o "${FLIP_DATA}/${REL_PATH}" ${INPUT_FOLDER}/coala.xml && \
        mkdir -p ${FLIP_OUT}/${REL_PATH} && \
        cp ${FLIP_DATA}/${REL_PATH}/corrected-seg.png ${FLIP_OUT}/${REL_PATH}/corrected-seg.png)&

        $( $BALANCE_APP -r${radius} -i${it} -l-2 -q${beta} -t${lr} -g${alpha} -mimprove -O1 -d0 -o "${BALANCE_DATA}/${REL_PATH}" ${INPUT_FOLDER}/coala.xml && \
        mkdir -p ${BALANCE_OUT}/${REL_PATH} && \
        cp ${BALANCE_DATA}/${REL_PATH}/corrected-seg.png ${BALANCE_OUT}/${REL_PATH}/corrected-seg.png)


        $( $GRAPH_APP -r${radius} -i${it} -eelastica -h${h} -d0 -a${alpha} -g${lr} -b${lb} -k${beta} ${INPUT_FOLDER}/coala.xml "${GRAPH_DATA}/${REL_PATH}" && \
        mkdir -p ${GRAPH_OUT}/${REL_PATH} && \
        cp ${GRAPH_DATA}/${REL_PATH}/corrected-seg.png ${GRAPH_OUT}/${REL_PATH}/corrected-seg.png)&

    done

}


exp_alpha
exp_beta
exp_gamma

exp_radius



