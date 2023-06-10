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

for z in ../C0_*/zone*; do
    mkdir ./fastqc/${z#../C0_*/}
    for g in $z/*gz; do
        fastqc -o ./fastqc/${z#../C0_*/} $g
    done
done

echo "BBMAP stats"
if [ -d "bbmap" ]; then
    echo "./bbmap exists"
else
    mkdir bbmap
fi

for z in ../C0_*/zone*; do
    mkdir ./bbmap/${z#../C0_*/}
    for g in $z/*R1*; do
        o=${g#../C0_Read_Data/}
        reformat.sh threads=16 in=$g in2=${g%R1*}R2* out=stdout.fq 2>&1 > /dev/nul | awk '{print "RAW SEQUENCES "$0}' | tee -a  ./bbmap/${o%_R1*}.stats.txt
    done
done
