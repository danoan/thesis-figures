#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd )

DATA_FOLDER=${SCRIPT_PATH}/data
OUTPUT_FOLDER=${SCRIPT_PATH}/output/topology-changes

mkdir -p ${DATA_FOLDER}
mkdir -p ${OUTPUT_FOLDER}

TOPOLOGY_CHANGE_APP=${PROJECT_PATH}/cmake-build-release/chapter6/topology-change/ch6-topology-changes
SHAPE_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/shape-flow
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/summary-flow


$TOPOLOGY_CHANGE_APP 20 80 15 ${DATA_FOLDER}/square-holes.pgm
$SHAPE_FLOW_APP -i100 -r6 -p double -q1.0 -t0 -g0 -l-1 -S${DATA_FOLDER}/square-holes.pgm ${DATA_FOLDER}/square-holes-flow
$SUMMARY_APP ${DATA_FOLDER}/square-holes-flow ${OUTPUT_FOLDER}/summary-square-holes.eps 10
epstopdf ${OUTPUT_FOLDER}/summary-square-holes.eps
rm ${OUTPUT_FOLDER}/summary-square-holes.eps

$SHAPE_FLOW_APP -i100 -r9 -p double -q1.0 -t0 -g0 -l-1 -h0.1 -Swave ${DATA_FOLDER}/wave-flow
$SUMMARY_APP ${DATA_FOLDER}/wave-flow ${OUTPUT_FOLDER}/summary-wave.eps 14
epstopdf ${OUTPUT_FOLDER}/summary-wave.eps
rm ${OUTPUT_FOLDER}/summary-wave.eps