#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 2D_RunFilter

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/2_Assembly

echo "Running assembly length filter"

for z in ../0_*/zone.[A-Z]; do

   #running megahit
   for f in ../1_Quality_Control/final_QC_output/${z#../0_*/}/*1.final.clean.fq; do

      #spades
#      ./reformat.sh \
#      in=./spades/$(basename ${f%.1*})/contigs.fasta \
#      out=./spades/$(basename ${f%.1*})/contigs_1000_filtered.fasta \
#      minlength=1000

      #megahit
      reformat.sh \
      in=./megahit/${z#../0_*/}/$(basename ${f%.1*})/final.contigs.fa \
      out=./megahit/${z#../0_*/}/$(basename ${f%.1*})/megahit_final_1000_filtered.fasta \
      minlength=1000

      #idba_ud
#      reformat.sh \
#      in=./idba_ud/$(basename ${i%.1*})/contig.fa \
#      out=./idba_ud/$(basename ${i%.1*})/contig_1000_filtered.fa \
#      minlength=1000
   done
done

echo "DONE running assembly length filter!"
