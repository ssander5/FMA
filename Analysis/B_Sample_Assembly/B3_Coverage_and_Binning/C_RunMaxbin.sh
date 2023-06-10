#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 6C_MaxBin

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
    if [ -d binning/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./binning/${z#../0_*/}
        mkdir ./binning/${z#../0_*/}/maxbin
    fi

    echo "Running Binning MaxBin"
    for f in ../1_Quality_Control/final_QC_output/${z#../0_*/}/*1.final.clean.fq; do
        ../Software/run_MaxBin.pl \
        -thread 16 \
        -contig ../2_Assembly/megahit/${z#../0_*/}/$(basename ${f%.1*})/megahit_final_1000_filtered.fasta \
        -abund ./coverage/${z#../0_*/}/$(basename ${f%.1*}).maxbin.cov \
        -out ./binning/${z#../0_*/}/maxbin/$(basename ${f%.1*})_maxbin
    done
done

echo "DONE running Binning MaxBin!"
