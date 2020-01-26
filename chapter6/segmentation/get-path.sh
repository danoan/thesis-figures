#! /usr/bin/env bash

SCRIPT_PATH=$( cd $( dirname "${BASH_SOURCE[0]}") > /dev/null 2>&1 && pwd  )
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

data=$1
sq=$2
length=$3
it=$4

echo "segmentation/coala/mt_improve/radius_5/data_$data/sq_$sq/length_$length/it_$it"
