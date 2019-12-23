#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )
PLOT_SCRIPT_FOLDER=${ROOT_FOLDER}/chapter6/plot-scripts

DATA_BIN=${ROOT_FOLDER}/cmake-build-debug/chapter6/balance-evolution/ch6-balance-evolution
OUTPUT_DATA_FOLDER=${SCRIPT_PATH}/output/data
RADIUS=5

PLOT_SCRIPT=${PLOT_SCRIPT_FOLDER}/plot-graph.sh
OUTPUT_PLOT_FOLDER=${SCRIPT_PATH}/output/plot

h_list="1 0.5 0.25 0.125 0.0625"

for h in $h_list
do
    $DATA_BIN $h $RADIUS ${OUTPUT_DATA_FOLDER}/h$h
    $PLOT_SCRIPT ${OUTPUT_DATA_FOLDER}/h$h ${OUTPUT_PLOT_FOLDER}/h${h}.eps
done
