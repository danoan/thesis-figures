#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

EXHAUSTIVE_APP_FOLDER=${PROJECT_PATH}/ext-projects
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow


function generate_plots()
{
    energy=$1
    IMAGES_BASE_FOLDER="${SCRIPT_PATH}/output/flow"
    OUTPUT_PLOTS="${SCRIPT_PATH}/output/flow/plots/${energy}"

    ${SCRIPT_PATH}/scripts/plot-scripts/shape-estimator.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-estimator 0.25000 0.01000 $energy
    ${SCRIPT_PATH}/scripts/plot-scripts/shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid ii 3 0.01000 $energy
    ${SCRIPT_PATH}/scripts/plot-scripts/shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid ii 5 0.01000 $energy
    ${SCRIPT_PATH}/scripts/plot-scripts/shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid mdca 3 0.01000 $energy

    ${SCRIPT_PATH}/scripts/plot-scripts/shape-estimator-bars.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/bars 0.01000 $energy
    ${SCRIPT_PATH}/scripts/plot-scripts/shape-estimator-bars.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/bars 0.00100 $energy

}

OUTPUT_FLOW=${SCRIPT_PATH}/output/flow
python3 ${SCRIPT_PATH}/scripts/instance-generator/generator.py $EXHAUSTIVE_APP_FOLDER cmake-build-release/bin $SUMMARY_APP $OUTPUT_FLOW

generate_plots selastica
generate_plots elastica

${SCRIPT_PATH}/scripts/plot-scripts/summary-ii5.sh "${SCRIPT_PATH}/output/flow" "${SCRIPT_PATH}/output/flow/plots" 0.01000
${SCRIPT_PATH}/scripts/plot-scripts/summary-ii5.sh "${SCRIPT_PATH}/output/flow" "${SCRIPT_PATH}/output/flow/plots" 0.00100