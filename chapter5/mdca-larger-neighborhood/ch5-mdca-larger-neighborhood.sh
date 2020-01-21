#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

EXHAUSTIVE_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/app-exhaustive-gc-flow
SUMMARY_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/summary-flow


larger_neighborhood()
{

    shape=$1
    len_pen=$2
    optBallRadius=$(python -c"print(${len_pen}**(-0.5))")

    H="1.0 0.5 0.25"
    for h in $H
    do
        DATA_OUTPUT_FOLDER=${SCRIPT_PATH}/data/$shape/$len_pen/$h
        ${EXHAUSTIVE_APP} -S$shape -j1 -i600 -D2 -E1 -V5 -eelastica -a$len_pen -sbest -tmdca -h$h -n32 $DATA_OUTPUT_FOLDER

        OUTPUT_FOLDER=${SCRIPT_PATH}/output/mdca-larger-neighborhood/$shape/$len_pen/$h
        $SUMMARY_APP -j5 -r$optBallRadius -h$h $DATA_OUTPUT_FOLDER ${OUTPUT_FOLDER}/summary.eps

        epstopdf ${OUTPUT_FOLDER}/summary.eps
        rm ${OUTPUT_FOLDER}/summary.eps
    done
}


larger_neighborhood flower 0.01
larger_neighborhood triangle 0.01

