#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../.. && pwd)

source ${SCRIPT_PATH}/utils.sh
source ${PROJECT_PATH}/slides/utils.sh
source ${PROJECT_PATH}/plot-scripts/graph-plot.sh
pointInterval=5000

gp_plot_config()
{
	printf "set title '$1';
	set key right top;
	set yrange[0:];
	set logscale x 10;
	set xrange[0.1:1000];
	set xtics ('0' 0.1,1,10,100,1000);
	set xlabel 'Iterations';
	set ylabel 'Elastica ({/Symbol a}=1/484, {/Symbol b}=1)';"
}

gp_last_plot()
{
	printf "'$1' u 1:2 w lp ls $3 title '$2';"
    v=$(python -c "import math; print(4*math.pi*(0.0020661157**0.5))")
    printf "set arrow 10 from 0.1,$v to graph 1, first $v nohead lw 3 dt 2 front;"
}

function replace_zero_it_by_01(){
    VALUES_FILE=$1
    TEMP_FOLDER=$2

    cp ${VALUES_FILE} ${TEMP_FOLDER}/${SHAPE}.txt
    VALUES_FILE="${TEMP_FOLDER}/${SHAPE}.txt"

    FIRST_LINE="$(head "${VALUES_FILE}" -n1)"
    FIRST_VALUE=$(echo $FIRST_LINE | cut -d' ' -f2)
    FIRST_LINE=$(echo -e '0.1\t')
    FIRST_LINE=${FIRST_LINE}${FIRST_VALUE}

    echo ${FIRST_LINE} > ${TEMP_FOLDER}/${SHAPE}_up.txt
    tail "${VALUES_FILE}" -n+2 >> ${TEMP_FOLDER}/${SHAPE}_up.txt

    rm ${TEMP_FOLDER}/${SHAPE}.txt
    mv ${TEMP_FOLDER}/${SHAPE}_up.txt ${TEMP_FOLDER}/${SHAPE}.txt

    echo ${TEMP_FOLDER}/${SHAPE}.txt
}

IMAGE_ROOT_FOLDER=$1
OUTPUT_FOLDER=${SCRIPT_PATH}/output/with-neighborhood-flow/plots
TEMP_FOLDER=${OUTPUT_FOLDER}/temp

mkdir -p ${OUTPUT_FOLDER}
mkdir -p ${TEMP_FOLDER}

SHAPES="triangle square flower bean"
LEN_PEN=0.0020661157
MULTIPLOT_ARGS=""
for SHAPE in ${SHAPES}
do
    VALUES_FILE=$(get_values_file ${IMAGE_ROOT_FOLDER} ${SHAPE} ${LEN_PEN})
    HACKED_VALUES_FILE=$(replace_zero_it_by_01 ${VALUES_FILE} ${TEMP_FOLDER})

    MULTIPLOT_ARGS="${MULTIPLOT_ARGS} ${HACKED_VALUES_FILE} ${SHAPE}"
done

OUTPUT_FILEPATH=${OUTPUT_FOLDER}/elastica.eps
create_multiplot "${OUTPUT_FILEPATH}" "Elastica" ${MULTIPLOT_ARGS}
convert_to_png ${OUTPUT_FILEPATH} ${OUTPUT_FOLDER}/elastica.png

rm ${OUTPUT_FILEPATH}
rm -rf ${TEMP_FOLDER}
