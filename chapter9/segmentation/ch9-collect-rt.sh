#!/usr/bin/env bash

#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd ../../ && pwd )

BASE_DATA_FOLDER=${SCRIPT_PATH}/instance-generator/data

get_nit()
{
    tail $(realpath $1) -n2 | head -n1 | cut -d" " -f1
}

get_rtms()
{
    grep "Execution time:" $1 | cut  -d":" -f2 | cut -d"m" -f1 | cut -d"s" -f2
}

#MODELS="balanceseg flipseg graphseg"
MODELS="graphseg"
for model in $MODELS
do
    model_file_out=".${model}_rt.txt"
    rm -f ${model_file_out}

    DATA_FOLDER=${BASE_DATA_FOLDER}/${model}
    FILES=$(find $DATA_FOLDER -name "energy.txt" -printf "%p ")
    for file in $FILES
    do
        it=$(get_nit $file)
        rtms=$(get_rtms $file)

        if [ $( echo $it | cut -d"." -f1) -gt 0 ]
        then

            s=$(python3 -c "print('{0:.2f}'.format(${rtms}/1000.0))")
            spit=$(python3 -c "print('{0:.2f}'.format(${s}/${it}))")

            echo "$spit $s $it $file" >> ${model_file_out}
         fi
    done

    sort ${model_file_out} -n >> ${model_file_out}.sorted
done
