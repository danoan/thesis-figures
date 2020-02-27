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
    DATA_FOLDER=$3
    OUTPUT_FOLDER=$4

    mkdir -p $DATA_FOLDER
    mkdir -p $OUTPUT_FOLDER

    ${GRAPH_FLOW_APP} -r9 -i400 -S${shape} -N${neigh} $DATA_FOLDER
    ${SUMMARY_APP} $DATA_FOLDER ${OUTPUT_FOLDER}/summary.eps -j10

    epstopdf ${OUTPUT_FOLDER}/summary.eps
    rm ${OUTPUT_FOLDER}/summary.eps

    cp ${DATA_FOLDER}/inputData.txt ${OUTPUT_FOLDER}/inputData.txt
}


SHAPE="triangle flower bean"
NEIGH="0 2"


for shape in $SHAPE
do
    for neigh in $NEIGH
    do
        DATA_FOLDER=${BASE_DATA_FOLDER}/${shape}/neigh-${neigh}
        OUTPUT_FOLDER=${BASE_OUTPUT_FOLDER}/${shape}/neigh-${neigh}

        flow_and_summary $shape $neigh $DATA_FOLDER $OUTPUT_FOLDER&
    done
done