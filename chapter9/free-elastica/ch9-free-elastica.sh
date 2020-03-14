#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

INPUT_FOLDER=${SCRIPT_PATH}/input
BASE_DATA_FOLDER=${SCRIPT_PATH}/data
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/free-elastica

LOCAL_SEARCH=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-exhaustive-gc-flow
FLIP_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/shape-flow
BALANCE_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/shape-flow
GRAPH_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/graph-flow-app

SUMMARY_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow


localsearch()
{
    SHAPES=$1
    alpha=$2
    radius=$3

    rOpt=$( python3 -c "print('{}'.format(1.0/(pow($alpha,0.5))))" )
    for shape in $SHAPES
    do
        DATA_FOLDER=${BASE_DATA_FOLDER}/localsearch/${shape}/len_pen-${alpha}/radius-${radius}
        OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/localsearch/${shape}/len_pen-${alpha}/radius-${radius}

        mkdir -p $DATA_FOLDER
        mkdir -p $OUTPUT_FOLDER

        $LOCAL_SEARCH -j1 -i400 -eelastica -a${alpha} -S${shape} -sbest -h0.25 -V4 -tii -r${radius} -n32 $DATA_FOLDER
        $SUMMARY_FLOW -j10 -r${rOpt} -h0.25 ${DATA_FOLDER} ${OUTPUT_FOLDER}/summary.eps

        epstopdf ${OUTPUT_FOLDER}/summary.eps
        rm ${OUTPUT_FOLDER}/summary.eps
        cp ${DATA_FOLDER}/inputData.txt ${OUTPUT_FOLDER}/inputData.txt
        cp ${DATA_FOLDER}/energy.txt ${OUTPUT_FOLDER}/energy.txt

        #To avoid problems in app-image-estimator
        rm ${DATA_FOLDER}/pixelMask.pgm

    done
}

flipflow()
{

    SHAPES=$1
    alpha=$2
    radius=$3

    rOpt=$( python3 -c "print('{}'.format(1.0/(pow($alpha,0.5))))" )
    for shape in $SHAPES
    do
        DATA_FOLDER=${BASE_DATA_FOLDER}/flipflow/${shape}/len_pen-${alpha}/radius-${radius}
        OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/flipflow/${shape}/len_pen-${alpha}/radius-${radius}

        mkdir -p $DATA_FOLDER
        mkdir -p $OUTPUT_FOLDER

        $FLIP_FLOW -r${radius} -i400 -pdouble -l-2 -q1.0 -t0 -g${alpha} -S${shape} -h0.25 -faround-contour $DATA_FOLDER
        $SUMMARY_FLOW -j10 -r${rOpt} -h0.25 ${DATA_FOLDER} ${OUTPUT_FOLDER}/summary.eps

        epstopdf ${OUTPUT_FOLDER}/summary.eps
        rm ${OUTPUT_FOLDER}/summary.eps
        cp ${DATA_FOLDER}/input-data.txt ${OUTPUT_FOLDER}/input-data.txt
        cp ${DATA_FOLDER}/${shape}.txt ${OUTPUT_FOLDER}/${shape}.txt

    done
}

balanceflow()
{
    SHAPES=$1
    alpha=$2
    radius=$3


    rOpt=$( python3 -c "print('{}'.format(1.0/(pow($alpha,0.5))))" )
    for shape in $SHAPES
    do
        DATA_FOLDER=${BASE_DATA_FOLDER}/balanceflow/${shape}/len_pen-${alpha}/radius-${radius}
        OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/balanceflow/${shape}/len_pen-${alpha}/radius-${radius}

        mkdir -p $DATA_FOLDER
        mkdir -p $OUTPUT_FOLDER

        $BALANCE_FLOW -r${radius} -i400 -l-2 -q1.0 -t0 -g${alpha} -S${shape} -h0.25 -faround-contour -O1 $DATA_FOLDER
        $SUMMARY_FLOW -j10 -r${rOpt} -h0.25 ${DATA_FOLDER} ${OUTPUT_FOLDER}/summary.eps

        epstopdf ${OUTPUT_FOLDER}/summary.eps
        rm ${OUTPUT_FOLDER}/summary.eps
        cp ${DATA_FOLDER}/input-data.txt ${OUTPUT_FOLDER}/input-data.txt
        cp ${DATA_FOLDER}/${shape}.txt ${OUTPUT_FOLDER}/${shape}.txt

    done
}


graphflow()
{
    SHAPES=$1
    alpha=$2
    radius=$3


    rOpt=$( python3 -c "print('{}'.format(1.0/(pow($alpha,0.5))))" )
    border=$( python3 -c "print('{}'.format(${rOpt}))" )
    for shape in $SHAPES
    do
        DATA_FOLDER=${BASE_DATA_FOLDER}/graphflow/${shape}/len_pen-${alpha}/radius-${radius}
        OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/graphflow/${shape}/len_pen-${alpha}/radius-${radius}

        mkdir -p $DATA_FOLDER
        mkdir -p $OUTPUT_FOLDER

        $GRAPH_FLOW -S${shape} -i400 -r${radius} -v5 -eelastica -h0.25 -a${alpha} -b1.0 -B${border} -O3 -N2 -n6 $DATA_FOLDER
        $SUMMARY_FLOW -j10 -r${rOpt} -h0.25 ${DATA_FOLDER} ${OUTPUT_FOLDER}/summary.eps

        epstopdf ${OUTPUT_FOLDER}/summary.eps
        rm ${OUTPUT_FOLDER}/summary.eps
        cp ${DATA_FOLDER}/inputData.txt ${OUTPUT_FOLDER}/inputData.txt
        cp ${DATA_FOLDER}/energy.txt ${OUTPUT_FOLDER}/energy.txt

    done
}

main_experiment()
{
    SHAPES="triangle square flower bean ellipse"
    alpha="0.01"

    graphflow "$SHAPES" $alpha 7 &
    flipflow "$SHAPES" $alpha 7 &
    balanceflow "$SHAPES" $alpha 7
    localsearch "$SHAPES" $alpha 7

    ${SCRIPT_PATH}/iterations-plot.sh "$SHAPES" $alpha 7 $BASE_DATA_FOLDER ${BASE_OUTPUT_FOLDER}/plots/iteration/main_experiment
}

radius_choice()
{
    SHAPES="triangle flower"
    alpha="0.001"
    RADIUS="7 12"


    for radius in $RADIUS
    do
        graphflow "$SHAPES" $alpha $radius &
        flipflow "$SHAPES" $alpha $radius &
        balanceflow "$SHAPES" $alpha $radius
        localsearch "$SHAPES" $alpha $radius

        ${SCRIPT_PATH}/iterations-plot.sh "$SHAPES" $alpha $radius $BASE_DATA_FOLDER ${BASE_OUTPUT_FOLDER}/plots/iteration/radius_choice
    done
}

main_experiment&
radius_choice