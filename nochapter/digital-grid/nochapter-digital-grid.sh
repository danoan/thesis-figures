#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

DIGITAL_GRID_APP=${PROJECT_PATH}/cmake-build-release/nochapter/digital-grid/nochapter-digital-grid
OUTPUT_FOLDER=${SCRIPT_PATH}/output


${DIGITAL_GRID_APP} ${OUTPUT_FOLDER}

convert_to_png()
{
    BASE_FOLDER=$1
    for f in $(ls $1)
    do
        inkscape -z -e ${BASE_FOLDER}/$(basename -s.svg $f).png -w 1024 -h 1024 ${BASE_FOLDER}/$f
    done
}

convert_to_png $OUTPUT_FOLDER