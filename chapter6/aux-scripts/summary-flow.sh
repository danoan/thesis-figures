#!/usr/bin/env bash


SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

SUMMARY_APP=$1
DATA_FOLDER=$( realpath $2 )
JUMP=$3

TEMP_PATHS=".summary-flow.temp1"
find $DATA_FOLDER -name "input-data.txt" | xargs -I{} realpath {} | xargs -I{} dirname {} > $TEMP_PATHS

function summary()
{
    INPUT_DATA_FOLDER=$1

    echo "${INPUT_DATA_FOLDER} ${INPUT_DATA_FOLDER}/summary.eps"
}

export -f summary
cat $TEMP_PATHS | xargs -I{} bash -c 'summary $@' _ {} | xargs -I{} bash -c "$SUMMARY_APP {} $JUMP"
rm $TEMP_PATHS