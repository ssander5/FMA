#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_C


#make output folder

if [ -d trimmomatic ]; then
    echo "directory exists"
else
    mkdir trimmomatic
fi

if [ -d sickle ]; then
    echo "directory exists"
else
    mkdir sickle
fi

echo "Trimming with Trimmomatic and Sickle"

for z in ../B0_*/zone.[A-Z]; do
    if [ -d trimmomatic/${z#../B0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./trimmomatic/${z#../B0_*/}
    fi

    if [ -d sickle/${z#../B0_*/} ]; then
        echo "directory exists"
    else
        mkdir ./sickle/${z#../B0_*/}
    fi

    for g in $z/*R1*; do
    i1=$g
    i2=${g%R1*}"R2*"
    o=${g#../B0_Read_Data/}
    base=${o%_R1*}

    echo trimmomatic PE $i1 $i2 \
    -threads 16 \
    -trimlog ./trimmomatic/$base.trimlog.txt \
    ./trimmomatic/$base.1.trimclean.fq \
    ./trimmomatic/$base.1.u.trimclean.fq \
    ./trimmomatic/$base.2.trimclean.fq \
    ./trimmomatic/$base.2.u.trimclean.fq \
    ILLUMINACLIP:../../Reference/adaptors.fa:1:50:30 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:60

    #sickle pe
    sickle pe \
    -n \
    -f ./trimmomatic/$base.1.trimclean.fq \
    -r ./trimmomatic/$base.2.trimclean.fq \
    -o ./sickle/$base.1.trimclean.sickleclean.fq \
    -p ./sickle/$base.2.trimclean.sickleclean.fq \
    -t sanger \
    -q 20 \
    -l 60 \
    -s ./sickle/$base.u.trimclean.sickleclean.fq

    #sickle se
    sickle se \
    -n \
    -f ./trimmomatic/$base.1.u.trimclean.fq \
    -o ./sickle/$base.1.u.trimclean.sickleclean.fq \
    -t sanger \
    -q 20 \
    -l 60 \

    sickle se \
    -n \
    -f ./trimmomatic/$base.2.u.trimclean.fq \
    -o ./sickle/$base.2.u.trimclean.sickleclean.fq \
    -t sanger \
    -q 20 \
    -l 60 \

    #combining unpaired
    cat ./sickle/$base.1.u.trimclean.sickleclean.fq \
    ./sickle/$base.2.u.trimclean.sickleclean.fq \
    ./sickle/$base.u.trimclean.sickleclean.fq > \
    ./sickle/$base.unpaired.trimclean.sickleclean.fq

    rm ./sickle/$base.1.u.trimclean.sickleclean.fq ./sickle/$base.2.u.trimclean.sickleclean.fq ./sickle/$base.u.trimclean.sickleclean.fq
    done
done
