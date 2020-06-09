#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd)

IP_LIBRARY=${SCRIPT_PATH}/ext/image-processing

if [ ! -d $IP_LIBRARY ]
then
    cd $SCRIPT_PATH
    mkdir -p ext
    cd ext
    git clone https://github.com/danoan/image-processing.git
fi

EXP_LEVELS_CURVATURE=${IP_LIBRARY}/exp/exp-coala/exp-levels-rof-curvature.sh

OUTPUT_FOLDER_COALA_CURVATURE="${IP_LIBRARY}/exp/exp-coala/output/levels/with-noise/levels/curvature/coala_noise_2.jpg"
OUTPUT_FOLDER_LOCAL_COALA_CURVATURE=${SCRIPT_PATH}/output/tv-curvature-coala/curvature

mkdir -p $OUTPUT_FOLDER_LOCAL_COALA_CURVATURE

$EXP_LEVELS_CURVATURE

cp ${IP_LIBRARY}/input/img/coala.jpg ${OUTPUT_FOLDER_LOCAL_COALA_CURVATURE}/coala-original.jpg
cp ${IP_LIBRARY}/input/img/coala_noise_2.jpg ${OUTPUT_FOLDER_LOCAL_COALA_CURVATURE}/coala-noise.jpg

cp ${OUTPUT_FOLDER_COALA_CURVATURE}/coala_noise_2.jpg-4.jpg ${OUTPUT_FOLDER_LOCAL_COALA_CURVATURE}/coala-50.jpg
cp ${OUTPUT_FOLDER_COALA_CURVATURE}/coala_noise_2.jpg-7.jpg ${OUTPUT_FOLDER_LOCAL_COALA_CURVATURE}/coala-30.jpg


EXP_LEVELS_ROF=${IP_LIBRARY}/exp/exp-coala/exp-levels-rof.sh

OUTPUT_FOLDER_COALA_TV="${IP_LIBRARY}/exp/exp-coala/output/levels/with-noise/levels/tv/coala_noise_2.jpg"
OUTPUT_FOLDER_LOCAL_COALA_TV=${SCRIPT_PATH}/output/tv-curvature-coala/tv

mkdir -p $OUTPUT_FOLDER_LOCAL_COALA_TV

$EXP_LEVELS_ROF

cp ${OUTPUT_FOLDER_COALA_TV}/coala_noise_2.jpg-4.jpg ${OUTPUT_FOLDER_LOCAL_COALA_TV}/coala-50.jpg
cp ${OUTPUT_FOLDER_COALA_TV}/coala_noise_2.jpg-7.jpg ${OUTPUT_FOLDER_LOCAL_COALA_TV}/coala-30.jpg




