#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

APP=${PROJECT_PATH}/cmake-build-release/chapter5/m-ring/ch5-m-ring
OUTPUT_FOLDER=${PROJECT_PATH}/chapter5/m-ring/output/m-ring

$APP 4 0.5 ${OUTPUT_FOLDER} flower
for fn in $(ls ${OUTPUT_FOLDER}/*.eps )
do
    epstopdf $fn
done

rm ${OUTPUT_FOLDER}/*.eps