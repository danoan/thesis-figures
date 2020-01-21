#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd)

EXHAUSTIVE_APP_FOLDER=${PROJECT_PATH}/ext-projects
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow

PLOT_SCRIPTS=${SCRIPT_PATH}/scripts
DATA_OUTPUT_FOLDER=${SCRIPT_PATH}/data
OUTPUT_FOLDER=${SCRIPT_PATH}/output/flow

function generate_plots()
{
    energy=$1
    IMAGES_BASE_FOLDER=$2
    OUTPUT_PLOTS=$3

    ${PLOT_SCRIPTS}/ch5-plot-shape-estimator.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-estimator 0.25000 0.01000 $energy
    ${PLOT_SCRIPTS}/ch5-plot-shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid ii 3 0.01000 $energy
    ${PLOT_SCRIPTS}/ch5-plot-shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid ii 5 0.01000 $energy
    ${PLOT_SCRIPTS}/ch5-plot-shape-grid.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/shape-grid mdca 3 0.01000 $energy

    ${PLOT_SCRIPTS}/ch5-plot-shape-estimator-bars.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/bars 0.01000 $energy
    ${PLOT_SCRIPTS}/ch5-plot-shape-estimator-bars.sh $IMAGES_BASE_FOLDER ${OUTPUT_PLOTS}/bars 0.00100 $energy

}


python3 ${SCRIPT_PATH}/scripts/instance-generator/generator.py $EXHAUSTIVE_APP_FOLDER cmake-build-release/bin $SUMMARY_APP $DATA_OUTPUT_FOLDER


#Move summary.eps files to output folder
find $DATA_OUTPUT_FOLDER -name "summary.eps" |\
xargs -I{} realpath --relative-to $DATA_OUTPUT_FOLDER {} |\
xargs -I{} dirname {} |\
xargs -I{} bash -c "mkdir -p ${OUTPUT_FOLDER}/{} && mv ${DATA_OUTPUT_FOLDER}/{}/summary.eps ${OUTPUT_FOLDER}/{}/summary.eps" _{}


generate_plots selastica $DATA_OUTPUT_FOLDER ${OUTPUT_FOLDER}/plots
generate_plots elastica $DATA_OUTPUT_FOLDER ${OUTPUT_FOLDER}/plots

${SCRIPT_PATH}/scripts/ch5-plot-summary-ii5.sh $DATA_OUTPUT_FOLDER "${OUTPUT_FOLDER}/plots/summary/lp_0.01" 0.01000
${SCRIPT_PATH}/scripts/ch5-plot-summary-ii5.sh $DATA_OUTPUT_FOLDER "${OUTPUT_FOLDER}/plots/summary/lp_0.001" 0.00100


#Convert summary eps files to pdf
find $OUTPUT_FOLDER -name "*.eps" | xargs -I{} epstopdf {}
find $OUTPUT_FOLDER -name "*.eps" | xargs -I{} rm {}