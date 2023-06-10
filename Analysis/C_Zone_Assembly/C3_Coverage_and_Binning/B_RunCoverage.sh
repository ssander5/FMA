#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N C3_Coverage_and_Binning

#make output folder

if [ -d coverage ]; then
    echo "directory exists"
else
    mkdir coverage
fi

for z in ../C0_*/zone.[A-Z]; do
    zone=${z#../C0_*/}

    if [ -d coverage/${zone} ]; then
        echo "directory exists"
    else
        mkdir ./coverage/${zone}
        mkdir ./coverage/${zone}/bam
    fi

    echo "Running Create coverage file"
    for f in ../C1_*/final_QC_output/${zone}/*1.final.clean.fq; do

      base=${f%1*}

      echo "Running bbwrap in coverage file"

      bbwrap.sh \
      ref=../C2_Assembly/megahit/${zone}/megahit_final_1000_filtered.fasta \
      nodisk \
      in=${f},NULL \
      in2=${base}2.final.clean.fq,NULL \
      t=24 \
      kfilter=22 \
      subfilter=15 \
      maxindel=80 \
      out=./coverage/${zone}/bam/$(basename ${base}sam) \
      covstats=./coverage/${zone}/bam/$(basename ${base}coverage)

      #converting sam file to bam
      samtools view \
      -S \
      -b \
      -u \
      ./coverage/${zone}/bam/$(basename ${base}sam) \
      > ./coverage/${zone}/bam/$(basename ${base}bam)

      #sorting the bam file
      samtools sort \
      -m 16G \
      -@ 3 \
      ./coverage/${zone}/bam/$(basename ${base}bam) \
      -o ./coverage/${zone}/bam/$(basename ${base}sorted.bam)

      #indexing the sorted bam file
      samtools index \
      ./coverage/${zone}/bam/$(basename ${base}sorted.bam)


      jgi_summarize_bam_contig_depths \
      --outputDepth ./coverage/${zone}/$(basename ${base})depth.txt \
      --pairedContigs ./coverage/${zone}/$(basename ${base})paired.txt \
      --minContigLength 1000 \
      --minContigDepth 2 \
      ./coverage/${zone}/bam/$( basename ${base})sorted.bam

      tail -n+2 ./coverage/${zone}/$(basename ${base})depth.txt | cut -f 1,3 > ./coverage/${zone}/$(basename ${base})maxbin.cov
    done

echo "DONE running create coverage file!"

done
