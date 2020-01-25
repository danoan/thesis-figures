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
    lp=$2
    method=$3
    radius=$4

    temp_plot_num=$(cat $temp_file_num)
    echo $(( temp_plot_num+1 )) > $temp_file_num

    ii_file=${DATA_BASE_FOLDER}/$( $GET_PATH $shape $lp $method $radius)/ii.txt
    temp_file_name="${temp_base_name}.${temp_plot_num}"

    cut $ii_file -d':' -f2 | nl -w1 > $temp_file_name
    echo $temp_file_name
}

create_plot()
{
    shape=$1
    create_multiplot "${OUTPUT_BASE_FOLDER}/$( $GET_PATH $shape 0 improve 3)/radius-effect.eps" "${shape^}" "$( create_temp_plot_file $shape 0 improve 3 )" "r=3" \
        "$( create_temp_plot_file $shape 0 improve 5 )" "r=5" \
        "$( create_temp_plot_file $shape 0 improve 9 )" "r=9"

}


gp_add_plot()
{
    printf "'$1' every 5 u 1:2 w lp ls $3 title '$2',"
}

gp_last_plot()
{
	printf "'$1' every 5 u 1:2 w lp ls $3 title '$2';"
}

create_plot triangle


gp_add_plot()
{
    printf "'$1' every 10 u 1:2 w lp ls $3 title '$2',"
}

gp_last_plot()
{
	printf "'$1' every 10 u 1:2 w lp ls $3 title '$2';"
}
create_plot flower

temp_plot_num=$(cat $temp_file_num)
while [ $temp_plot_num -gt 1 ]
do
    temp_plot_num=$(( $temp_plot_num-1 ))
    rm "${temp_base_name}.${temp_plot_num}"
done
rm $temp_file_num
