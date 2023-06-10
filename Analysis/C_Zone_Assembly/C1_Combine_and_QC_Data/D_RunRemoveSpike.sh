#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_D

#make output folder

if [ -d ./bbmap ]; then
    echo "directory exists"
else
    mkdir bbmap
fi


for z in sickle/zone.[A-Z]; do
     if [ -d bbmap/${z#sickle/} ]; then
        echo "directory exists"
    else
        mkdir ./bbmap/${z#sickle/}
    fi

    for g in $z/*1.trimclean.sickleclean.fq ; do
    o=${g#sickle/}
    echo "Removing phix adaptors and sequencing artifacts using BBMAP"


    #bbduk for paired

    bbduk.sh \
    threads=8 \
    in=${g%1*}1.trimclean.sickleclean.fq \
    in2=${g%1*}2.trimclean.sickleclean.fq \
    k=31 \
    out1=./bbmap/${o%1*}1.trimclean.sickleclean.spikeclean.fq \
    out2=./bbmap/${o%1*}2.trimclean.sickleclean.spikeclean.fq \
    minlength=60 \
    ref=~/.conda/envs/bioinf/opt/bbmap-39.01-0/resources/sequencing_artifacts.fa.gz,../Reference/phix_adapters.fa.gz \
    2>&1 > /dev/null | awk '{ print "PHIX ADAPTOR REMOVAL "$0}' | tee -a ./bbmap/${o%1.}stats.txt

    #bbduk for unpaired
    bbduk.sh \
    threads=8 \
    in=${g%1*}unpaired.trimclean.sickleclean.fq \
    k=31 \
    out1=./bbmap/${o%1*}unpaired.trimclean.sickleclean.spikeclean.fq \
    ref=~/.conda/envs/bioinf/opt/bbmap-39.01-0/resources/sequencing_artifacts.fa.gz,../Reference/phix_adapters.fa.gz \
    minlength=60 \
    2>&1 > /dev/null | awk '{ print "PHIX ADAPTOR REMOVAL "$0}' | tee -a ./bbmap/${o%1.}stats.txt

    done
done



