#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $SCRIPT_PATH
cd ../../
PROJECT_PATH=$PWD
cd $SCRIPT_PATH

EXHAUSTIVE_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-exhaustive-gc-flow
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow



function generate_plots()
{
    energy=$1
    IMAGES_BASE_FOLDER="${SCRIPT_PATH}/output/flow"
    OUTPUT_PLOTS="${SCRIPT_PATH}/output/flow/plots/${energy}"

    scripts/summary-flow.sh $SUMMARY_APP $IMAGES_BASE_FOLDER
    scripts/plot-scripts/shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid ii 5 0.01000 $energy
}

function output_base_folder()
{
    suffix=$1
    OUTPUT_FLOW=${SCRIPT_PATH}/output/flow
    echo "${OUTPUT_FLOW}/flower-$suffix/radius_5/ii/sqc/len_pen_0.01000/m2M50/jonctions_1/best/gs_0.25000"
}

INPUT_BASE_PATH=${SCRIPT_PATH}/input

$EXHAUSTIVE_APP -m2 -M50 -S${INPUT_BASE_PATH}/r20r5.pgm -r5 -tii -esqc -a0.01 -i400 -j1 -sbest -n32 $(output_base_folder r20r5)
$EXHAUSTIVE_APP -m2 -M50 -S${INPUT_BASE_PATH}/r20r7.pgm -r5 -tii -esqc -a0.01 -i400 -j1 -sbest -n32 $(output_base_folder r20r7)
$EXHAUSTIVE_APP -m2 -M50 -S${INPUT_BASE_PATH}/r20r9.pgm -r5 -tii -esqc -a0.01 -i400 -j1 -sbest -n32 $(output_base_folder r20r5R9)


generate_plots sqc
