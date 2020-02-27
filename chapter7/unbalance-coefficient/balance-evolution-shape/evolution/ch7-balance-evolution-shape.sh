#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
CREATE_PLOTS_SCRIPT=${SCRIPT_PATH}/create-plots.sh
OUTPUT_FOLDER=${SCRIPT_PATH}/output

shapes="square flower triangle bean"
radii="0.5 1 3 5 7"
kp="0 0.01   0.01  0.1  0.1 0.2   0.2 0.3    0.3 0.4   0.4 0.5"
km="-0.01 0   -0.1 -0.01   -0.2 -0.1  -0.3 -0.2  -0.4 -0.3  -0.5 -0.4"

#kp="0 0.01   0.01  0.03   0.03  0.07  0.07  0.1  0.1 0.12  0.12 0.15   0.15 0.2"
#km="-0.01 0   -0.03  -0.01   -0.07  -0.03  -0.1  -0.07  -0.12 -0.1  -0.15 -0.12   -0.2 -0.15"

create_plots_sequence()
{
    shape=$1; shift;
    radius=$1; shift;
    output_folder=$1; shift;
    k1=$1; shift;
    k2=$1; shift;

    while [ -n "$k1" ]
    do
        $CREATE_PLOTS_SCRIPT $radius $k1 $k2 $shape ${output_folder}
        k1=$1; shift;
        k2=$1; shift;
    done
}

for s in $shapes
do
    for r in $radii
    do
        create_plots_sequence $s $r "${OUTPUT_FOLDER}/k+" $kp
        create_plots_sequence $s $r "${OUTPUT_FOLDER}/k-" $km
    done
done


