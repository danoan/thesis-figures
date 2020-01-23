#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$(cd $SCRIPT_PATH && cd ../.. && pwd )

FIG_APP=${PROJECT_PATH}/cmake-build-release/chapter6/complement-reasoning/ch6-complement-reasoning

OUTPUT_FOLDER=${SCRIPT_PATH}/output/complement-reasoning
DATA_FOLDER=${SCRIPT_PATH}/data
$FIG_APP $DATA_FOLDER/1.png $OUTPUT_FOLDER