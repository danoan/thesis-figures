#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $SCRIPT_PATH
cd ../../../
PROJECT_PATH=$PWD
cd $SCRIPT_PATH

EXHAUSTIVE_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-exhaustive-gc-flow
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow


OUTPUT_FLOW=${SCRIPT_PATH}/output
OUTPUT_PLOTS=${SCRIPT_PATH}/plot-scripts/output

$EXHAUSTIVE_APP -Sflower -h0.25 -r5 -i400 -tii -sbest -m2 -M50 -j1 -a0.01 -n16 -F${SCRIPT_PATH}/input/flower-1/fixedMask-1.pgm ${OUTPUT_FLOW}/flower-1
$EXHAUSTIVE_APP -Sflower -h0.25 -r5 -i400 -tii -sbest -m2 -M50 -j1 -a0.01 -n16 -F${SCRIPT_PATH}/input/flower-2/fixedMask-2.pgm ${OUTPUT_FLOW}/flower-2
