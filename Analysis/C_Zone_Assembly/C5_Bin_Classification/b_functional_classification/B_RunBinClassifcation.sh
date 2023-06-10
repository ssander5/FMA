#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N C5b_fun_class

#make output folder

if [ -d prokka_out ]; then
    echo "directory exists"
else
    mkdir prokka_out
fi

for z in ../../C0_*/zone.[A-Z]; do

    zone=${z#../../C0_*/}
    if [ -d prokka_out/${zone} ]; then
        echo "directory exists"
    else
        mkdir ./prokka_out/${zone}
    fi

   # Run gene prediction using prokka on
   echo "Running prokka on maxbin"

   for f in ../../C4_*/bin_refinement/${zone}/binrefiner_output/*_refiner_outputs/*_refined_bins/*fasta; do
      prokka ${f} \
      --cpus 8 \
      --outdir ./prokka_out/${zone}/$(basename ${f%.}) \
      --prefix $(basename ${f%.*}) \
      --metagenome \
      --kingdom 'Bacteria' \
      --locustag 'PROKKA' \
      --force
   done
done

echo "DONE Running prokka"
