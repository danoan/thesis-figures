#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../.. && pwd)

source ${SCRIPT_PATH}/utils.sh
source ${PROJECT_PATH}/slides/utils.sh
source ${PROJECT_PATH}/plot-scripts/graph-plot.sh
pointInterval=5000

gp_plot_config()
{
	printf "set title '$1';
	set key right top;
	set boxwidth 1;
	set style fill solid;
	set logscale y 2;
	set yrange[0:];
	set xlabel 'Iterations';
	set ylabel 'Elastica ({/Symbol a}=1/484, {/Symbol b}=1)';\
    set xtics ('R0.625' 2.5, 'R2' 7.5);"
}

gp_add_plot()
{
    printf "'$1' every 1 u 1:3 w boxes ls $3 title '$2',"
}

gp_last_plot()
{
    printf "'$1' every 1 u 1:3 w boxes ls $3 title '$2';"
    v=$(python -c "import math; print(4*math.pi*(0.0020661157**0.5))")
    printf "set arrow 10 from 0,$v to graph 1, first $v nohead lw 3 dt 2 front;"
}

last_value()
{
    gnuplotData=$1
    value=$( grep "#" -v $gnuplotData | grep "[0-9]" | tail -n1 | cut -f2)
    echo $value
}

build_bars_file()
{
    IMAGE_ROOT_FOLDER=$1
    SHAPE=$2
    LEN_PEN=$3
    i=$4

    output_file=${SCRIPT_PATH}/bars_file_${SHAPE}.temp
    echo "#Bars File" > $output_file

    ii5=$(last_value $( get_instance_path_r ${IMAGE_ROOT_FOLDER} ${SHAPE} ${LEN_PEN} 5 )/energy.txt)
    ii16=$(last_value $( get_instance_path_r ${IMAGE_ROOT_FOLDER} ${SHAPE} ${LEN_PEN} 16 )/energy.txt)

    echo "$(( $i+1 )) $ii5" >> $output_file
    echo "$(( $i+6 )) $ii16" >> $output_file

    echo $output_file
}

IMAGE_ROOT_FOLDER=$1
OUTPUT_FOLDER=${SCRIPT_PATH}/output/with-neighborhood-flow/plots
mkdir -p ${OUTPUT_FOLDER}

SHAPES="triangle square flower bean"
LEN_PEN=0.0020661157

create_multiplot "${OUTPUT_FOLDER}/bars.eps" "Balance coefficient radius" "$(build_bars_file $IMAGE_ROOT_FOLDER triangle $LEN_PEN 0)" "triangle" \
"$(build_bars_file $IMAGE_ROOT_FOLDER square $LEN_PEN 1)" "square" \
"$(build_bars_file $IMAGE_ROOT_FOLDER flower $LEN_PEN 2)" "flower" \
"$(build_bars_file $IMAGE_ROOT_FOLDER bean $LEN_PEN 3)" "bean"

convert_to_png "${OUTPUT_FOLDER}/bars.eps" "${OUTPUT_FOLDER}/bars.png"
rm "${OUTPUT_FOLDER}/bars.eps"





