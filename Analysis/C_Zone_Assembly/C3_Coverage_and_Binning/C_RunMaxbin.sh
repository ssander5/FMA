#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 6C_MaxBin

#make output folder

if [ -d binning ]; then
    echo "directory exists"
else
    mkdir binning
fi

for z in ../C0_*/zone.[A-Z]; do

    if [ -d binning/${z#../C0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./binning/${z#../C0_*/}
        mkdir ./binning/${z#../C0_*/}/maxbin
    fi

    echo "Running Binning MaxBin"
    for f in ../C1_*/final_QC_output/${z#../C0_*/}/zone*1.final.clean.fq; do
        ../../Software/MaxBin-2.2.7/run_MaxBin.pl \
        -thread 16 \
        -contig ../C2_Assembly/megahit/${z#../C0_*/}/megahit_final_1000_filtered.fasta \
        -abund ./coverage/${z#../C0_*/}/bam/${z#../C0_*/}.coverage \
        -out ./binning/${z#../C0_*/}/maxbin/${z#../C0_*/}_maxbin
    done

done


echo "DONE running Binning MaxBin!"
