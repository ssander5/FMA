#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com  
#$ -m abe
#$ -q debug
#$ -N PullKraken2DB

module load boost/1.72/gcc/8.3.0
module load python/3.7.3
module load conda/4.13.0

wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20220926.tar.gz
tar xfv k2_standard_20220926.tar.gz
kraken2-build --standard --threads 4 -db krakenDB

#kraken2-build --download-taxonomy --db krakendb

#for i in `find krakendb \( -name '*.fna' -o -name '*.ffn'\)`
#do
#    dustmasker -in $i -infmt fasta -outfmt fasta | sed -e '/>/!s/a\|c\|g\|t/N/g' > tmpfile
#    kraken2-build --add-to-library tempfile --db krakendb
#done

kraken2-build --build --threads 10 --db krakenDB
kraken2-build --clean --db krakenDB
