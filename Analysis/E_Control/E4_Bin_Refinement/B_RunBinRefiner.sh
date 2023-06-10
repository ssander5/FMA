#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 7_Bin_Refining

#make output folder

if [ -d bin_refinement ]; then
    echo "directory exists"
else
    mkdir bin_refinement
    mkdir ./bin_refinement/input
    mkdir ./bin_refinement/input/maxbin
    mkdir ./bin_refinement/input/metabat
    mkdir ./bin_refinement/binrefiner_output
fi

if [ -d checkM ]; then
    echo "directory exists"
else
    mkdir checkM
    mkdir checkM/maxbin
    mkdir checkM/metabat
fi


cp ../E3_*/binning/maxbin/*.fasta ./bin_refinement/input/maxbin
cp ../E3_*/binning/metabat/*.fa ./bin_refinement/input/metabat

#Binning_refiner
Binning_refiner \
   -i ./bin_refinement/input \
   -p all.BR

mv *BR* ./bin_refinement/binrefiner_output


export PATH=$PATH:../../Software/hmmer-3.3.2/bin/

#running checkM for maxbin
checkm lineage_wf \
   -t 8 \
   -x fasta ../E3_*/binning/maxbin/ \
   ./checkM/maxbin/

checkm taxonomy_wf \
   domain \
   Bacteria \
   ../E3*/binning/maxbin/ \
   ./checkM/maxbin/ \
   -x fasta

#running checkM for metabat

checkm lineage_wf \
   -t 8 \
   -x fa ../E3_*/binning/metabat \
   ./checkM/metabat

checkm taxonomy_wf \
    domain \
    Bacteria \
    ../E3_*/binning/metabat \
    ./checkM/metabat/ \
    -x fa

echo "DONE running Binrefiner!"
