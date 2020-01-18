#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $SCRIPT_PATH
cd ../../
PROJECT_PATH=$PWD
cd $SCRIPT_PATH

EXHAUSTIVE_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-exhaustive-gc-flow
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow

INPUT_BASE_PATH=${SCRIPT_PATH}/input/fixed-points

function run_flow()
{
    energy=$1
    len_pen=$2

    OUTPUT_FLOW=${SCRIPT_PATH}/output/fixed-points/$energy/len_pen_$len_pen

    $EXHAUSTIVE_APP -S${INPUT_BASE_PATH}/flower-1/input.pgm -h0.25 -r5 -i600 -tii -sbest -j1 -a$len_pen -n32 -e$energy -F${INPUT_BASE_PATH}/flower-1/pixelMask.pgm ${OUTPUT_FLOW}/flower-1
    $SUMMARY_APP -j10 -d${OUTPUT_FLOW}/flower-1/pixelMask.pgm ${OUTPUT_FLOW}/flower-1 ${OUTPUT_FLOW}/flower-1/summary.eps

    $EXHAUSTIVE_APP -S${INPUT_BASE_PATH}/flower-2/input.pgm -h0.25 -r5 -i600 -tii -sbest -j1 -a$len_pen -n32 -e$energy -F${INPUT_BASE_PATH}/flower-2/pixelMask.pgm ${OUTPUT_FLOW}/flower-2
    $SUMMARY_APP -j10 -d${OUTPUT_FLOW}/flower-2/pixelMask.pgm ${OUTPUT_FLOW}/flower-2 ${OUTPUT_FLOW}/flower-2/summary.eps
}


run_flow elastica 0.1
run_flow elastica 0.01
run_flow selastica 0.1
run_flow selastica 0.01



