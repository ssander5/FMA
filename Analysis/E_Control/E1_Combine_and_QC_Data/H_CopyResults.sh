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

for z in ./bbmap; do

    echo "Copying clean files to the folder"
    cp $z/*.unmerged.final.clean.fq ./final_QC_output/${z#./bbmap}/
    cp $z/*u.final.clean.fq ./final_QC_output/${z#./bbmap}/
    cp $z/*interleaved.final.clean.fa ./final_QC_output/${z#./bbmap}/
    cp $z/*1.final.clean.fq ./final_QC_output/${z#./bbmap}/
    cp $z/*2.final.clean.fq ./final_QC_output/${z#./bbmap}/

    for f in $z/*.1.unmerged.final.clean.fq; do
      cp ${f%1*}finalstats.txt ./final_QC_output/${z#./bbmap}/
    done

    echo "DONE copying clean files to the folder!"

#    done
done
