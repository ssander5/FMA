#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N C5a_Bin_Class

#make output folder

if [ -d kraken_out ]; then
    echo "directory exists"
else
    mkdir kraken_out
fi

# Run gene prediction using prodigal on

echo "Running Bin Classification on Refined Bins"

for f in ../../E4_Bin_Refinement/bin_refinement/binrefiner_output/all.BR_Binning_refiner_outputs/all.BR_refined_bins/*.fasta; do
   kraken2 \
      --db ../../../Reference/krakenDB \
      --threads 16 \
      --use-names \
      ${f} \
      --report ./kraken_out/all.kreport \
      --output ./kraken_out/all.kraken
   done

echo "DONE running bin classification!"

