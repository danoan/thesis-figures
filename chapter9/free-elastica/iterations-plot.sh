#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

source ${PROJECT_PATH}/plot-scripts/graph-plot.sh
pointInterval=20

SHAPES=$1
LENGTH_PEN=$2
RADIUS=$3
BASE_DATA_FOLDER=$4
BASE_OUTPUT_FOLDER=$5

#echo "$SHAPES - $LENGTH_PEN - $RADIUS - $BASE_DATA_FOLDER -$BASE_OUTPUT_FOLDER"


gp_plot_config()
{
    lenpen=$( echo $LENGTH_PEN | xargs -I{} printf "%.3f" {} | tr , .)
	printf "set title '$1';
	set key right top;
	set logscale y 2;
	set pointintervalbox 20;
	set yrange[0.25:];
	set xlabel 'Iterations';
	set ylabel 'Elastica ({/Symbol a}=$lenpen, {/Symbol b}=1)';"
}

gp_last_plot()
{
	printf "'$1' u 1:2 w lp ls $3 title '$2';"
    v=$(python -c "import math; print(4*math.pi*(${LENGTH_PEN}**0.5))")
    printf "set arrow 10 from 0,$v to graph 1, first $v nohead lw 3 dt 2 front;"
}

prefix_input()
{
    model=$1
    shape=$2
    length_pen=$3
    radius=$4


    echo ${BASE_DATA_FOLDER}/${model}/${shape}/len_pen-${length_pen}/radius-${radius}
}


APP_IMAGE_ESTIMATOR=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-image-estimator
ii_5_estimation()
{
    model=$1
    shape=$2
    gs=$3
    lp=$4

    x=$( ${APP_IMAGE_ESTIMATOR} -mall-in-folder -f"$( prefix_input ${model} ${shape} $LENGTH_PEN $RADIUS )" -eelastica-ii -h${gs} -r5 -a${lp} | sort | cut -d" " -f2 | nl -nln)
    echo "$x"
}

unique_name()
{
    model=$1
    len_pen=$2
    radius=$3

    echo ".temp_${model}_${len_pen}_${radius}_data"
}

build_plot()
{
    MODELS="localsearch flipflow balanceflow graphflow"

    for shape in $SHAPES
    do
        OUTPUT_FOLDER="$BASE_OUTPUT_FOLDER/len_pen_$LENGTH_PEN/radius-$RADIUS"

        mkdir -p $OUTPUT_FOLDER

        for model in $MODELS
        do
            ii_5_estimation ${model} ${shape} 0.25 ${LENGTH_PEN} > $( unique_name $model $LENGTH_PEN $RADIUS )
        done

        create_multiplot "$OUTPUT_FOLDER/${shape}.eps" "${shape^}-bRadius=${RADIUS}" \
        $( unique_name "flipflow" $LENGTH_PEN $RADIUS ) "flipflow" \
        $( unique_name "balanceflow" $LENGTH_PEN $RADIUS ) "balanceflow" \
        $( unique_name "graphflow" $LENGTH_PEN $RADIUS ) "graphflow"

#        $( unique_name "localsearch" $LENGTH_PEN $RADIUS ) "localsearch"

        epstopdf "$OUTPUT_FOLDER/${shape}.eps"
        rm "$OUTPUT_FOLDER/${shape}.eps"
    done

    for model in $MODELS
    do
        rm $( unique_name $model $LENGTH_PEN $RADIUS )
    done
}


build_plot
