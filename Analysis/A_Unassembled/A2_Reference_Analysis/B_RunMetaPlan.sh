#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_C

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/4_Reference_Analysis

#make output folder

if [ -d metaphlan2 ]; then
    echo "directory exists"
else
    mkdir metaphlan2
fi


for z in ../0_*/zone.[A-Z]; do
    if [ -d metaphlan2/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./metaphlan2/${z#../0_*/}
        mkdir metaphlan2/${z#../0_*/}/profiled_samples
        mkdir metaphlan2/${z#../0_*/}/output_images
    fi

    echo "Running metaphlan"

    z=${z#../0_*/}

    for f in ../1_Quality_Control/final_QC_output/$z/*1.unmerged.final.clean.fq; do
      metaphlan2.py \
      --input_type multifastq \
      ${f},${f%1*}2.unmerged.final.clean.fq,${f%1*}u.final.clean.fq \
      --bowtie2db ../Reference/reference_database/metaphlan2/bowtie2db/mpa \
      --bt2_ps very-sensitive \
      --nproc 8 \
      --mpa_pkl ../Reference/reference_database/metaphlan2/bowtie2db/mpa \
      --bowtie2out ./metaphlan2/$z/${f%1*}bt2out > \
      ./metaphlan2/$z/profiled_samples/${f%1*}txt
    done

    echo "Creating sample profiles using metaphlan"

    profilelist=$(ls -d ./metaphlan2/$z/profiled_samples/* | awk '{print $NF}')

   #Merge the output
   merge_metaphlan_tables.py \
   ./metaphlan2/$z/profiled_samples/*.txt > \
   ./metaphlan2/$z/merged_abundance_table.txt

   # create a species abundance table
   grep -E "(s__)|(^ID)" ./metaphlan2/$z/merged_abundance_table.txt \
   | grep -v "t__" | sed 's/^.*s__//g' > \
   ./metaphlan2/$z/merged_abundance_table_species.txt

   echo "Creating heatmap"

   profilelist=$(ls -d ./metaphlan2/$z/profiled_samples/* | awk '{print $NF}')

   hclust2.py \
   -i ./metaphlan2/$z/merged_abundance_table_species.txt \
   -o ./metaphlan2/$z/output_images/abundance_heatmap_species.png \
   --ftop 25 \
   --f_dist_f braycurtis \
   --s_dist_f braycurtis \
   --cell_aspect_ratio 0.5 \
   -l \
   --flabel_size 6 \
   --slabel_size 6 \
   --max_flabel_len 100 \
   --max_slabel_len 100 \
   --minv 0.1 \
   --dpi 300

   # creating files for graphlan
   echo "Running graphlan"

   mkdir -p ./metaphlan2/$z/graphlan_output
   mkdir -p ./metaphlan2/$z/graphlan_output/output_images
   export2graphlan.py \
   --skip_rows 1,2 \
   -i ./metaphlan2/$z/merged_abundance_table.txt \
   --tree ./metaphlan2/$z/graphlan_output/merged_abundance.tree.txt \
   --annotation ./metaphlan2/$z/graphlan_output/merged_abundance.annot.txt \
   --most_abundant 100 \
   --abundance_threshold 1 \
   --least_biomarkers 10 \
   --annotations 5,6 \
   --external_annotations 7 \
   --min_clade_size 1

   ./graphlan_annotate.py \
   --annot ./metaphlan2/$z/graphlan_output/merged_abundance.annot.txt \
   ./metaphlan2/$z/graphlan_output/merged_abundance.tree.txt \
   ./metaphlan2/$z/graphlan_output/merged_abundance.xml

   graphlan.py \
   --dpi 300 \
   --size 15 \
   --format pdf \
   ./metaphlan2/$z/graphlan_output/merged_abundance.xml \
   ./metaphlan2/$z/graphlan_output/output_images/merged_abundance.pdf
   #  --external_legends

done

echo "DONE running metaphlan!"

