#!/usr/bin/bash -l

SAMPLES=samples.csv
INFOLDER=original
OUTFOLDER=illumina
mkdir -p $OUTFOLDER
IFS=,
while read BASE NAME
do
 echo "$BASE $NAME"
 pushd $OUTFOLDER
 ln -s ../$INFOLDER/${BASE}_R1_001.fastq.gz ${NAME}_R1.fastq.gz
 ln -s ../$INFOLDER/${BASE}_R2_001.fastq.gz ${NAME}_R2.fastq.gz
 popd
done < $SAMPLES
