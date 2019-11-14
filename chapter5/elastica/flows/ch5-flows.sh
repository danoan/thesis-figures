#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $SCRIPT_PATH
cd ../../../
PROJECT_PATH=$PWD
cd $SCRIPT_PATH

EXHAUSTIVE_APP_FOLDER=${PROJECT_PATH}/ext-projects
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow


OUTPUT_FLOW=${SCRIPT_PATH}/output
OUTPUT_PLOTS=${SCRIPT_PATH}/plot-scrips/output

python3 experiment.py $EXHAUSTIVE_APP_FOLDER cmake-build-release/bin $OUTPUT_FLOW
summary-flow.sh $SUMMARY_APP output
plot-scripts/shape-estimator.sh ../output ${OUTPUT_PLOTS}/shape-estimator 1.00000 0.01000
plot-scripts/shape-grid.sh ../output ${OUTPUT_PLOTS}/shape-grid ii 3 0.01000
plot-scripts/shape-grid.sh ../output ${OUTPUT_PLOTS}/shape-grid ii 5 0.01000
plot-scripts/shape-grid.sh ../output ${OUTPUT_PLOTS}/shape-grid mdca 3 0.01000