#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )

DATA_BIN=${ROOT_FOLDER}/cmake-build-debug/chapter6/balance-evolution/ch6-balance-evolution
OUTPUT_DATA_FOLDER=${SCRIPT_PATH}/output
RADIUS=5

PLOT_SCRIPT=${SCRIPT_PATH}/plot-graph.sh
OUTPUT_PLOT_FOLDER=${SCRIPT_PATH}/output-plot

h_list="1 0.5 0.25 0.125 0.0625"

for h in $h_list
do
    $DATA_BIN $h $RADIUS ${OUTPUT_DATA_FOLDER}/h$h
    $PLOT_SCRIPT ${OUTPUT_DATA_FOLDER}/h$h ${OUTPUT_PLOT_FOLDER}/h${h}.eps
done
