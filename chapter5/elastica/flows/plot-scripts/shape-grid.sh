#!/usr/bin/env bash

source "graph-plot.sh"

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
DATA_FOLDER=$( realpath $1 )
OUTPUT_FOLDER=$2
ESTIMATOR=$3
RADIUS=$4
LENGTH_PEN=$5

mkdir -p $OUTPUT_FOLDER

shapes="bean square flower triangle ellipse"

for s in $shapes
do
    PREFIX_INPUT="$DATA_FOLDER/$s/radius_$RADIUS/$ESTIMATOR/elastica/len_pen_$LENGTH_PEN/m2M50/jonctions_1/best/gs_"
    OUTPUT_FILEFOLDER="$OUTPUT_FOLDER/$ESTIMATOR/radius_$RADIUS/length_pen_$LENGTH_PEN"

    mkdir -p $OUTPUT_FILEFOLDER

    create_multiplot "$OUTPUT_FILEFOLDER/$s.eps" "$s" "${PREFIX_INPUT}1.00000/energy.txt" "gs=1.0" \
    "${PREFIX_INPUT}0.50000/energy.txt" "gs=0.5" "${PREFIX_INPUT}0.25000/energy.txt" "gs=0.25"
done