#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd )
GENERATOR_FOLDER=${SCRIPT_PATH}/instance-generator

BTOOLS_BIN=${PROJECT_PATH}/ext-projects/cmake-build-release/jmiv/bin
GET_PATH=${SCRIPT_PATH}/get-path.sh

tar -xvf ${SCRIPT_PATH}/data/coala.tar.bz2 -C ${SCRIPT_PATH}/data

python3 ${GENERATOR_FOLDER}/generator.py ${BTOOLS_BIN}
python3 ${GENERATOR_FOLDER}/template_render.py

DATA_BASE_FOLDER="${SCRIPT_PATH}/data"
OUTPUT_BASE_FOLDER="${SCRIPT_PATH}/output"

move_to_output()
{
	data=$1
	sq=$2
	length=$3
	it=$4
	rel=$( $GET_PATH  $data $sq $length $it )
	mkdir -p ${OUTPUT_BASE_FOLDER}/${rel}
	cp -r -T ${DATA_BASE_FOLDER}/${rel} ${OUTPUT_BASE_FOLDER}/${rel}
}

move_to_output 0.50 0.00 0.50 50
move_to_output 0.50 1.00 0.50 50

