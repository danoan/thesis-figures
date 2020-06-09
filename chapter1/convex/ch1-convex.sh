#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

python3 ${SCRIPT_PATH}/local_minimum.py

OUTPUT_FOLDER=${SCRIPT_PATH}/output/convex
mv ${OUTPUT_FOLDER}/out_lbda_1_ballmixnoisy.png ${OUTPUT_FOLDER}/lbda_1.png