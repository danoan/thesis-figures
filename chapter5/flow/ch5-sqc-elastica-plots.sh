#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

source "${SCRIPT_PATH}/scripts/plot-scripts/graph-plot.sh"

APP_IMAGE_ESTIMATOR=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-image-estimator

OUTPUT_FOLDER=$1
BASE_FOLDER=$2

mkdir -p ${OUTPUT_FOLDER}

function sqc_evaluation
{
    INPUT_FOLDER=$1
    OUTPUT_FILEPATH=$2

    mkdir ${SCRIPT_PATH}/.temp
    cp -a ${INPUT_FOLDER}/*.pgm ${SCRIPT_PATH}/.temp
    rm ${SCRIPT_PATH}/.temp/fixedMask.pgm

    $APP_IMAGE_ESTIMATOR -mall-in-folder -f${SCRIPT_PATH}/.temp/ -esqc-ii -h0.25 -r5 -a0.01 | sort | cut -d':' -f2 | nl > ${OUTPUT_FILEPATH}

    rm -rf ${SCRIPT_PATH}/.temp
}

function fixed_points
{
    F1_ELASTICA_FOLDER=${BASE_FOLDER}/fixed-points/elastica/flower-1
    F2_ELASTICA_FOLDER=${BASE_FOLDER}/fixed-points/elastica/flower-2

    F1_SQC_FOLDER=${BASE_FOLDER}/fixed-points/sqc/flower-1
    F2_SQC_FOLDER=${BASE_FOLDER}/fixed-points/sqc/flower-2

    sqc_evaluation $F1_ELASTICA_FOLDER $F1_ELASTICA_FOLDER/energy-sqc.txt
    sqc_evaluation $F2_ELASTICA_FOLDER $F2_ELASTICA_FOLDER/energy-sqc.txt

    create_multiplot "$OUTPUT_FOLDER/fixed-flower-1.eps" "Simple Elastica Evaluation" "${F1_SQC_FOLDER}/energy.txt" "{Q_i}" \
        "${F1_ELASTICA_FOLDER}/energy-sqc.txt" "{S_i}"

    create_multiplot "$OUTPUT_FOLDER/fixed-flower-2.eps" "Simple Elastica Evaluation" "${F2_SQC_FOLDER}/energy.txt" "{Q_i}" \
        "${F2_ELASTICA_FOLDER}/energy-sqc.txt" "{S_i}"
}

function flow
{
    FLOWER_ELASTICA_FOLDER=${BASE_FOLDER}/flow/flower/radius_5/ii/elastica/len_pen_0.01000/m2M50/jonctions_1/best/gs_0.25000
    FLOWER_SQC_FOLDER=${BASE_FOLDER}/flow/flower/radius_5/ii/sqc/len_pen_0.01000/m2M50/jonctions_1/best/gs_0.25000

    sqc_evaluation $FLOWER_ELASTICA_FOLDER $FLOWER_ELASTICA_FOLDER/energy-sqc.txt

    create_multiplot "$OUTPUT_FOLDER/flow-flower.eps" "Simple Elastica Evaluation" "${FLOWER_SQC_FOLDER}/energy.txt" "{Q_i}" \
        "${FLOWER_ELASTICA_FOLDER}/energy-sqc.txt" "{S_i}"
}

gp_plot_config()
{
	printf "set title '$1';
	set xlabel 'Iterations';"
}


flow

gp_optimal_line()
{
    printf ""
}

fixed_points




