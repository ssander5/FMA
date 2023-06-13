
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


for z in sickle/*1.1*; do
    if [ -d bbmap ]; then
        echo "directory exists"
    else
        mkdir ./bbmap
    fi

    #for g in $z/*1.trimclean.sickleclean.fq ; do
    #o=${g#sickle/}
    echo "Removing phix adaptors and sequencing artifacts using BBMAP"

    base=${z#sickle/}

    #bbduk for paired
    /home/sheri/local/miniconda3/envs/champion/bin/bbduk.sh \
    threads=8 \
    in=${z%1*}1.trimclean.sickleclean.fq \
    in2=${z%1*}2.trimclean.sickleclean.fq \
    k=31 \
    ref=../../Reference/phix_adapters.fa.gz \
    out1=./bbmap/${base%1*}1.trimclean.sickleclean.spikeclean.fq \
    out2=./bbmap/${base%1*}2.trimclean.sickleclean.spikeclean.fq \
    minlength=60 \
    2>&1 > /dev/null | awk '{print "PHIX ADAPTOR REMOVAL "$0}' | tee -a ./bbmap/${base%1}stats.txt

    #bbduk for unpaired
    /home/sheri/local/miniconda3/envs/champion/bin/bbduk.sh \
    threads=8 \
    in=${z%1*}unpaired.trimclean.sickleclean.fq \
    k=31 \
    ref=../../Reference/phix_adapters.fa.gz \
    out1=./bbmap/${base%1*}unpaired.trimclean.sickleclean.spikeclean.fq \
    minlength=60 \
    2>&1 > /dev/null | awk '{print "PHIX ADAPTOR REMOVAL "$0}' | tee -a ./bbmap/${base%1}stats.txt

done
