#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

CH7_LEVEL_SET=${PROJECT_PATH}/cmake-build-release/chapter7/level-set/ch7-level-set
OUTPUT_FOLDER=${SCRIPT_PATH}/output/level-set

${CH7_LEVEL_SET} flower 0.5 12 169 ${OUTPUT_FOLDER}/flower.eps
epstopdf ${OUTPUT_FOLDER}/flower.eps
rm ${OUTPUT_FOLDER}/flower.eps





