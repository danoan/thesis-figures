#!/usr/bin/env bash

SCRIPT_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PROJECT_PATH=$( cd $SCRIPT_PATH && cd .. && pwd)

LATEX_THESIS_FIGURES_FOLDER=$(realpath $1)

FIGURES_PROJECTS="perimeter"

for fp in $FIGURES_PROJECTS
do
    mkdir -p ${LATEX_THESIS_FIGURES_FOLDER}/chapter4/$fp
    cp -r ${SCRIPT_PATH}/$fp/output/$fp ${LATEX_THESIS_FIGURES_FOLDER}/chapter4
done
