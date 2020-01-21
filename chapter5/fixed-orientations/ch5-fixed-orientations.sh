#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

EXHAUSTIVE_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-exhaustive-gc-flow
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow



function run_flow()
{
    energy=$1
    len_pen=$2

    INPUT_NAME="curve-1 curve-2 curve-3"
    for inName in $INPUT_NAME
    do
        INPUT_FOLDER=${SCRIPT_PATH}/input/$inName
        DATA_OUTPUT_FOLDER=${SCRIPT_PATH}/data/$energy/len_pen_$len_pen/$inName
        OUTPUT_FOLDER=${SCRIPT_PATH}/output/fixed-orientations/$energy/len_pen_$len_pen/$inName

        $EXHAUSTIVE_APP -S${INPUT_FOLDER}/input.pgm -h0.25 -r5 -i600 -tii -sbest -j1 -a$len_pen -n32 -e$energy -F${INPUT_FOLDER}/pixelMask.pgm ${DATA_OUTPUT_FOLDER}
        $SUMMARY_APP -j5 -p${DATA_OUTPUT_FOLDER}/pixelMask.pgm -d${INPUT_FOLDER}/dirMask.pgm ${DATA_OUTPUT_FOLDER} ${OUTPUT_FOLDER}/summary.eps

        epstopdf ${OUTPUT_FOLDER}/summary.eps
        rm ${OUTPUT_FOLDER}/summary.eps
    done
}


#run_flow selastica 0.1
#run_flow elastica 0.1

run_flow selastica 0.01
run_flow elastica 0.01

#run_flow selastica 0.001
#run_flow elastica 0.001
