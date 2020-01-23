#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../../ && pwd )
OUTPUT_FOLDER=${SCRIPT_PATH}/output

source "${ROOT_FOLDER}/plot-scripts/graph-plot.sh"

gp_plot_config()
{
	printf "set title '$1';
	set yrange[0:];
	set xlabel 'k';
	set ylabel 'Max distance';"
	#set logscale y 10;
}

gp_add_plot()
{
    printf "'$1' u 1:3 w lp ls $3 title '$2',"
}

gp_last_plot()
{
	printf "'$1' u 1:3 w lp ls $3 title '$2';
	f(x) = mean_y;
    fit f(x) '$1' u 1:3 via mean_y;
    set arrow 10 from 0,mean_y to graph 1, first mean_y nohead lw 2 dt 2;";
}


DATA_BIN=${ROOT_FOLDER}/cmake-build-release/chapter6/balance-evolution-shape/maxDiff/ch7-balance-evolution-maxDiff
OUTPUT_BASE_FOLDER=${SCRIPT_PATH}/output

function radius_sequence_loop()
{
    SHAPE=$1;shift;
    RADIUS=$1;shift;

    while [ -n "$1" ]
    do
        h=$1;shift
        f=$1;shift
        OUTPUT_FOLDER=${OUTPUT_BASE_FOLDER}/radius$RADIUS/f$f
        ${DATA_BIN} $SHAPE $h $RADIUS ${OUTPUT_FOLDER}

        create_multiplot "${OUTPUT_FOLDER}/plot.ps" "$SHAPE" \
        "${OUTPUT_FOLDER}/maxDiff.txt" "Radius=$RADIUS"
    done

}
function radius_sequence()
{
    f="0.125 8 0.0625 16 0.03125 32 0.015625 64 0.0078125 128"
    radius_sequence_loop $1 $2 $f
}

radius_sequence flower 0.5
radius_sequence flower 1
radius_sequence flower 2









