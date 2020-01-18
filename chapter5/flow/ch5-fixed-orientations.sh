#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $SCRIPT_PATH
cd ../../
PROJECT_PATH=$PWD
cd $SCRIPT_PATH

EXHAUSTIVE_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-exhaustive-gc-flow
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow

INPUT_BASE_PATH=${SCRIPT_PATH}/input/fixed-orientations

function run_flow()
{
    energy=$1
    len_pen=$2

    OUTPUT_FLOW=${SCRIPT_PATH}/output/fixed-orientations/$energy/len_pen_$len_pen
    OUTPUT_PLOTS=${OUTPUT_FLOW}/plots

    $EXHAUSTIVE_APP -S${INPUT_BASE_PATH}/curve-1/input.pgm -h1 -r5 -i600 -tii -sbest -j1 -a$len_pen -n32 -e$energy -F${INPUT_BASE_PATH}/curve-1/pixelMask.pgm ${OUTPUT_FLOW}/curve-1
    $SUMMARY_APP -j5 -p${OUTPUT_FLOW}/curve-1/pixelMask.pgm -d${INPUT_BASE_PATH}/curve-1/dirMask.pgm ${OUTPUT_FLOW}/curve-1 ${OUTPUT_FLOW}/curve-1/summary.eps

    $EXHAUSTIVE_APP -S${INPUT_BASE_PATH}/curve-2/input.pgm -h1 -r5 -i600 -tii -sbest -j1 -a$len_pen -n32 -e$energy -F${INPUT_BASE_PATH}/curve-2/pixelMask.pgm ${OUTPUT_FLOW}/curve-2
    $SUMMARY_APP -j5 -p${OUTPUT_FLOW}/curve-2/pixelMask.pgm -d${INPUT_BASE_PATH}/curve-2/dirMask.pgm ${OUTPUT_FLOW}/curve-2 ${OUTPUT_FLOW}/curve-2/summary.eps

    $EXHAUSTIVE_APP -S${INPUT_BASE_PATH}/curve-3/input.pgm -h1 -r5 -i400 -tii -sbest -j1 -a$len_pen -n32 -e$energy -F${INPUT_BASE_PATH}/curve-3/pixelMask.pgm ${OUTPUT_FLOW}/curve-3
    $SUMMARY_APP -j5 -p${OUTPUT_FLOW}/curve-3/pixelMask.pgm -d${INPUT_BASE_PATH}/curve-3/dirMask.pgm ${OUTPUT_FLOW}/curve-3 ${OUTPUT_FLOW}/curve-3/summary.eps
}



run_flow selastica 0.1
run_flow elastica 0.1

run_flow selastica 0.001
run_flow elastica 0.001
