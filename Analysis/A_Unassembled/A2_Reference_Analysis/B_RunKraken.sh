#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N Run4_Ref

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/4_Reference_Analysis

#make output folder

if [ -d kraken ]; then
    echo "directory exists"
else
    mkdir kraken
fi

for z in ../0_*/zone.[A-Z]; do
    if [ -d kraken/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./kraken/${z#../0_*/}
    fi

echo "Running kraken2"


   for f in ../1_Quality_Control/final_QC_output/${z#../0_*/}/*1.final.clean.fq; do
      echo kraken2 \
      --db ../Reference/krakenDB \
      --threads 24 \
      --use-names \
      --paired \
      ${f} \
      ${f%1*}2.final.clean.fq \
      --report ./kraken/${z#../0_/}/$(basename ${f%1*})kreport #> \
      ./kraken/${z#../0_*/}/$(basename ${f%1*})kraken
   done
done

echo "DONE running kraken2!"
