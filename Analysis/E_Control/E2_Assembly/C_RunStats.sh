#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 3C_RunStats

#make output folder

if [ -d assembly_stats ]; then
    echo "directory exists"
else
    mkdir assembly_stats
fi

echo "Running Megahit"

    # creating stats of all the assemblers
    #Stats with quast
      metaquast.py \
      --threads 14 \
      --gene-finding \
      -o ./assembly_stats/ \
      -l All \
      ./megahit/final.contigs.fa

echo "DONE running stats!"
