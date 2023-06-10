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
    mkdir binning/maxbin
fi

echo "Running Binning MaxBin"
../../Software/MaxBin-2.2.7/run_MaxBin.pl \
    -thread 16 \
    -contig ../E2_Assembly/megahit/megahit_final_1000_filtered.fasta \
    -abund ./coverage/all.maxbin.cov \
    -out ./binning/maxbin/all_maxbin

echo "DONE running Binning MaxBin!"
