#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )

DATA_BIN=${ROOT_FOLDER}/cmake-build-debug/chapter6/balance-evolution-shape/ch6-balance-evolution-shape
OUTPUT_DATA_FOLDER=${SCRIPT_PATH}/output/bean
RADIUS=5

PLOT_SCRIPT=${SCRIPT_PATH}/plot-graph.sh
OUTPUT_PLOT_FOLDER=${SCRIPT_PATH}/output-plot/bean-k-015

h_list="1 0.5 0.25 0.125"

for h in $h_list
do
    $DATA_BIN bean $h $RADIUS -0.15 -0.1 ${OUTPUT_DATA_FOLDER}/h$h
    $PLOT_SCRIPT ${OUTPUT_DATA_FOLDER}/h$h ${OUTPUT_PLOT_FOLDER}/h${h}.eps
done
