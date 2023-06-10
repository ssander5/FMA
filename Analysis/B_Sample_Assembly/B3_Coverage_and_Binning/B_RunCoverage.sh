#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N 6_Coverage_and_Binning

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/6_Coverage_and_Binning

#make output folder

if [ -d coverage ]; then
    echo "directory exists"
else
    mkdir coverage
fi

for z in ../0_*/zone.[A-Z]; do
#for z in ../0_*/zone.B; do
    if [ -d coverage/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./coverage/${z#../0_*/}
        mkdir ./coverage/${z#../0_*/}/bam
    fi

    echo "Running Create coverage file"
    for f in ../1_Quality_Control/final_QC_output/${z#../0_*/}/*1.final.clean.fq; do

      echo "Running bbwrap in coverage file"

      bbwrap.sh \
      ref=../2_Assembly/megahit/${z#../0_*/}/$(basename ${f%.1*})/megahit_final_1000_filtered.fasta \
      nodisk \
      in=${f},${f%1*}u.final.clean.fq \
      in2=${f%1*}2.final.clean.fq,NULL \
      t=24 \
      kfilter=22 \
      subfilter=15 \
      maxindel=80 \
      out=./coverage/${z#../0_*/}/bam/$(basename ${f%1*}sam) \
      covstats=./coverage/${z#../0_*/}/bam/$(basename ${f%1*}coverage)

      #converting sam file to bam
      samtools view \
      -S \
      -b \
      -u \
      ./coverage/${z#../0_*/}/bam/$(basename ${f%1*}sam) \
      > ./coverage/${z#../0_*/}/bam/$(basename ${f%1*}bam)

      #sorting the bam file
      samtools sort \
      -m 16G \
      -@ 3 \
      ./coverage/${z#../0_*/}/bam/$(basename ${f%1*}bam) \
      -o ./coverage/${z#../0_*/}/bam/$(basename ${f%1*}sorted.bam)

      #indexing the sorted bam file
      samtools index \
      ./coverage/${z#../0_*/}/bam/$(basename ${f%1*}sorted.bam)


      jgi_summarize_bam_contig_depths \
      --outputDepth ./coverage/${z#../0_*/}/$(basename ${f%1*})depth.txt \
      --pairedContigs ./coverage/${z#../0_*/}/$(basename ${f%1*})paired.txt \
      --minContigLength 1000 \
      --minContigDepth 2 \
      ./coverage/${z#../0_*/}/bam/$( basename ${f%1*})sorted.bam

      tail -n+2 ./coverage/${z#../0_*/}/$(basename ${f%1*})depth.txt | cut -f 1,3 > ./coverage/${z#../0_*/}/$(basename ${f%1*})maxbin.cov
    done

echo "DONE running create coverage file!"

done
