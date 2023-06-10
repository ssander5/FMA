#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 7_Bin_Refining

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/7_Bin_Refinement

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

for z in ../0_*/zone.[A-Z]; do
#for z in ../0_*/zone.A; do
    if [ -d ./bin_refinement/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./bin_refinement/${z#../0_*/}
        mkdir ./bin_refinement/${z#../0_*/}/input
        mkdir ./bin_refinement/${z#../0_*/}/input/maxbin
        mkdir ./bin_refinement/${z#../0_*/}/input/metabat
        mkdir ./bin_refinement/${z#../0_*/}/binrefiner_output
    fi

    if [ -d ./checkM/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./checkM/${z#../0_*/}/maxbin
        mkdir ./checkM/${z#../0_*/}/metabat
    fi

    for f in ../1_Quality_Control/final_QC_output/${z#../0_*/}/*1.final.clean.fq; do
#    for f in ../1_Quality_Control/final_QC_output/${z#../0_*/}/1A1*1.1.final.clean.fq; do
       cp ../6_*/binning/${z#../0_*/}/maxbin/$(basename ${f%.1*})*.fasta ./bin_refinement/${z#../0_*/}/input/maxbin
       cp ../6_*/binning/${z#../0_*/}/metabat/$(basename ${f%.1*})*.fa ./bin_refinement/${z#../0_*/}/input/metabat

       #Binning_refiner
       Binning_refiner \
       -i ./bin_refinement/${z#../0_*/}/input/ \
       -p $(basename ${f%.1*}).BR

       mv *BR* ./bin_refinement/${z#../0_*/}/binrefiner_output/

    done

       #running checkM for maxbin
       checkm lineage_wf \
       -t 8 \
       -x fasta ../6*/binning/${z#../0_*/}/maxbin/ \
       ./checkM/${z#../0_*/}/maxbin/

       checkm taxonomy_wf \
       domain \
       Bacteria \
       ../6_*/binning/${z#../0_*/}/maxbin/ \
       ./checkM/${z#../0_*/}/maxbin/ \
       -x fasta

       mkdir ./checkM/${z#../0_*/}/maxbin/plots/

#  Not available past checkM 1.1.x
#       checkm bin_qa_plot \
#       -x fasta \
#       ./checkM/${z#../0_*/} \
#       ../6_*/binning/${z#../0_*/}/maxbin/ \
#       ./checkM/${z#../0_*/}/maxbin/plots

       #running checkM for metabat

       checkm lineage_wf \
       -t 8 \
       -x fa ../6_*/binning/${z#../0_*/}/metabat \
       ./checkM/${z#../0_*/}/metabat

       mkdir ./checkM/${z#../0_*/}/metabat/plots/

       checkm taxonomy_wf \
       domain \
       Bacteria \
       ../6_*/binning/${z#../0_*/}/metabat \
       ./checkM/${z#../0_*/}/metabat/ \
       -x fasta

#  Not available past checkM 1.1.x
#       checkm bin_qa_plot \
#       -x fasta \
#       ./checkM/${z#../0_*/}/ \
#       ../6_*/binning/${z#../0_*/}/metabat \
#       ./checkM/${z#../0_*/}/metabat/plots
done

echo "DONE running Binrefiner!"
