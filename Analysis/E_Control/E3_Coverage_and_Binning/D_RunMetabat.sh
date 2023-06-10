#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 6_MetaBat

#make output folder

if [ -d binning ]; then
    echo "directory exists"
else
    mkdir binning
fi

if [ -d binning/metabat ]; then
    echo "directory exists"
else
mkdir ./binning/metabat
fi

echo "Running Binning Metabat"
metabat2 \
  -i ../E2_Assembly/megahit/megahit_final_1000_filtered.fasta \
  -a ./coverage/all.depth.txt \
  -o ./binning/metabat/all_metabat \
  -t 16 \
  -m 1500 \
  -v \
   --unbinned

#In order to check which contigs were grouped together into separate bins by MetaBat example
#grep ">" E01452_L001_to_L004_metabat.1.fa | sed 's/>//g' > E01452_L001_to_L004_metabat.1.contigNames

echo "DONE running Binning Metabat!"
