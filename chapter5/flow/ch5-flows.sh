#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $SCRIPT_PATH
cd ../../
PROJECT_PATH=$PWD
cd $SCRIPT_PATH

EXHAUSTIVE_APP_FOLDER=${PROJECT_PATH}/ext-projects
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow



function generate_plots()
{
    energy=$1
    IMAGES_BASE_FOLDER="${SCRIPT_PATH}/output/flow"
    OUTPUT_PLOTS="${SCRIPT_PATH}/output/flow/plots/${energy}"

    scripts/summary-flow.sh $SUMMARY_APP $IMAGES_BASE_FOLDER
    scripts/plot-scripts/shape-estimator.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-estimator 1.00000 0.01000
    scripts/plot-scripts/shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid ii 3 0.01000
    scripts/plot-scripts/shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid ii 5 0.01000
    scripts/plot-scripts/shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid mdca 3 0.01000

}

OUTPUT_FLOW=${SCRIPT_PATH}/output/flow
python3 ${SCRIPT_PATH}/scripts/experiment.py $EXHAUSTIVE_APP_FOLDER cmake-build-release/bin $OUTPUT_FLOW

generate_plots sqc
generate_plots elastica
