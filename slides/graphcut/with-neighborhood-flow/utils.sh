#!/usr/bin/env bash

function get_instance_path_r(){
    IMAGE_ROOT_FOLDER=$1
    SHAPE=$2
    LEN_PEN=$3
    RADIUS=$4

#    echo ${IMAGE_ROOT_FOLDER}/${SHAPE}/radius_${RADIUS}/opt_band_2/neigh_size_2/len_pen_${LEN_PEN}/gs_0.12500
    echo ${IMAGE_ROOT_FOLDER}/${SHAPE}/radius_${RADIUS}
}

function get_instance_path(){
    echo $(get_instance_path_r $1 $2 $3 16)
}

function get_values_file(){
    IMAGE_ROOT_FOLDER=$1
    SHAPE=$2
    LEN_PEN=$3

    echo $(get_instance_path ${IMAGE_ROOT_FOLDER} ${SHAPE} ${LEN_PEN})/energy.txt
}

function get_summary_file(){
    IMAGE_ROOT_FOLDER=$1
    SHAPE=$2
    LEN_PEN=$3

    echo $(get_instance_path ${IMAGE_ROOT_FOLDER} ${SHAPE} ${LEN_PEN})/summary.eps
}