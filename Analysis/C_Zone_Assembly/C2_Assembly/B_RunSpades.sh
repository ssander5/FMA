#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunCoAssembly

#make output folder

if [ -d spades ]; then
    echo "directory exists"
else
    mkdir spades
fi

for z in ../C0_*/zone.[A-Z]; do
    if [ -d spades/${z#../C0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./spades/${z#../C0_*/}
    fi
done

echo "Running spades"

#   spades.py --pe1-1 lib1_forward_1.fastq --pe1-2 lib1_reverse_1.fastq \
#   --pe1-1 lib1_forward_2.fastq --pe1-2 lib1_reverse_2.fastq \
#   -o spades_output

cospd_1="spades.py --meta "
cospd_2=" -k auto -o ./spades/${z#../C0_*/} -t 16"

for z in ../C0_*/zone.[A-Z]; do

  i=1

  for f in ../C1_*/final_QC_output/${z#../C0_*/}/${z#../C0_*/}.1.final.clean.fastq; do
#      cospd="$cospd --pe$i-1 ${f} --pe$i-2 ${f%1*}2.unmerged.final.clean.fastq --pe$i-s ${f%1*}u.final.clean.fastq "
       cospd="$cospd --pe$i-1 ${f} --pe$i-2 ${f%1*}2.final.clean.fastq "
      ((i = i + 1))
  done


  $cospd_1 $cospd $cospd_2
  cospd=""
done
