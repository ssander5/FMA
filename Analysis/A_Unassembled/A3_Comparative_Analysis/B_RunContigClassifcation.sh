#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunComparative_B

echo "Running contigs classification with kraken"

if [ -d kraken_out ]; then
    echo "directory exists"
else
    mkdir kraken_out
fi

for z in ../A0_*/zone.[A-Z]; do
#for z in ../0_*/zone.B; do
    if [ -d kraken_out/${z#../A0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./kraken_out/${z#../A0_*/}
    fi

   # Run gene prediction using prodigal on
   echo "Running classification on contigs with kraken!"
   for f in ../A1_*/final_QC_output/${z#../A0_*/}/*1.final.clean.fq*; do
      kraken2 \
      --db ../../Reference/krakenDB \
      --threads 16 \
      --use-names \
      ${f} \
      --report ./kraken_out/${z#../A0_*/}/$(basename $f).kreport \> \
      ./kraken_out/${z#../A0_*/}/$(basename ${f}).kraken
   done
done

echo "DONE running contigs classification with kraken!"

