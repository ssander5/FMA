#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunReadData

#Make Zones
for l in A B C D E F ; do
    mkdir zone.$l
done

for i in {01..03}; do
    for f in ../../Input_Files/"R1F"$i/*; do
	cp $f ./zone.A/
    done
done

for i in {04..07}; do
    for f in ../../Input_Files/"R1F"$i/*; do
	cp $f ./zone.B/
    done
done

for i in {07..10}; do
    for f in ../../Input_Files/"R1F"$i/*; do
	cp $f ./zone.C/
    done
done

for i in {10..13}; do
    for f in ../../Input_Files/"R1F"$i/*; do
        cp $f ./zone.D/
    done
done

for i in {13..16}; do
    for f in ../../Input_Files/"R1F"$i/*; do
	cp $f ./zone.E/
    done
done

for i in {16..20}; do
    for f in ../../Input_Files/"R1F"$i/*; do
	cp $f ./zone.F/
    done
done



#Download Example Data

#EXAMPLE=1

#if [ EXAMPLE==1 ]
#then
#	wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR011/ERR011347/ERR011347_1.fastq.gz
#	wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR011/ERR011347/ERR011347_2.fastq.gz
#else
	#read in config
#fi

