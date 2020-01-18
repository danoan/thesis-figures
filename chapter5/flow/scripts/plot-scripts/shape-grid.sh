#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$(cd $SCRIPT_PATH && cd ../../../../ && pwd)
source "${ROOT_FOLDER}/plot-scripts/graph-plot.sh"

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
DATA_FOLDER=$( realpath $1 )
OUTPUT_FOLDER=$2
ESTIMATOR=$3
RADIUS=$4
LENGTH_PEN=$5
ENERGY=$6

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

for s in $shapes
do
    PREFIX_INPUT="$DATA_FOLDER/$s/radius_$RADIUS/$ESTIMATOR/$ENERGY/len_pen_$LENGTH_PEN/jonctions_1/best/gs_"
    OUTPUT_FILEFOLDER="$OUTPUT_FOLDER/$ESTIMATOR/radius_$RADIUS/length_pen_$LENGTH_PEN"

    mkdir -p $OUTPUT_FILEFOLDER

    create_multiplot "$OUTPUT_FILEFOLDER/$s.eps" "$s" "${PREFIX_INPUT}1.00000/energy.txt" "gs=1.0" \
    "${PREFIX_INPUT}0.50000/energy.txt" "gs=0.5" "${PREFIX_INPUT}0.25000/energy.txt" "gs=0.25"
done