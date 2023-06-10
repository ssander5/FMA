#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 8_Bin_Class

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/8_Bin_Classification/a_taxonomic_classification

#make output folder

if [ -d kraken_out ]; then
    echo "directory exists"
else
    mkdir kraken_out
fi

for z in ../../0_*/zone.[A-Z]; do
#for z in ../0_*/zone.B; do
    if [ -d kraken_out/${z#../../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./kraken_out/${z#../../0_*/}
        mkdir ./kraken_out/${z#../../0_*/}/maxbin
        mkdir ./kraken_out/${z#../../0_*/}/metabat
    fi

   # Run gene prediction using prodigal on

   echo "Running Bin Classification on Metabat"
   for f in ../../6_*/binning/${z#../../0_*/}/metabat/*.fa; do
      kraken2 \
      --db ../../Reference/krakenDB \
      --threads 16 \
      --use-names \
      ${f} \
      --report ./kraken_out/${z#../../0_*/}/metabat/$(basename $f).kreport > \
      ./kraken_out/${z#../../0_*/}/metabat/$(basename ${f}).kraken
   done

   echo "Running Bin Classification on Maxbin"
   for f in ../../6_*/binning/${z#../../0_*/}/maxbin/*.fasta; do
      kraken2 \
      --db ../../Reference/krakenDB \
      --threads 16 \
      --use-names \
      ${f} \
      --report ./kraken_out/${z#../../0_*/}/maxbin/$(basename ${f}).kreport > \
      ./kraken_out/${z#../../0_*/}/maxbin/$(basename ${f}).kraken
   done

   echo "DONE running bin classification!"

done
