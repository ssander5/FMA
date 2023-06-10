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

#Get Database

echo "SKIPPING Removing rRNA contamination using SortMeRNA database in bbduk"

for g in ./bbmap/*1.trimclean.sickleclean.spikeclean.hostclean.fq; do

    cp ${g%1.trim*}1.trimclean.sickleclean.spikeclean.hostclean.fq ${g%1.trim*}1.final.clean.fq
    cp ${g%1.trim*}2.trimclean.sickleclean.spikeclean.hostclean.fq ${g%1.trim*}2.final.clean.fq
    cp ${g%1.trim*}unpaired.trimclean.sickleclean.spikeclean.hostclean.fq ${g%1.trim*}u.final.clean.fq

    echo "SKIPPING rRNA CONTAMINATION REMOVAL" >> ./bbmap/$(basename ${g%trim*}stats.txt)
done
