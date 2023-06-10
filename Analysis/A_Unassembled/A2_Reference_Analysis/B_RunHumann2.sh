#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_C

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/4_Reference_Analysis

#make output folder

if [ -d humann2 ]; then
    echo "directory exists"
else
    mkdir humann2
fi

for z in ../0_*/zone.[A-Z]; do
    if [ -d humann2/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./humann2/${z#../0_*/}
    fi
echo "Running humann2"

finallist=$(ls -d ../1_Quality_Control/final_QC_output/*.interleaved.final.clean.fa | awk '{print $NF}')



    for i in ../1_Quality_Control/final_QC_output/$z/*.interleaved.final.clean.fq; do
      humann2 \
      --input ${i} \
      --metaphlan metaphlan2 \
      --output ../Reference/reference_classification/humann2 \
      --nucleotide-database ../Reference/reference_database/humann2_databases/chocophlan \
      --protein-database ../Reference/reference_database/humann2_databases/uniref \
      --threads 16
    done

    genefamilieslist=$(ls -d ./humann2/$z/*_genefamilies.tsv | awk '{print $NF}')

    for g in ${genefamilieslist}
    do
      humann2_renorm_table \
      --input $g \
      --output ${g%_genefamilies*}_genefamilies_relab.tsv \
      --units relab

      humann2_join_tables \
      --input ./humann2 \
      --output ${g%_genefamilies*}_genefamilies.tsv \
      --file_name genefamilies_relab

      humann2_join_tables \
      --input ./humann2 \
      --output ${g%_genefamilies*}_pathcoverage.tsv \
      --file_name pathcoverage

      humann2_join_tables \
      --input ./humann2 \
      --output ${g%genefamilies*}_pathabundance.tsv \
      --file_name pathabundance_relab
   done

echo "DONE running humann2!"
