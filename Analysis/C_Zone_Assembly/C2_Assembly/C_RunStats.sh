#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 3C_RunStats

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/C_Zone_Assembly/C2_Assembly

#make output folder

if [ -d assembly_stats ]; then
    echo "directory exists"
else
    mkdir assembly_stats
fi

for z in ./megahit/zone.[A-Z]; do
    if [ -d assembly_stats/$( basename ${z#../0_*/}) ]; then
        echo "directory exists"
    else
        mkdir ./assembly_stats/$(basename ${z#../0_*/})
    fi

    echo "Running Megahit"

    # creating stats of all the assemblers
    #Stats with quast
      metaquast.py \
      --threads 14 \
      --gene-finding \
      -o ./assembly_stats/$(basename ${z#../0_*/})/ \
      -l $(basename ${z#../0_*/}) \
      ./megahit/$(basename ${z#../0_*/})/final.contigs.fa
done
echo "DONE running stats!"
