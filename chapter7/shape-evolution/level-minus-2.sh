#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_FOLDER=$( cd $SCRIPT_PATH && cd ../../ && pwd )

source ${SCRIPT_PATH}/flow.sh

EXP_NAME=level-minus-2

function flow_group()
{
    SHAPE=$1
    flow $SHAPE 0.5 2 $EXP_NAME &
    flow $SHAPE 0.5 2 $EXP_NAME -u&
    flow $SHAPE 0.25 4 $EXP_NAME &
    flow $SHAPE 0.25 4 $EXP_NAME -u&
    flow $SHAPE 0.125 8 $EXP_NAME &
    flow $SHAPE 0.125 8 $EXP_NAME -u
}

#flow_group triangle
flow_group square
flow_group flower
flow_group bean
