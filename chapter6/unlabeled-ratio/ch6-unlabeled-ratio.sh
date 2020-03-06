#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
AUX_SCRIPT_PATH=$( cd $SCRIPT_PATH && cd ../aux-scripts && pwd )
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd )


DATA_FOLDER=${SCRIPT_PATH}/data
OUTPUT_FOLDER=${SCRIPT_PATH}/output/unlabeled-ratio

mkdir -p ${DATA_FOLDER}
mkdir -p ${OUTPUT_FOLDER}

PLOT_SCRIPT_FOLDER=${PROJECT_PATH}/plot-scripts

UNLABELED_RATIO_APP=${PROJECT_PATH}/cmake-build-release/chapter6/unlabeled-ratio/ch6-unlabeled-ratio
SHAPE_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/shape-flow

###########FLOW DATA###########
generate_flow()
{
    shape=$1
    method=$2
    gs=$3
    radius=$4

    i=1
    while [ $i -le $radius ]
    do
        FLOW_OUTPUT_FOLDER=${DATA_FOLDER}/flows/h$gs/radius-$radius/$shape/$method
        $SHAPE_FLOW_APP -r$radius -S$shape -h$gs -m$method -q1.0 -t0 -g0 -l$i -pdouble -i100 $FLOW_OUTPUT_FOLDER/L$i&
        i=$[$i+1]
    done

    wait

}

collection_flow()
{
    shape=$1
    gs=$2

    generate_flow $shape probe $gs 3 &
    generate_flow $shape improve $gs 3 &

    generate_flow $shape probe $gs 5 &
    generate_flow $shape improve $gs 5

    generate_flow $shape probe $gs 7 &
    generate_flow $shape improve $gs 7 &

    generate_flow $shape probe $gs 9 &
    generate_flow $shape improve $gs 9

}

###########UNLABELED EVOLUTION DATA###########
unlabeled_evolution()
{
    shape=$1
    method=$2
    mode=$3
    gs=$4
    radius=$5

    $UNLABELED_RATIO_APP ${DATA_FOLDER}/flows/h$gs/radius-$radius/$shape/probe/L$radius \
    ${DATA_FOLDER}/unlabeled-evolution/h$gs/radius-$radius/$shape/$method/$mode $method $mode $radius
}

collection_unlabeled_evolution()
{
    shape=$1
    gs=$2

    unlabeled_evolution $shape probe concavities $gs 3&
    unlabeled_evolution $shape probe convexities $gs 3&

    unlabeled_evolution $shape probe concavities $gs 5&
    unlabeled_evolution $shape probe convexities $gs 5&


    unlabeled_evolution $shape probe concavities $gs 7&
    unlabeled_evolution $shape probe convexities $gs 7&

    unlabeled_evolution $shape probe concavities $gs 9&
    unlabeled_evolution $shape probe convexities $gs 9
}



########### PLOT DATA ################
unlabeled_evolution_plot()
{
	shape=$1
	mode=$2
	method=$3
	gs=$4
	radius=$5

	PLOTS_OUTPUT=${OUTPUT_FOLDER}/plots/unlabeled-per-iterations/h$gs/radius-$radius
	mkdir -p $PLOTS_OUTPUT

	OUTPUT_PLOT=${PLOTS_OUTPUT}/plot-model-$shape-$mode-$method.eps

	i=1
	PLOT_STRING="$OUTPUT_PLOT ${shape^}(r=$radius)"
	while [ $i -le $radius ]
	do
	    PLOT_STRING="${PLOT_STRING} ${DATA_FOLDER}/unlabeled-evolution/h$gs/radius-$radius/$shape/$method/$mode/level-$i.txt m=$i"
	    i=$[$i+1]
	done


	create_multiplot ${PLOT_STRING}
}

collection_unlabeled_evolution_plot()
{
    shape=$1
    gs=$2

    unlabeled_evolution_plot $shape concavities probe $gs 3
    unlabeled_evolution_plot $shape concavities probe $gs 5
    unlabeled_evolution_plot $shape concavities probe $gs 7
    unlabeled_evolution_plot $shape concavities probe $gs 9
}

lowest_highest_level_plot()
{
	mode=$1
	method=$2
    gs=$3
    radius=$4

    PLOTS_OUTPUT=${OUTPUT_FOLDER}/plots/pairwise-ratio/h$gs/radius-$radius
    mkdir -p $PLOTS_OUTPUT

	OUTPUT_PLOT=${PLOTS_OUTPUT}/plot-pairwiseratio-lowerHigher-$mode-$method.eps

    PLOT_STRING=""
	PLOT_STRING=" ${PLOT_STRING} ${DATA_FOLDER}/unlabeled-evolution/h$gs/radius-$radius/triangle/$method/$mode/level-1.txt triangle(m=1)"
	PLOT_STRING=" ${PLOT_STRING} ${DATA_FOLDER}/unlabeled-evolution/h$gs/radius-$radius/triangle/$method/$mode/level-$radius.txt triangle(m=$radius)"

	PLOT_STRING=" ${PLOT_STRING} ${DATA_FOLDER}/unlabeled-evolution/h$gs/radius-$radius/flower/$method/$mode/level-1.txt flower(m=1)"
	PLOT_STRING=" ${PLOT_STRING} ${DATA_FOLDER}/unlabeled-evolution/h$gs/radius-$radius/flower/$method/$mode/level-$radius.txt flower(m=$radius)"

	create_multiplot $OUTPUT_PLOT "Lowest and Highest Rings (r=5)" $PLOT_STRING

}


produce_flow_data()
{
    collection_flow triangle 0.25
    collection_flow flower 0.25

}

produce_unlabeled_evolution_data()
{
    collection_unlabeled_evolution triangle 0.25
    collection_unlabeled_evolution flower 0.25
}


produce_plot()
{

    collection_unlabeled_evolution_plot triangle 0.25
    collection_unlabeled_evolution_plot flower 0.25
}


source ${PLOT_SCRIPT_FOLDER}/graph-plot.sh

gp_plot_config()
{
    printf "set title '$1';
    set yrange [-0.1:1.1];
    set xlabel 'Iterations';
    set ylabel 'Unlabeled Ratio';"
}


produce_flow_data
produce_unlabeled_evolution_data
produce_plot



gp_plot_config()
{
    printf "set title '$1';
    set yrange [-0.1:0.2];
    set xlabel 'Iterations';
    set ylabel 'Pairwise Ratio';"
}


gp_add_plot()
{
    printf "'$1' u 1:3 w lp ls $3 title '$2',"
}

gp_last_plot()
{
	printf "'$1' u 1:3 w lp ls $3 title '$2';"
}

lowest_highest_level_plot concavities probe 0.25 5

${AUX_SCRIPT_PATH}/move-convert-eps.sh $DATA_FOLDER $OUTPUT_FOLDER
