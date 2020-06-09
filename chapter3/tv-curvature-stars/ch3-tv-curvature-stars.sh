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

EXP_LEVELS_CURVATURE=${IP_LIBRARY}/exp/exp-stars/exp-levels-rof-curvature.sh

OUTPUT_FOLDER_STARS_CURVATURE="${IP_LIBRARY}/exp/exp-stars/output/levels/curvature/stars-mini.png"
OUTPUT_FOLDER_LOCAL_STARS_CURVATURE=${SCRIPT_PATH}/output/tv-curvature-stars/curvature

mkdir -p $OUTPUT_FOLDER_LOCAL_STARS_CURVATURE

$EXP_LEVELS_CURVATURE

cp ${IP_LIBRARY}/input/img/stars-mini.png ${OUTPUT_FOLDER_LOCAL_STARS_CURVATURE}/stars.png

cp ${OUTPUT_FOLDER_STARS_CURVATURE}/stars-mini.png-9.jpg ${OUTPUT_FOLDER_LOCAL_STARS_CURVATURE}/stars-25.png
cp ${OUTPUT_FOLDER_STARS_CURVATURE}/stars-mini.png-11.jpg ${OUTPUT_FOLDER_LOCAL_STARS_CURVATURE}/stars-15.png

cp ${OUTPUT_FOLDER_STARS_CURVATURE}/color-levels/stars-mini.png-9.jpg.png ${OUTPUT_FOLDER_LOCAL_STARS_CURVATURE}/levels-stars-25.png
cp ${OUTPUT_FOLDER_STARS_CURVATURE}/color-levels/stars-mini.png-11.jpg.png ${OUTPUT_FOLDER_LOCAL_STARS_CURVATURE}/levels-stars-15.png




EXP_LEVELS_TV=${IP_LIBRARY}/exp/exp-stars/exp-levels-rof.sh

OUTPUT_FOLDER_STARS_TV="${IP_LIBRARY}/exp/exp-stars/output/levels/tv/stars-mini.png"
OUTPUT_FOLDER_LOCAL_STARS_TV=${SCRIPT_PATH}/output/tv-curvature-stars/tv

mkdir -p $OUTPUT_FOLDER_LOCAL_STARS_TV

$EXP_LEVELS_TV

cp ${IP_LIBRARY}/input/img/stars-mini.png ${OUTPUT_FOLDER_LOCAL_STARS_TV}/stars.png

cp ${OUTPUT_FOLDER_STARS_TV}/stars-mini.png-9.jpg ${OUTPUT_FOLDER_LOCAL_STARS_TV}/stars-25.png
cp ${OUTPUT_FOLDER_STARS_TV}/stars-mini.png-11.jpg ${OUTPUT_FOLDER_LOCAL_STARS_TV}/stars-15.png

cp ${OUTPUT_FOLDER_STARS_TV}/color-levels/stars-mini.png-9.jpg.png ${OUTPUT_FOLDER_LOCAL_STARS_TV}/levels-stars-25.png
cp ${OUTPUT_FOLDER_STARS_TV}/color-levels/stars-mini.png-11.jpg.png ${OUTPUT_FOLDER_LOCAL_STARS_TV}/levels-stars-15.png

