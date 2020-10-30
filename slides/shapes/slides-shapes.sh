#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd)

SHAPES_APP="${PROJECT_PATH}/cmake-build-release/slides/shapes/slides-shapes"

OUTPUT_FOLDER=${SCRIPT_PATH}/output/shapes
SHAPES="triangle square flower bean"
for SHAPE in $SHAPES
do
    $SHAPES_APP $SHAPE 0.25 "${OUTPUT_FOLDER}/${SHAPE}.eps"
    convert "${OUTPUT_FOLDER}/${SHAPE}.eps" "${OUTPUT_FOLDER}/${SHAPE}.png"
    rm "${OUTPUT_FOLDER}/${SHAPE}.eps"
done