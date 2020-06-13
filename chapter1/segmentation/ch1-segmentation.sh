#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

python3 ${SCRIPT_PATH}/geodesic_and_cv_seg.py
