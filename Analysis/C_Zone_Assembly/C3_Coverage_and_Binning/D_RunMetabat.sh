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

echo "Running Binning Metabat"

for z in ../C0_*/zone.[A-Z]; do
    if [ -d binning/${z#../C0_*/}/metabat ]; then
        echo "directory exists"
    else
        mkdir ./binning/${z#../C0_*/}/metabat
    fi

    for f in ../C1_Combine_and_QC_Data/final_QC_output/${z#../C0_*/}/zone*1.final.clean.fastq; do
      metabat2 \
      -i ../C2_Assembly/megahit/${z#../C0_*/}/megahit_final_1000_filtered.fasta \
      -a ./coverage/${z#../C0_*/}/${z#../C0_*/}.depth.txt \
      -o ./binning/${z#../C0_*/}/metabat/$(basename ${f%.1*})_metabat \
      -t 16 \
      -m 1500 \
      -v \
      --unbinned

    done
done

   #In order to check which contigs were grouped together into separate bins by MetaBat example
   #grep ">" E01452_L001_to_L004_metabat.1.fa | sed 's/>//g' > E01452_L001_to_L004_metabat.1.contigNames

echo "DONE running Binning Metabat!"
