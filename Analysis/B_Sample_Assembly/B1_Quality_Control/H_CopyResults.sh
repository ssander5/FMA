#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_H

#make output folder

if [ -d final_QC_output ]; then
    echo "directory exists"
else
    mkdir final_QC_output
fi

for z in ./bbmap/zone.[A-Z]; do
    echo $z
    if [ -d final_QC_output/${z#./bbmap/} ]; then
        echo "directory exists"
    else
        mkdir ./final_QC_output/${z#./bbmap/}
    fi

    echo "Copying clean files to the folder"
    cd ./final_QC_output/${z#./bbmap}/
    ln -s ../.$z/*.unmerged.final.clean.fq .
    ln -s ../.$z/*u.final.clean.fq .
    ln -s ../.$z/*interleaved.final.clean.fa .
    ln -s ../.$z/*1.final.clean.fq .
    ln -s ../.$z/*2.final.clean.fq .

#    finallist=$(ls -d ./bbmap/*.1.unmerged.final.clean.fq | awk '{print $NF}')

    for f in ../.$z/*.1.unmerged.final.clean.fq; do
      ln -s ${f%1*}finalstats.txt .
    done

    cd ../..
    echo "DONE copying clean files to the folder!"

#    done
done
