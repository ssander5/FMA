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

for z in ../../C0_*/zone.[A-Z]; do
    zone=${z#../../C0_*/}

    if [ -d kraken_out/${zone} ]; then
        echo "directory exists"
    else
        mkdir ./kraken_out/${zone}
    fi

   # Run gene prediction using prodigal on

   echo "Running Bin Classification on All"
   for f in ../../C4_*/bin_refinement/${zone}/binrefiner_output/*refiner_outputs/*refined_bins/*.fasta; do
     kraken2 \
      --db ../../../Reference/krakenDB \
      --threads 16 \
      --use-names \
      ${f} \
      --report ./kraken_out/${zone}/$(basename $f).kreport > \
      ./kraken_out/${zone}/$(basename ${f}).kraken
   done


done
   echo "DONE running bin classification!"
