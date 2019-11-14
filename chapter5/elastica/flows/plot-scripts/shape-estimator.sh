#!/usr/bin/env bash

source "graph-plot.sh"

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
DATA_FOLDER=$( realpath $1 )
OUTPUT_FOLDER=$2
GS=$3
LENGTH_PEN=$4

mkdir -p $OUTPUT_FOLDER

shapes="bean square flower triangle ellipse"

prefix_input()
{
    shape=$1
    radius=$2
    estimator=$3
    length_pen=$4
    gs=$5

    echo $DATA_FOLDER/$shape/radius_$radius/$estimator/elastica/len_pen_$length_pen/m2M50/jonctions_1/best/gs_$gs
}


for s in $shapes
do
    OUTPUT_FILEFOLDER="$OUTPUT_FOLDER/$ESTIMATOR/length_pen_$LENGTH_PEN/gs_$GS"

    mkdir -p $OUTPUT_FILEFOLDER

    create_multiplot "$OUTPUT_FILEFOLDER/$s.eps" "$s" "$( prefix_input $s 3 mdca $LENGTH_PEN $GS )/energy.txt" "mdca" \
    "$( prefix_input $s 3 ii $LENGTH_PEN $GS )/energy.txt" "ii-3" "$( prefix_input $s 5 ii $LENGTH_PEN $GS )/energy.txt" "ii-5"
done