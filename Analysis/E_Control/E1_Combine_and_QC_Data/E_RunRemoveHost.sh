#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_E

#make output folder

if [ -d bbmap ]; then
    echo "directory exists"
else
    mkdir bbmap
fi


for z in ./bbmap/*1.1*; do

    if [ -d bbmap/ ]; then
        echo "directory exists"
    else
        mkdir ./bbmap/
    fi

    echo "Removing host contamination and generating stats using BBMAP"

    touch ./${z%1.1*}stats.txt

    bbwrap.sh \
    threads=16 \
    minid=0.95 \
    maxindel=3 \
    bwr=0.16 \
    bw=12 \
    quickmatch \
    fast \
    minhits=2 \
    qtrim=rl \
    trimq=20 \
    minlength=60 \
    in=$z,${z%1*}unpaired.trimclean.sickleclean.spikeclean.fq \
    in2=${z%1*}2.trimclean.sickleclean.spikeclean.fq,NULL \
    outu1=${z%1*}1.trimclean.sickleclean.spikeclean.hostclean.fq \
    outu2=${z%1*}2.trimclean.sickleclean.spikeclean.hostclean.fq \
    outu=${z%1*}unpaired.trimclean.sickleclean.spikeclean.hostclean.fq \
    path=../../Reference/human 2>&1 > /dev/null |  \
    awk '{print "HOST CONTAMINATION SEQUENCES "$0}' | \
    tee -a ./${z%1*}stats.txt

done
