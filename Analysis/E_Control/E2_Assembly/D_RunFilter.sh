#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 2D_RunFilter

echo "Running assembly length filter"

   #running megahit

      #spades
#      ./reformat.sh \
#      in=./spades/contigs.fasta \
#      out=./spades/contigs_1000_filtered.fasta \
#      minlength=1000

      #megahit
      reformat.sh \
      in=./megahit/final.contigs.fa \
      out=./megahit/megahit_final_1000_filtered.fasta \
      minlength=1000

      #idba_ud
#      reformat.sh \
#      in=./idba_ud/contig.fa \
#      out=./idba_ud/contig_1000_filtered.fa \
#      minlength=1000

echo "DONE running assembly length filter!"
