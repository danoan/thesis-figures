#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)


SHAPE_GIF=$1
PLOT_GIF=$2
NAME=$3
OUTPUT_FILEPATH=$4
CACHE_TEMP_PATH=$5

NFRAMES=$( identify $SHAPE_GIF | wc -l )

FRAMES_FOLDER=${SCRIPT_PATH}/output/${NAME}/frames
mkdir -p $FRAMES_FOLDER

convert $PLOT_GIF -coalesce ${FRAMES_FOLDER}/pf-%04d.gif
convert $SHAPE_GIF -coalesce ${FRAMES_FOLDER}/sf-%04d.gif

SINGLE_FOLDER=${SCRIPT_PATH}/output/${NAME}/single
mkdir -p $SINGLE_FOLDER

i=0
while [ $i -lt $NFRAMES ]
do
    pi=$( printf "%04d" $i )
    convert "${FRAMES_FOLDER}/pf-${pi}.gif" "${FRAMES_FOLDER}/sf-${pi}.gif" +append "${SINGLE_FOLDER}/${pi}.gif"
    i=$(( i+1 ))
done

convert -delay 10 ${SINGLE_FOLDER}/*.gif ${OUTPUT_FILEPATH}

rm -rf ${FRAMES_FOLDER}
rm -rf ${SINGLE_FOLDER}
