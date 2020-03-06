#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd )
PLOT_SCRIPT=${PROJECT_PATH}/plot-scripts

GET_PATH=${SCRIPT_PATH}/get-path.sh
source ${PLOT_SCRIPT}/graph-plot.sh

DATA_BASE_FOLDER=$1
OUTPUT_BASE_FOLDER=$2

gp_plot_config()
{
    lenpen=0
	printf "set title '$1';
	set key right top;
	set yrange[0:];
	set xlabel 'Iterations';
	set ylabel 'Digital Elastica ({/Symbol a}=$lenpen, {/Symbol b}=1)';"
}


temp_file_num=".temp_file_num"
temp_base_name=".radius_effect_temp"
echo "1" >  $temp_file_num
create_temp_plot_file()
{
    shape=$1
    method=$2
    lp=$3
    radius=$4
    level=$5

    temp_plot_num=$(cat $temp_file_num)
    echo $(( temp_plot_num+1 )) > $temp_file_num

    temp_file_name="${temp_base_name}.${temp_plot_num}"

    ii_file=${DATA_BASE_FOLDER}/$( $GET_PATH $shape $method $lp $radius $level)/ii.txt
    cut $ii_file -d':' -f2 | nl -w1 > $temp_file_name

    echo $temp_file_name
}

create_plot()
{
    shape=$1; shift;
    radius=$1; shift;

    PLOT_STRING="${OUTPUT_BASE_FOLDER}/$( $GET_PATH $shape improve 0 $radius 1)/level-effect.eps ${shape^}"
    while [ -n "$1" ]
    do
        level=$1; shift;
        PLOT_STRING="${PLOT_STRING} $( create_temp_plot_file $shape improve 0 $radius $level ) m=$level "
    done

    echo $PLOT_STRING
    create_multiplot $PLOT_STRING
}


gp_add_plot()
{
    printf "'$1' every 5 u 1:2 w lp ls $3 title '$2',"
}

gp_last_plot()
{
	printf "'$1' every 5 u 1:2 w lp ls $3 title '$2';"
}

create_plot triangle 5 1 3 4 5
create_plot flower 5 1 3 4 5
create_plot bean 5 1 3 4 5
create_plot square 5 1 3 4 5

create_plot triangle 9 1 5 7 9
create_plot flower 9 1 5 7 9
create_plot bean 9 1 5 7 9
create_plot square 9 1 5 7 9

temp_plot_num=$(cat $temp_file_num)
while [ $temp_plot_num -gt 1 ]
do
    temp_plot_num=$(( $temp_plot_num-1 ))
    rm "${temp_base_name}.${temp_plot_num}"
done
rm $temp_file_num
