#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_G

#make output folder

    echo "Creating stats"

for g in ./bbmap/*.1.unmerged.final.clean.fq; do

     grep 'RAWREADS' ${g%1*}stats.txt  | grep 'Input:' | awk '{print "RAWREADS COUNT""\t"$3/2}' | tee ${g%1*}finalstats.txt
     grep 'RAWREADS' ${g%1*}stats.txt  | grep 'Input:' | awk '{print "BASES RAWREADS "$5}' | tee -a ${g%1*}finalstats.txt
     grep 'HOST CONTAMINATION SEQUENCES' ${g%1*}stats.txt | grep "Reads Used:"  | awk '{printf $4" "}' | awk '{print "READS BIO "$1/2 + $2}' | tee -a ${g%1*}finalstats.txt
     egrep ^UNPAIRED ${g%1*}stats.txt  | grep 'Input:' | awk '{print $3}' | awk '{print "READS CLEAN_UNPAIRED "$1}' | tee -a ${g%1*}finalstats.txt
     egrep ^UNPAIRED ${g%1*}stats.txt  | grep 'Input:' | awk '{print "BASES CLEAN_UNPAIRED "$5}' | tee -a ${g%1*}finalstats.txt
     egrep ^PAIRED ${g%1*}stats.txt  | grep 'Input:' | awk '{print $3}' | awk '{print "READS CLEAN_PAIRED "$1}' | tee -a ${g%1*}finalstats.txt
     egrep ^PAIRED ${g%1*}stats.txt  | grep 'Input:' | awk '{print "BASES CLEAN_PAIRED "$5}' | tee -a ${g%1*}finalstats.txt

     echo "DONE creating stats!"

done
