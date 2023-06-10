#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 2D_RunFilter

echo "Running assembly length filter"

for z in ../C0_*/zone.[A-Z]; do

   #running megahit

      #spades
#      ./reformat.sh \
#      in=./spades/${z#../0_*/}/contigs.fasta \
#      out=./spades/${z#../0_*/}/contigs_1000_filtered.fasta \
#      minlength=1000

      #megahit
      reformat.sh \
      in=./megahit/${z#../C0_*/}/final.contigs.fa \
      out=./megahit/${z#../C0_*/}/megahit_final_1000_filtered.fasta \
      minlength=1000

      #idba_ud
#      reformat.sh \
#      in=./idba_ud/${z#../0_*/}/contig.fa \
#      out=./idba_ud/${z#../0_*/}/contig_1000_filtered.fa \
#      minlength=1000
done

echo "DONE running assembly length filter!"

