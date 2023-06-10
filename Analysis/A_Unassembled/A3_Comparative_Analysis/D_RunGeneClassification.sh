#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunCompartive_D

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/5*

echo "Running contigs classification with diamond"

if [ -d diamond_out ]; then
    echo "directory exists"
else
    mkdir diamond_out
fi

for z in ../0_*/zone.[A-Z]; do
#for z in ../0_*/zone.B; do
    if [ -d diamond_out/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./diamond_out/${z#../0_*/}
    fi

  for f in ../2_*/${z#../0_.*/}/*; do
      echo ../Software/diamond blastp \
      --threads 8 \
      --query ./prokka_out/${z#../0_*/}/$(basename ${f%_R*})/$(basename ${f%_R*}).faa \
      --db ../Reference/reference_database/diamond/swissprot \
      --daa ./diamond_out/${z#../0_*/}/$(basename ${f%_R*}).daa

      ../Software/megan/tools/daa2rma \
      --in ./diamond_out/${z#../0_*/}/$(basename ${f%_R*}.daa) \
      --acc2taxa ../Reference/reference_database/megan/prot_acc2tax-Jul2019X1.abin \
      --acc2interpro2go ../Reference/reference_database/megan/acc2interpro-Jul2019X.abin \
      --acc2seed  ../Reference/reference_database/megan/acc2seed-May2015XX.abin \
      --acc2eggnog ../Reference/reference_database/megan/acc2eggnog-Jul2019X.abin \
      -fwa true \
      --out ./diamond_out/${z#../0_*/}/$(basename ${f%_R*}).rma
   done

done

echo "DONE running contigs classification with diamond!"
