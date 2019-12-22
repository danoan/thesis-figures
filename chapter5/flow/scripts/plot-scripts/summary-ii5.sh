#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$(cd $SCRIPT_PATH && cd ../../../../ && pwd)
source "${ROOT_FOLDER}/plot-scripts/graph-plot.sh"

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
DATA_FOLDER=$( realpath $1 )
OUTPUT_FOLDER=$( realpath $2 )
LENGTH_PEN=0.01000
ENERGY=elastica

mkdir -p $OUTPUT_FOLDER

shapes="bean square flower triangle ellipse"

prefix_input()
{
    shape=$1
    radius=$2
    estimator=$3
    length_pen=$4
    gs=$5
    energy=$6

    echo $DATA_FOLDER/$shape/radius_$radius/$estimator/$energy/len_pen_$length_pen/m2M50/jonctions_1/best/gs_$gs
}


create_multiplot "$OUTPUT_FOLDER/summary-ii5.eps" "$s" "$( prefix_input triangle 5 ii $LENGTH_PEN 0.25000 $ENERGY )/energy.txt" "triangle" \
"$( prefix_input square 5 ii $LENGTH_PEN 0.25000 $ENERGY )/energy.txt" "square" \
"$( prefix_input flower 5 ii $LENGTH_PEN 0.25000 $ENERGY )/energy.txt" "flower" \
"$( prefix_input bean 5 ii $LENGTH_PEN 0.50000 $ENERGY )/energy.txt" "bean"