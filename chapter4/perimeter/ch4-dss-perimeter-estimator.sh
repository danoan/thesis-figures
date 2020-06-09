#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

APP=${PROJECT_PATH}/cmake-build-release/chapter4/perimeter/ch4-dss-perimeter-estimator
OUTPUT_FOLDER=/home/daniel/Projects/GIT/PhD/thesis-figures/chapter4/perimeter/output/perimeter

$APP 1.0 ${OUTPUT_FOLDER}

epstopdf ${OUTPUT_FOLDER}/flower.eps
rm ${OUTPUT_FOLDER}/flower.eps