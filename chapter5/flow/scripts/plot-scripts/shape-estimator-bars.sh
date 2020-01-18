#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$(cd $SCRIPT_PATH && cd ../../../../ && pwd)

source "${ROOT_FOLDER}/plot-scripts/graph-plot.sh"

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
DATA_FOLDER=$( realpath $1 )
OUTPUT_FOLDER=$2
LENGTH_PEN=$3
ENERGY=$4

gp_plot_config()
{
    lenpen=$( echo $LENGTH_PEN | xargs -I{} printf "%.3f" {} | tr , .)
	printf "set title '$1';
	set key right top;
	set boxwidth 1;
	set style fill solid;
	set yrange[0:];
	set xlabel 'Iterations';
	set ylabel 'Elastica ({/Symbol a}=$lenpen, {/Symbol b}=1)';\
    set xtics ('II-3' 2.5, 'II-5' 6.5, 'II-10' 10.5, 'mdca' 14.5);"
}

gp_add_plot()
{
    printf "'$1' every 1 u 1:2 w boxes ls $3 title '$2',"
}

gp_last_plot()
{
	printf "'$1' every 1 u 1:2 w boxes ls $3 title '$2';"
    v=$(python -c "import math; print(4*math.pi*(${LENGTH_PEN}**0.5))")
    printf "set arrow 10 from 0,$v to graph 1, first $v nohead lw 4 dt 2 front;"
}


mkdir -p $OUTPUT_FOLDER

prefix_input()
{
    shape=$1
    radius=$2
    estimator=$3
    length_pen=$4
    gs=$5
    energy=$6

    echo $DATA_FOLDER/$shape/radius_$radius/$estimator/$energy/len_pen_$length_pen/jonctions_1/best/gs_$gs
}


last_value()
{
    gnuplotData=$1
    value=$( grep "#" -v $gnuplotData | grep "[0-9]" | tail -n2 | head -n1 | cut -f2)
    echo $value
}

build_bars_file()
{
    shape=$1
    h=$2
    i=$3

    output_file=${SCRIPT_PATH}/bars_file_$h.temp
    echo "#Bars File" > $output_file

    ii3=$(last_value $( prefix_input $shape 3 ii $LENGTH_PEN $h $ENERGY)/energy.txt)
    ii5=$(last_value $( prefix_input $shape 5 ii $LENGTH_PEN $h $ENERGY)/energy.txt)
    ii10=$(last_value $( prefix_input $shape 10 ii $LENGTH_PEN $h $ENERGY)/energy.txt)
    mdca=$(last_value $( prefix_input $shape 3 mdca $LENGTH_PEN $h $ENERGY)/energy.txt)

    echo "$(( $i+1 )) $ii3" >> $output_file
    echo "$(( $i+5 )) $ii5" >> $output_file
    echo "$(( $i+9 )) $ii10" >> $output_file
    echo "$(( $i+13 )) $mdca" >> $output_file

    echo $output_file
}


shapes="bean square flower triangle ellipse"


for s in $shapes
do
    OUTPUT_FILEFOLDER="$OUTPUT_FOLDER/length_pen_$LENGTH_PEN"

    mkdir -p $OUTPUT_FILEFOLDER

    create_multiplot "${OUTPUT_FILEFOLDER}/${s}.eps" "$s" "$(build_bars_file $s 1.00000 0)" "h=1.0" \
    "$(build_bars_file $s 0.50000 1)" "h=0.5" \
    "$(build_bars_file $s 0.25000 2)" "h=0.25"

    rm $(build_bars_file $s 1.00000 0)
    rm $(build_bars_file $s 0.50000 1)
    rm $(build_bars_file $s 0.25000 2)
done

