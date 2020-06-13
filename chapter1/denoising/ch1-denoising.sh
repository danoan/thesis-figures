#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

IP_LIBRARY=${SCRIPT_PATH}/ext/image-processing

if [ ! -d $IP_LIBRARY ]
then
    cd $SCRIPT_PATH
    mkdir -p ext
    cd ext
    git clone https://github.com/danoan/image-processing.git
fi

EXP_COALA=${IP_LIBRARY}/exp/exp-coala/exp-denoising-2.sh
OUTPUT_FOLDER_1=${IP_LIBRARY}/exp/exp-coala/output/denoise-2

$EXP_COALA

OUTPUT_FOLDER_2=${SCRIPT_PATH}/output/denoising
mv ${OUTPUT_FOLDER_1} $OUTPUT_FOLDER_2
