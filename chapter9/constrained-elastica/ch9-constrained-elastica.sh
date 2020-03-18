#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

BASE_INPUT_FOLDER=${SCRIPT_PATH}/input
BASE_DATA_FOLDER=${SCRIPT_PATH}/data
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/constrained-elastica

LOCAL_SEARCH=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-exhaustive-gc-flow
FLIP_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin/shape-flow
BALANCE_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/shape-flow
GRAPH_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/graph-flow-app

SUMMARY_FLOW=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow


INPUT_NAME="curve-2 curve-3 flower-1 flower-2"
#INPUT_NAME="flower-2"

localsearch()
{
    inputName=$1
    nc=$2
    alpha=$3
    radius=$4

        INPUT_FOLDER=${BASE_INPUT_FOLDER}/${inputName}
        DATA_FOLDER=${BASE_DATA_FOLDER}/localsearch/${inputName}/len_pen-${alpha}/radius-${radius}/nc-${nc}/h1.0
        OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/localsearch/${inputName}/len_pen-${alpha}/radius-${radius}/nc-${nc}/h1.0

        mkdir -p $DATA_FOLDER
        mkdir -p $OUTPUT_FOLDER

        masks="-p${DATA_FOLDER}/pixelMask.pgm -d${INPUT_FOLDER}/dirMask-ls.pgm"
        if [ "$inputName" = "flower-1" -o "$inputName" = "flower-2" ]
        then
            masks="-d${DATA_FOLDER}/pixelMask.pgm"
        fi

        $LOCAL_SEARCH -S${INPUT_FOLDER}/input.pgm -j1 -i400 -eelastica -a${alpha} -sbest -h1.0 -tii -r${radius} -n32 -F${INPUT_FOLDER}/pixelMask.pgm $DATA_FOLDER
        $SUMMARY_FLOW -j10 ${masks} ${DATA_FOLDER} ${OUTPUT_FOLDER}/summary.eps

        epstopdf ${OUTPUT_FOLDER}/summary.eps
        rm ${OUTPUT_FOLDER}/summary.eps
        cp ${DATA_FOLDER}/inputData.txt ${OUTPUT_FOLDER}/inputData.txt
        cp ${DATA_FOLDER}/energy.txt ${OUTPUT_FOLDER}/energy.txt

}

graphflow()
{
    inputName=$1
    N=$2
    alpha=$3
    radius=$4


    INPUT_FOLDER=${BASE_INPUT_FOLDER}/${inputName}
    DATA_FOLDER=${BASE_DATA_FOLDER}/graphflow/${inputName}/len_pen-${alpha}/radius-${radius}/N-${N}/h1.0
    OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/graphflow/${inputName}/len_pen-${alpha}/radius-${radius}/N-${N}/h1.0

    rm -rf $DATA_FOLDER && mkdir -p $DATA_FOLDER
    rm -rf $OUTPUT_FOLDER && mkdir -p $OUTPUT_FOLDER

    masks="-p${DATA_FOLDER}/pixelMask.pgm -d${INPUT_FOLDER}/dirMask.pgm"
    if [ "$inputName" = "flower-1" -o "$inputName" = "flower-2" ]
    then
        masks="-d${DATA_FOLDER}/pixelMask.pgm"
    fi

    $GRAPH_FLOW -S${INPUT_FOLDER}/input.pgm -i400 -eelastica -a${alpha} -h1.0 -r${radius} -O2 -n6 -N${N} -P${INPUT_FOLDER}/pixelMask.pgm $DATA_FOLDER
    $SUMMARY_FLOW -j10 ${masks} ${DATA_FOLDER} ${OUTPUT_FOLDER}/summary.eps

    epstopdf ${OUTPUT_FOLDER}/summary.eps
    rm ${OUTPUT_FOLDER}/summary.eps
    cp ${DATA_FOLDER}/inputData.txt ${OUTPUT_FOLDER}/inputData.txt
    cp ${DATA_FOLDER}/energy.txt ${OUTPUT_FOLDER}/energy.txt

}

N="1"
NC="4"
ALPHA="0.002 0.0002"
RADIUS="7 15 50"

for inputName in $INPUT_NAME
do
    for alpha in $ALPHA
    do
        for radius in $RADIUS
        do
            for n in $N
            do

                graphflow $inputName $n $alpha $radius
            done

            for nc in $NC
            do
                localsearch $inputName $nc $alpha $radius
            done
        done
    done
done

