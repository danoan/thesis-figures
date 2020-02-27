#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )

source "${ROOT_FOLDER}/plot-scripts/graph-plot.sh"

gp_plot_config()
{
	printf "set title '$1';
	set yrange[0:];
	set xlabel 'Iteration';
	set ylabel 'Difference of potential';"
	#set logscale y 10;
}

IT=200
#IT=10

RADIUS=$1
SHAPE=$2
OUTPUT_FOLDER=$3

h_list="0.25 0.125 0.0625"

for h in $h_list
do
    echo "Generating output for shape=$SHAPE; radius=$RADIUS; h=$h;"

    OUTPUT_DATA_FOLDER=${OUTPUT_FOLDER}/data/$h/$SHAPE
    OUTPUT_PLOT_FOLDER=${OUTPUT_FOLDER}/plot/$h

    mkdir -p $OUTPUT_PLOT_FOLDER

    DATA_BIN=${ROOT_FOLDER}/cmake-build-release/chapter6/shape-potential-evolution/ch7-shape-potential-evolution
    $DATA_BIN $SHAPE $h $RADIUS $IT ${OUTPUT_DATA_FOLDER}

    create_multiplot ${OUTPUT_PLOT_FOLDER}/${SHAPE}.eps "$SHAPE" \
    "${OUTPUT_DATA_FOLDER}/diff.txt" "$SHAPE"
done
