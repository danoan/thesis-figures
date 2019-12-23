#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )
PLOT_SCRIPT_FOLDER=${ROOT_FOLDER}/chapter6/plot-scripts

SHAPE=square
H=0.25
RADIUS=3
IT=50

OUTPUT_DATA_FOLDER=${1}/data/$SHAPE
OUTPUT_PLOT_FOLDER=${1}/plot/$SHAPE


DATA_BIN=${ROOT_FOLDER}/cmake-build-debug/chapter6/shape-potential-evolution/ch6-shape-potential-evolution
$DATA_BIN $SHAPE $H $RADIUS $IT ${OUTPUT_DATA_FOLDER}

PLOT_SCRIPT=${PLOT_SCRIPT_FOLDER}/plot-graph.sh
$PLOT_SCRIPT ${OUTPUT_DATA_FOLDER} ${OUTPUT_PLOT_FOLDER}/plot.eps
