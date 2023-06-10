#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_B

echo "Run FastQC"

#make output folder
if [ -d "fastqc" ]; then
    echo "./fastqc exists"
else
    mkdir fastqc
fi

for z in ../B0_*/zone*; do
    mkdir ./fastqc/${z#../B0_*/}
    for g in $z/*gz; do
        echo fastqc -o ./fastqc/${z#../B0_*/} $g
    done
done

echo "BBMAP stats"
if [ -d "bbmap" ]; then
    echo "./bbmap exists"
else
    mkdir bbmap
fi

for z in ../B0_*/zone*; do
    mkdir ./bbmap/${z#../B0_*/}
    for g in $z/*R1*; do
        o=${g#../B0_Read_Data/}
        reformat.sh threads=16 in=$g in2=${g%R1*}R2_001AB.fastq.gz 2>&1 >/dev/null \
        | awk '{print "RAWREADS "$0'} | tee -a ./bbmap/${z#../B0_*/}/${0%_R1*}.stats.txt
    done
done
