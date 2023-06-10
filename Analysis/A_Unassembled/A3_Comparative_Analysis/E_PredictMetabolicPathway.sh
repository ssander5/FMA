#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunComparative_E

conda activate bioinf

cd /afs/crc/group/huge/Fractionated_Microbiome_Analysis/Analysis/5*

if [ -d minpath_out ]; then
    echo "directory exists"
else
    mkdir minpath_out
fi

for z in ../0_*/zone.[A-Z]; do
#for z in ../0_*/zone.B; do
    if [ -d ./minpath_out/${z#../0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./minpath_out/${z#../0_*/}
    fi

echo "Running predict metabolic pathway"

#awk -F "\t" '{print $1 "\t" $3}' 121832.assembled.EC > for_MinPath.ec
#sed -i "s/EC://g" for_MinPath.ec
#MinPath1.2.py -any for_MinPath.ec -map /home/rprops/MinPath/data/ec2path -report report.metacyc.minpath

    for f in ../2_*/${z#../0_*}/*; do
      ../Software/MinPath/MinPath.py \
         -any  ./prokka_out/${z#../0_*/}/$(basename ${f#R*}).ec \
         -map ec2path \
         -report ./minpath_out/${z#../0_*/}/${z#../0_*/}.report.metacyc.minpath
    done



  for f in ../2_*/${z#../0_.*/}/*; do
      echo diamond blastp \
      --threads 8 \
      --query ./prokka_out/${z#../0_*/}/$(basename ${f%AB.fastq.gz})/$(basename ${f%AB.fastq.gz}).faa \
      --db ../Reference/reference_database/swissprot \
      --daa ./diamond_out/${z#../0_*/}/$(basename ${f%AB.fastq.gz}).daa

done



echo "DONE running predict metabolic pathway!"

done
