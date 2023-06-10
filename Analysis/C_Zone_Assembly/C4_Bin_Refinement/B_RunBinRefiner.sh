#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N C4_Bin_Refining

#make output folder

if [ -d bin_refinement ]; then
    echo "directory exists"
else
    mkdir bin_refinement
fi

if [ -d checkM ]; then
    echo "directory exists"
else
    mkdir checkM
fi

export CHECKM_DATA_PATH=../../Reference/

for z in ../C0_*/zone.[A-F]; do

    zone=${z#../C0_*/}

    if [ -d ./bin_refinement/${zone} ]; then
        echo "directory exists"
    else
        mkdir ./bin_refinement/${zone}
        mkdir ./bin_refinement/${zone}/input
        mkdir ./bin_refinement/${zone}/input/maxbin
        mkdir ./bin_refinement/${zone}/input/metabat
        mkdir ./bin_refinement/${zone}/binrefiner_output
    fi

       cp ../C3_*/binning/${zone}/maxbin/*.fasta ./bin_refinement/${zone}/input/maxbin
       cp ../C3_*/binning/${zone}/metabat/*.fa ./bin_refinement/${zone}/input/metabat

       #Binning_refiner
       Binning_refiner \
       -i ./bin_refinement/${zone}/input \
       -p all.BR

        mv *BR* ./bin_refinement/${zone}/binrefiner_output


       export PATH=$PATH:../../Software/hmmer-3.3.2/bin/

       #running checkM for maxbin
    for f in bin_refinement/zone.A/binrefiner_output/*_refiner_outputs/*refined_bins/*fasta; do
       checkm lineage_wf \
       -t 8 \
       -x fasta $f \
       ./checkM/${zone}/

       checkm taxonomy_wf \
       domain \
       Bacteria \
       ./checkM/${zone} \
       -x fasta $f
     done
done

echo "DONE running Binrefiner!"
