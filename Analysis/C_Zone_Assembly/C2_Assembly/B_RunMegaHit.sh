#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunZone_C2

#make output folder

if [ -d megahit ]; then
    echo "directory exists"
else
    mkdir megahit
fi

for z in ../C0_*/zone.[A-Z]; do
#    if [ -d megahit/${z#../C0_*/} ]; then
#        echo "directory exists"
#    else
#        mkdir ./megahit/${z#../C0_*/}
#    fi

    echo "Running megahit"

    R1s=""
    R2s=""
    Rs=""

    i=1

    for f in ../../C_Zone_Assembly2/C1_*/final_QC_output/${z#../C0_*/}/*.1.final.clean.fq; do
        R1s="$R1s,${f}"
        R2s="$R2s,${f%1*}2.final.clean.fq"
        Rs="$Rs,${f%1*}u.final.clean.fq"
        ((i = i + 1))
    done

   megahit \
   -1 ${R1s:1} \
   -2 ${R2s:1} \
   -t 16 \
   --presets meta-large \
   --mem-flag 2 \
   -o ./megahit/${z#../C0_*/}/
done
