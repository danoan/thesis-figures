#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../../ && pwd)
source "${PROJECT_PATH}/plot-scripts/graph-plot.sh"

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
DATA_FOLDER=$( realpath $1 )
OUTPUT_FOLDER=$2
GS=$3
LENGTH_PEN=$4
ENERGY=$5

gp_plot_config()
{
    lenpen=$( echo $LENGTH_PEN | xargs -I{} printf "%.3f" {} | tr , .)
	printf "set title '$1';
	set key right top;
	set yrange[0:];
	set xlabel 'Iterations';
	set ylabel 'Elastica ({/Symbol a}=$lenpen, {/Symbol b}=1)';"
}

gp_last_plot()
{
	printf "'$1' u 1:2 w lp ls $3 title '$2';"
    v=$(python -c "import math; print(4*math.pi*(${LENGTH_PEN}**0.5))")
    printf "set arrow 10 from 0,$v to graph 1, first $v nohead lw 3 dt 2 front;"
}

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

    echo $DATA_FOLDER/$shape/radius_$radius/$estimator/$energy/len_pen_$length_pen/jonctions_1/curve_segs_4/best/gs_$gs
}


for s in $shapes
do
    OUTPUT_FILEFOLDER="$OUTPUT_FOLDER/$ESTIMATOR/length_pen_$LENGTH_PEN/gs_$GS"

    mkdir -p $OUTPUT_FILEFOLDER

    create_multiplot "$OUTPUT_FILEFOLDER/$s.eps" "$s" "$( prefix_input $s 3 mdca $LENGTH_PEN $GS $ENERGY )/energy.txt" "mdca" \
    "$( prefix_input $s 3 ii $LENGTH_PEN $GS $ENERGY )/energy.txt" "ii-3" \
    "$( prefix_input $s 5 ii $LENGTH_PEN $GS $ENERGY)/energy.txt" "ii-5" \
    "$( prefix_input $s 10 ii $LENGTH_PEN $GS $ENERGY)/energy.txt" "ii-10"
done