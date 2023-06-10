#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 6_MetaBat

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/6_Coverage_and_Binning

#make output folder

if [ -d binning ]; then
    echo "directory exists"
else
    mkdir binning
fi

for z in ../0_*/zone.[A-Z]; do
#for z in ../0_*/zone.B; do
    if [ -d binning/${z#../0_*/}/metabat ]; then
        echo "directory exists"
    else
        mkdir ./binning/${z#../0_*/}/metabat
    fi

    echo "Running Binning Metabat"
    for f in ../1_Quality_Control/final_QC_output/${z#../0_*/}/*1.final.clean.fq; do
      metabat \
      -i ../2_Assembly/megahit/${z#../0_*/}/$(basename ${f%.1*})/megahit_final_1000_filtered.fasta \
      -a ./coverage/${z#../0_*/}/$(basename ${f%.1*}).depth.txt \
      -o ./binning/${z#../0_*/}/metabat/$(basename ${f%.1*})_metabat \
      -t 16 \
      -m 1500 \
      -v \
      --unbinned

    done
done

   #In order to check which contigs were grouped together into separate bins by MetaBat example
   #grep ">" E01452_L001_to_L004_metabat.1.fa | sed 's/>//g' > E01452_L001_to_L004_metabat.1.contigNames

echo "DONE running Binning Metabat!"
