  GNU nano 6.2                                                                                         D_skip.sh *                                                                                                 
#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_D

#make output folder

if [ -d ./bbmap ]; then
    echo "directory exists"
else
    mkdir bbmap
fi

for z in ../C0_*/zone*; do
    mkdir ./bbmap/${z#../C0_*/}
done


echo "SKIPPING Removing phix adaptors and sequencing artifacts using BBMAP"

for g in ./sickle/*/*trimclean.sickleclean.fq ; do
    o=${g#./sickle*/}
    echo $o

    cp ${g} ./bbmap/${o%trim*}trimclean.sickleclean.spikeclean.fq
done
