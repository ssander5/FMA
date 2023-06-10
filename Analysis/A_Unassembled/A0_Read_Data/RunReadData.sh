#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunReadData

#Make Zones
for l in A B C D E F ; do
    mkdir zone.$l
done

    cd zone.A
    ln -s ../../../../Input_Files/*_S1_* .
    ln -s ../../../../Input_Files/*_S3_* .
    cd ..

    echo cd zone.B
    echo ln -s ../../../../Input_Files/*_S4_*
    echo ln -s ../../../../Input_Files/*_S5_*
    echo ln -s ../../../../Input_Files/*_S6_*
    echo cd ..

    echo cd zone.C
    echo ln -s ../../../../Input_Files/*_S7_*
    echo ln -s ../../../../Input_Files/*_S8_*
    echo ln -s ../../../../Input_Files/*_S9_*
    echo cd ..

    echo cd zone.D
    echo ln -s ../../../../Input_Files/*_S10_*
    echo ln -s ../../../../Input_Files/*_S11_*
    echo ln -s ../../../../Input_Files/*_S12_*
    echo cd ..

    echo cd zone.E
    echo ln -s ../../../../Input_Files/*_S13_*
    echo ln -s ../../../../Input_Files/*_S14_*
    echo ln -s ../../../../Input_Files/*_S15_*
    echo cd ..

    echo cd zone.F
    echo ln -s ../../../../Input_Files/*_S16_*
    echo ln -s ../../../../Input_Files/*_S17_*
    echo ln -s ../../../../Input_Files/*_S18_*
    echo cd ..



#Download Example Data

#EXAMPLE=1

#if [ EXAMPLE==1 ]
#then
#	wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR011/ERR011347/ERR011347_1.fastq.gz
#	wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR011/ERR011347/ERR011347_2.fastq.gz
#else
	#read in config
#fi

