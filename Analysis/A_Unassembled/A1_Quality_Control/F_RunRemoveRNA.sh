#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_F

#make output folder

if [ -d bbmap ]; then
    echo "directory exists"
else
    mkdir bbmap
fi

for z in ./bbmap/zone.[A-F]; do
    if [ -d bbmap/${z#./bbmap/} ]; then
        echo "directory exists"
    else
        mkdir ./bbmap/${z#./bbmap/}
    fi

#Get Database
if [ -f ../Reference/smr_v4.3_default_db.fasta ]; then
    echo "rRNA database exists"
else
    wget https://github.com/sortmerna/sortmerna/releases/download/v4.3.3/database.tar.gz
    mv database.tar.gz ../Reference/
    tar -xvf ../Reference/database.tar.gz
fi

echo "Removing rRNA contamination using SortMeRNA database in bbduk"

for f in ./bbmap/${z#./bbmap/}*1.trimclean.sickleclean.spikeclean.hostclean.fq; do
    #bbduk is easier to install, faster to run, and has similar output to sortmerna

    base=${f%1.trim*}

    #bbduk for paired
    bbduk.sh \
    in=${base}1.trimclean.sickleclean.spikeclean.hostclean.fq \
    in2=${base}2.trimclean.sickleclean.spikeclean.hostclean.fq \
    ref=../Reference/smr_v4.3_default_db.fasta \
    out=${base}1.final.clean.fq \
    out2=${base}2.final.clean.fq \
    outm=${base}reads_that_match_rRNA.fq 2>&1 > /dev/null | \
    awk '{print "HOST CONTAMINATION SEQUENCES PAIRED "$0}' | \
    tee -a ./bbmap/$(basename ${base}stats.txt)

    #bbduk for unpaired
    bbduk.sh \
    threads=8 \
    ref=../Reference/smr_v4.3_default_db.fasta \
    in=${base}unpaired.trimclean.sickleclean.spikeclean.hostclean.fq \
    k=31 \
    out1=${base}}u.final.clean.fq \
    minlength=60 \
    outm=${base}reads_that_match_rRNA_unpaired.fq 2>&1 > /dev/null |
    awk '{print "HOST CONTAMINATION SEQUENCES UNPAIRED "$0}' | \
    tee -a ./bbmap/$(basename ${base}stats.txt)

done

echo "DONE Removing rRNA contamination using SortMeRNA database in bbduk!"

