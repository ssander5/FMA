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

echo "SKIPPING Removing host contamination and generating stats using BBMAP"

for z in ./bbmap/zone.[A-F]; do
    if [ -d bbmap/${z#./bbmap/} ]; then
        echo "directory exists"
    else
        mkdir ./bbmap/${z#./bbmap/}
    fi

    for g in $z/*trimclean.sickleclean.spikeclean.fq; do
    o=${g#./bbmap/}
    base=${o%_R1*}

    cp $g ${g%trim*}trimclean.sickleclean.spikeclean.hostclean.fq

done
