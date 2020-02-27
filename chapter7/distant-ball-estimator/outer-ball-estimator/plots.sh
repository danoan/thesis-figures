#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../.. && pwd )
PLOT_SCRIPT=${PROJECT_PATH}/plot-scripts

source ${PLOT_SCRIPT}/graph-plot.sh

gp_plot_config()
{
    lenpen=0
	printf "set title '$1';
	set key right top;
	set yrange[0:];
	set xlabel 'Angle';
	set ylabel '{/Symbol k} squared';"
}

gp_add_plot()
{
    printf "'$1' u 1:2 w l ls $3 title 'Real',"
    printf "'$1' u 1:3 w l ls $(($3+1)) title 'Estimated',"
}

gp_last_plot()
{
	printf "'$1' u 1:2 w l ls $3 title 'Real',"
	printf "'$1' u 1:3 w l ls $(($3+1)) title 'Estimated';"
}


OUTPUT_FOLDER="$1";
DATA_FILE="$2";
R=$3;
H=$4;

NLINES=$( wc $DATA_FILE -l | cut -d" " -f1 )
STEP=$( python -c "w=int( ${NLINES}/50 ); w = w if w>1 else 1; print(w)" )

mkdir -p ${OUTPUT_FOLDER}
create_multiplot ${OUTPUT_FOLDER}/R${R}-H${H}.eps 'RealxEstimated' ${DATA_FILE} "r=${R};h=${H}"
