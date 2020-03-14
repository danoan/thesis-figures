#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

BASE_DATA_FOLDER=${SCRIPT_PATH}/data
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output/graph-flow

GRAPH_FLOW_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/graph-flow-app
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow


flow_and_summary()
{
    shape=$1
    neigh=$2
    alpha=$3
    DATA_FOLDER=$4
    OUTPUT_FOLDER=$5

    ropt=$( python3 -c "print('{}'.format(1.0/pow($alpha,0.5)))" )
#    echo "$shape - $neigh - $alpha - $DATA_FOLDER - $OUTPUT_FOLDER"

    mkdir -p $DATA_FOLDER
    mkdir -p $OUTPUT_FOLDER

    ${GRAPH_FLOW_APP} -r9 -i400 -S${shape} -a${alpha} -B${ropt} -N${neigh} $DATA_FOLDER
    ${SUMMARY_APP} $DATA_FOLDER ${OUTPUT_FOLDER}/summary.eps -j10 -r${ropt} -h0.25

    epstopdf ${OUTPUT_FOLDER}/summary.eps
    rm ${OUTPUT_FOLDER}/summary.eps

    cp ${DATA_FOLDER}/inputData.txt ${OUTPUT_FOLDER}/inputData.txt
}


NEIGH="0 2"
ALPHA="0.01 0.001"


for neigh in $NEIGH
do
    for alpha in $ALPHA
    do
        DATA_FOLDER=${BASE_DATA_FOLDER}/triangle/neigh-${neigh}/alpha-${alpha}
        OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/triangle/neigh-${neigh}/alpha-${alpha}

        flow_and_summary "triangle" $neigh $alpha $DATA_FOLDER $OUTPUT_FOLDER &
    done
done