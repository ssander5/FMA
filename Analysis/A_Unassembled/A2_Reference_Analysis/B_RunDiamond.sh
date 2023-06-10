#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_C

#make output folder

if [ -d diamond_output ]; then
    echo "directory exists"
else
    mkdir diamond_output
fi

for z in ../A0_*/zone.[A-Z]; do
    if [ -d diamond_output/${z#../A0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./diamond_output/${z#../A0_*/}
    fi

    echo "Running diamond"


    for f in ../A1_Quality_Control/final_QC_output/${z#../A0_*/}/*12.interleaved.final.clean.fq; do
      echo diamond blastx \
      --threads 24 \
      --query ${f} \
      --db ../../Reference/reference_database/nr \
      --daa ./diamond_out/$(basename ${f%12*})


#      daa2rma \
#      --in ./diamond_output/${z#../A0_*/}/$(basename ${f%12*}).daa \
#      --acc2taxa ../Reference/reference_database/megan_ref/nucl_acc2tax-Nov2018.abin \
#      --acc2interpro2go ../Reference/reference_database/megan_ref/acc2interpro-June2018X.abin \
#      --acc2seed  ../Reference/reference_database/megan_ref/acc2seed-May2015XX.abin \
#      --acc2eggnog ../Reference/reference_database/megan_ref/acc2eggnog-Oct2016X.abin \
#      -fwa true \
#      --out ./diamond_output/${z#../A0_*/}/$(basename ${f%.12*}).rma
    done
done

echo "DONE running diamond!"
