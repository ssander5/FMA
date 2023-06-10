#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N C5a_Bin_Class

#make output folder

if [ -d bracken_out ]; then
    echo "directory exists"
else
    mkdir bracken_out
fi

for z in ../../C0_*/zone.[A-Z]; do
    zone=${z#../../C0_*/}

    if [ -d bracken_out/${zone} ]; then
        echo "directory exists"
    else
        mkdir ./bracken_out/${zone}
    fi

   # Run gene prediction using prodigal on

   echo "Running Bin Classification on Metabat"
   for f in kraken_out/${zone}/*kreport; do
      ../../../Software/Bracken/bracken \
      -d ../../../Reference/krakenDB \
      -i $f \
      -l S \
      -o bracken_out/${zone}/$(basename ${f}).bracken

   done
   echo "DONE running bin classification!"

done
