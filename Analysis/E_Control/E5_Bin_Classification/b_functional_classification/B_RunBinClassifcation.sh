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

# Run gene prediction using prokka on
"Running prokka on Refined Bins"


for f in ../../E4_Bin_Refinement/bin_refinement/binrefiner_output/all.BR_Binning_refiner_outputs/all.BR_refined_bins/*fasta; do
name=$(basename $f)

prokka ${f} \
      --cpus 8 \
      --outdir ./prokka_out/${name%.*} \
      --prefix ${name%.*} \
      --metagenome \
      --kingdom 'Bacteria' \
      --locustag 'PROKKA' \
      --force
done

echo "DONE Running prokka"
