#!/usr/bin/env bash

SCRIPT_FOLDER=$( cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)
PROJECT_PATH=$( cd $SCRIPT_FOLDER && cd ../.. && pwd )

DATA_FOLDER=${SCRIPT_FOLDER}/input
EXT_FOLDER=${SCRIPT_FOLDER}/ext
OUTPUT_FOLDER=${SCRIPT_FOLDER}/output/segmentation/comparison

mkdir -p ${OUTPUT_FOLDER}/schoenemann

replace_line()
{
    FILE=$1
    LINE_NUMBER=$2
    NEW_TEXT="$3"

    T1=$(($LINE_NUMBER - 1))
    T2=$(($LINE_NUMBER + 1))

    head $FILE -n$T1 > .temp.part1
    tail $FILE -n+$T2 > .temp.part2

    echo $NEW_TEXT >> .temp.part1
    cat .temp.part1 .temp.part2 > $1

    rm .temp.part1 .temp.part2
}

find_line_number_first_ocurrence()
{
    TEXT_TO_FIND="$1"
    FILE=$2

    echo $(grep "${TEXT_TO_FIND}"  $FILE -n | head -n1 | cut -d: -f1)
}

configure_schoenemann()
{
    CBC_BUILD=${EXT_FOLDER}/cbc-build
    export LD_LIBRARY_PATH=${CBC_BUILD}/lib:$LD_LIBRARY_PATH

    if [ ! -d ${CBC_BUILD} ]
    then
        cd ${EXT_FOLDER}
        git clone --branch=stable/2.9 https://github.com/coin-or/Cbc Cbc-2.9
        cd Cbc-2.9
        git clone --branch=stable/0.8 https://github.com/coin-or-tools/BuildTools/
        ./BuildTools/get.dependencies.sh fetch
        ./configure --prefix=${CBC_BUILD}
        make install
        cd ${SCRIPT_FOLDER}

        LINE=$(find_line_number_first_ocurrence "COININCLUDEDIR =" "${EXT_FOLDER}/RegionCurv/Makefile")
        replace_line "${EXT_FOLDER}/RegionCurv/Makefile" ${LINE} "COININCLUDEDIR = ${EXT_FOLDER}/cbc-build/include"

        LINE=$(find_line_number_first_ocurrence "COINLIBDIR =" "${EXT_FOLDER}/RegionCurv/Makefile")
        replace_line "${EXT_FOLDER}/RegionCurv/Makefile" ${LINE} "COINLIBDIR = ${EXT_FOLDER}/cbc-build/lib"

        cd ${EXT_FOLDER}/RegionCurv
        make clean
        make
    fi

}

init()
{
    tar -xvf ${EXT_FOLDER}/RegionCurv.tar.bz2 -C ${EXT_FOLDER}
    configure_schoenemann
}


IMAGES_FOLDER=${DATA_FOLDER}/images
SEEDS_FOLDER=${DATA_FOLDER}/seeds

PPM_IMAGES_FOLDER=${DATA_FOLDER}/images-ppm
SCHO_SEEDS_FOLDER=${DATA_FOLDER}/schoenemann/seeds

GRAB_CUT_APP=${PROJECT_PATH}/ext-projects/cmake-build-release/bin/grab-cut
SCHOENEMANN_APP=${EXT_FOLDER}/RegionCurv/bin/interactiveseg.opt.L64


produce_data()
{
    rm -rf ${PPM_IMAGES_FOLDER}
    rm -rf ${SCHO_SEEDS_FOLDER}

    mkdir -p ${PPM_IMAGES_FOLDER}
    mkdir -p ${SCHO_SEEDS_FOLDER}

    #Schoenemann needs ppm images format
    cp ${IMAGES_FOLDER}/*.jpg ${PPM_IMAGES_FOLDER}
    mogrify -format ppm ${PPM_IMAGES_FOLDER}/*.jpg
    rm ${PPM_IMAGES_FOLDER}/*.jpg

    cp -r ${SEEDS_FOLDER}/* ${SCHO_SEEDS_FOLDER}

    for imgName in $(ls ${SCHO_SEEDS_FOLDER})
    do
        echo "Creating SCHO gc-object for ${imgName}"
        $GRAB_CUT_APP ${IMAGES_FOLDER}/${imgName}.jpg \
        ${SCHO_SEEDS_FOLDER}/${imgName}/mask-fg-0.pgm \
        ${SCHO_SEEDS_FOLDER}/${imgName}/mask-bg-0.pgm \
        ${SCHO_SEEDS_FOLDER}/${imgName}/gc-object.xml \
        -u ${SCHO_SEEDS_FOLDER}/${imgName}/mask-pbfg-0.pgm
    done

#    #Schoenemann interprets seeds in the opposite way as boundary-correction
    find ${SCHO_SEEDS_FOLDER} -name *.pgm | xargs -I{} convert {} -negate {}

}

produce_output()
{
    lambda=2.0
    gamma=1.0
    for imgName in $(ls ${SCHO_SEEDS_FOLDER})
    do
        echo "Schoenemann segmentation of image ${imgName}"
        CUR_OUTPUT_FOLDER=${OUTPUT_FOLDER}/schoenemann/lambda-${lambda}/gamma-${gamma}/${imgName}
        mkdir -p ${CUR_OUTPUT_FOLDER}

        $SCHOENEMANN_APP -i "${PPM_IMAGES_FOLDER}/${imgName}.ppm" -lambda ${lambda} -gamma ${gamma} -curv-power 2 \
		-fg-mask "${SCHO_SEEDS_FOLDER}/$imgName/mask-fg-0.pgm" \
		-bg-mask "${SCHO_SEEDS_FOLDER}/$imgName/mask-bg-0.pgm" \
	    -o "${CUR_OUTPUT_FOLDER}/${imgName}.pgm" \
	    -bruckstein \
		-no-trws-reuse > ${CUR_OUTPUT_FOLDER}/log-schoenemann.txt
    done

}

init
produce_data
produce_output
