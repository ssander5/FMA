#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunAll_D2


echo "Running megahit"

    R1s=""
    R2s=""
    Rs=""


    i=1

    for f in ../E1_Quality_Control/final_QC_output/*.1.final.clean.fq; do
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
   -o ./megahit/
