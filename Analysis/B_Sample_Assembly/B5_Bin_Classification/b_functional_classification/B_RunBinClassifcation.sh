#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 8_fun_class

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/8_Bin_Classification/b_functional_classification

#make output folder

if [ -d prokka_out ]; then
    echo "directory exists"
else
    mkdir prokka_out
fi

for z in ../../0_*/zone.[A-Z]; do
#for z in ../0_*/zone.B; do
    if [ -d prokka_out/${z#../../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./prokka_out/${z#../../0_*/}
        mkdir ./prokka_out/${z#../../0_*/}/maxbin
        mkdir ./prokka_out/${z#../../0_*/}/metabat
    fi

   # Run gene prediction using prokka on
   "Running prokka on maxbin"

   for f in ../../6_*/binning/${z#../../0_*/}/maxbin/*; do
      prokka ${f%.*} \
      --cpus 8 \
      --outdir ./prokka_out/${z#../../0_*/}/maxbin/${f%.*} \
      --prefix ${f%.*} \
      --metagenome \
      --kingdom 'Bacteria' \
      --locustag 'PROKKA' \
      --force
   done

   echo "Running prokka on metabat"

   for f in ../../6_*/binning/${z#../../0_*/}/metabat/*; do
      bin_name=$(basename ${f%.*})

      prokka ${f} \
      --cpus 8 \
      --outdir ./prokka_out/${z#../../0_*/}/metabat/$bin_name \
      --prefix $bin_name \
      --metagenome \
      --kingdom 'Bacteria' \
      --locustag 'PROKKA' \
      --force
   done
done

echo "DONE Running prokka"
