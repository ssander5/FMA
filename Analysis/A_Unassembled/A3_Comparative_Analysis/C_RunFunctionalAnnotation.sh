#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunComparative_C

echo "Running gene functional annotation using prokka"

if [ -d prokka_out ]; then
    echo "directory exists"
else
    mkdir prokka_out
fi

for z in ../A0_*/zone.[A-Z]; do
    if [ -d prokka_out/${z#../A0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./prokka_out/${z#../A0_*/}
    fi

   # Run gene prediction using prokka on
   echo "Running prokka"

   for f in ../A1_*/final_QC_output/${z#../A0_*/}/*.fq; do
#   for f in ../A2_*/spades/${z#../A0_*/}/*; do
     echo prokka ${f} \
      --cpus 8 \
      --outdir ./prokka_out/${z#../A0_*/}/${f#*/zone.*/} \
      --prefix ${f#*/zone.*/} \
      --metagenome \
      --kingdom 'Bacteria' \
      --locustag 'PROKKA' \
      --norrna \
      --notrna \
      --addgenes \
      --centre X \
      --force

      #grep "eC_number=" ./prokka_out/${z#../A0_*/}/${f#*/zone.*/}/${f#*/zone.*/}.gff | cut -f9 | cut -f1,3 -d ';' | sed "s/ID=//g" | sed "s/;eC_number=/\t/g" > prokka_out/${z#../A0_*/}/${f#*/zone.*/}.ec
   done
done

echo "DONE running gene functional annotation using prokka!"
