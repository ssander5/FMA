#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 2C_RunStats

#make output folder

if [ -d assembly_stats ]; then
    echo "directory exists"
else
    mkdir assembly_stats
fi

for z in ../B0_*/zone.[A-Z]; do
    if [ -d assembly_stats/${z#../B0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./assembly_stats/${z#../B0_*/}
    fi

    echo "Running Megahit"
    for f in ../B1_Quality_Control/final_QC_output/${z#../A0_*/}/*1.final.clean.fq; do


    # creating stats of all the assemblers
    #Stats with quast
      metaquast.py \
      --threads 14 \
      --gene-finding \
      -o ./assembly_stats/${z#../A0_*/}/$(basename ${f%.1*}) \
      -l $(basename ${f%.1*}) \
      ./megahit/${z#../A0_*/}/$(basename ${f%.1*})/final.contigs.fa
    done

      metaquast.py \
      --threads 14 \
      --gene-finding \
      -o ./assembly_stats/${z#../A0_*/}/$(basename ${f%.1*}) \
      -l $(basename ${f%.1*}) \
      ./spades/${z#../A0_*/}/$(basename ${f%.1*})/final.contigs.fa
    done

done
echo "DONE running stats!"
