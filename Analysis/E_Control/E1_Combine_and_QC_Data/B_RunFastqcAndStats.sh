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

for z in ../E0_*/Control*; do
   zone=${z#../E0_*/}
    mkdir ./fastqc/${zone}
    for g in $z/*gz; do
        echo fastqc -o ./fastqc/${zone} $g
    done
done

echo "BBMAP stats"
if [ -d "bbmap" ]; then
    echo "./bbmap exists"
else
    mkdir bbmap
fi

for z in ../E0_*/Control*; do
    zone=${z#../E0_*/}
    mkdir ./bbmap/${zone}
    for g in $z/control*R1*; do
        o=${g#../E0_*/$zone/}
        reformat.sh threads=16 in=$g in2=${g%R1*}R2.fastq.gz out=stdout.fq 2>&1 > /dev/null | awk '{print RAW READS "$0}' | tee -a ./bbmap/${zone}/${o%_R1*}.stats.txt
    done
done
