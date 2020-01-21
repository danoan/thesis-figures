#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

INPUT_FOLDER=${SCRIPT_PATH}/input
OUTPUT_FOLDER=${SCRIPT_PATH}/output/mdca-sensitivity

MDCA_SENSITIVITY_APP=${PROJECT_PATH}/cmake-build-release/chapter5/mdca-sensitivity/ch5-mdca-sensitivity
$MDCA_SENSITIVITY_APP $INPUT_FOLDER $OUTPUT_FOLDER

find $OUTPUT_FOLDER -name "*.eps" | xargs -I{} epstopdf {}
find $OUTPUT_FOLDER -name "*.eps" | xargs -I{} rm {}
