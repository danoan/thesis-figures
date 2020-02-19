#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

DIGITIZATION_APP=${PROJECT_PATH}/cmake-build-release/nochapter/digitization/nochapter-digitization
BASE_OUTPUT_FOLDER=${SCRIPT_PATH}/output

OUTPUT_FOLDER_ZERO=${BASE_OUTPUT_FOLDER}/zero
OUTPUT_FOLDER_SHIFT=${BASE_OUTPUT_FOLDER}/shift

mkdir -p $OUTPUT_FOLDER_ZERO
mkdir -p $OUTPUT_FOLDER_SHIFT

${DIGITIZATION_APP} 1.0 0 0 ${OUTPUT_FOLDER_ZERO}/h1.svg
${DIGITIZATION_APP} 0.5 0 0 ${OUTPUT_FOLDER_ZERO}/h05.svg
${DIGITIZATION_APP} 0.25 0 0 ${OUTPUT_FOLDER_ZERO}/h025.svg

${DIGITIZATION_APP} 1.0 0.75 0.3 ${OUTPUT_FOLDER_SHIFT}/h1.svg
${DIGITIZATION_APP} 0.5 0.75 0.3 ${OUTPUT_FOLDER_SHIFT}/h05.svg
${DIGITIZATION_APP} 0.25 0.75 0.3 ${OUTPUT_FOLDER_SHIFT}/h025.svg

convert_to_png()
{
    BASE_FOLDER=$1
    for f in $(ls $1)
    do
        inkscape -z -e ${BASE_FOLDER}/$(basename -s.svg $f).png -w 1024 -h 1024 ${BASE_FOLDER}/$f
    done
}

convert_to_png $OUTPUT_FOLDER_ZERO
convert_to_png $OUTPUT_FOLDER_SHIFT