#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunCoAssembly

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/3_Coassembly

#make output folder

if [ -d spades ]; then
    echo "directory exists"
else
    mkdir spades
fi

echo "Running spades"

#   spades.py --pe1-1 lib1_forward_1.fastq --pe1-2 lib1_reverse_1.fastq \
#   --pe1-1 lib1_forward_2.fastq --pe1-2 lib1_reverse_2.fastq \
#   -o spades_output

cospd_1="spades.py --meta "

i=1
for f in ../1_Quality_Control/final_QC_output/*/*.1.unmerged.final.clean.fq; do
      cospd="$cospd --pe$i-1 ${f} --pe$i-2 ${f%1*}2.unmerged.final.clean.fq --pe$i-s ${f%1*}u.final.clean.fq "
      ((i = i + 1))
done

cospd_2=" -k auto -o ./spades -t 16"

echo $cospd_1 $cospd $cospd_2
