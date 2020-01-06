#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )
PLOT_SCRIPT_FOLDER=${ROOT_FOLDER}/chapter6/plot-scripts

DATA_BIN=${ROOT_FOLDER}/cmake-build-debug/chapter6/balance-evolution-shape/ch6-balance-evolution-shape

RADIUS=$1
k1=$2
k2=$3
SHAPE=$4
OUTPUT_FOLDER=$5

OUTPUT_DATA_FOLDER=${OUTPUT_FOLDER}/data/${SHAPE}-r${RADIUS}/k${k1}k${k2}
OUTPUT_PLOT_FOLDER=${OUTPUT_FOLDER}/plot/${SHAPE}-r${RADIUS}/k${k1}k${k2}

PLOT_SCRIPT=${PLOT_SCRIPT_FOLDER}/plot-graph.sh

h_list="1 0.5 0.25 0.125 0.0625 0.03725"

for h in $h_list
do
    echo "Generating output for shape=$SHAPE; radius=$RADIUS; h=$h; k1=$k1; k2=$k2"
    $DATA_BIN $SHAPE $h $RADIUS $k1 $k2 ${OUTPUT_DATA_FOLDER}/h$h
    if [ $? -eq 0 ]
    then
        $PLOT_SCRIPT ${OUTPUT_DATA_FOLDER}/h$h ${OUTPUT_PLOT_FOLDER}/h${h}.eps
    fi
done