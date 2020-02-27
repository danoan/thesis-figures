#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../../ && pwd )

${SCRIPT_PATH}/level-minus-2.sh
${SCRIPT_PATH}/level-proportional.sh

