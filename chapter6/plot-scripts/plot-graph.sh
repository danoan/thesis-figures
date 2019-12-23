#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )

source "${ROOT_FOLDER}/plot-scripts/graph-plot.sh"

gp_plot_config()
{
	printf "set title '$1';
	set yrange[0:];
	set xlabel 'Distance';
	set ylabel 'Balance coefficient';"
	#set logscale y 10;
}

DATA_FOLDER=$(realpath $1)
OUTPUT_FILEPATH=$2

$(mkdir -p $(dirname $OUTPUT_FILEPATH) )

k=$(cat ${DATA_FOLDER}/inner.txt | grep "k=.*" -o)

create_multiplot "$OUTPUT_FILEPATH" "$k" \
"${DATA_FOLDER}/inner.txt" "Inner" \
"${DATA_FOLDER}/outer.txt" "Outer"

