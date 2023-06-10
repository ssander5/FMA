#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 2_RunMegaHit

#make output folder

if [ -d megahit ]; then
    echo "directory exists"
else
    mkdir megahit
fi

for z in ../B0_*/zone.[A-Z]; do
    if [ -d megahit/${z#../B0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./megahit/${z#../B0_*/}
    fi

    echo "Running Megahit"
    for f in ../B1_Quality_Control/final_QC_output/${z#../B0_*/}/*1.final.clean.fq; do
    megahit \
      -1 ${f} \
      -2 ${f%1*}2.final.clean.fq \
      -r ${f%1*}u.final.clean.fq \
      -t 16 \
      --presets meta-large \
      --mem-flag 2 \
      -o ./megahit/${z#../B0_*/}/$(basename ${f%.1*}) \
      -t 8
    done

    echo "Done running Megahit"

done
