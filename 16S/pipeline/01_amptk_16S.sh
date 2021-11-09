#!/usr/bin/bash
#SBATCH -p short -C xeon  -N 1 -n 16 --mem 8gb --out logs/AMPtk_16S.%A.log

CPU=$SLURM_CPUS_ON_NODE

if [ ! $CPU ]; then
 CPU=2
fi

#AMPtk needs to be loaded in miniconda2 for UCR HPCC
#We'll need to unload miniconda3 and load miniconda2 before load AMPtk
module unload miniconda2
module load amptk/1.5.3
module load usearch

#Set up basename for all the output that will be generated
BASE=Pilot_16S

#Chnage this to match your data folder name
INPUT=illumina

#Pre-preocessing steps will use `amptk illumia` command for demultiplexed PE reads
if [ ! -f $BASE.demux.fq.gz ]; then
 amptk illumina -i $INPUT --merge_method vsearch -f 515FB -r 806RB --require_primer off -o $BASE --usearch usearch9 --cpus $CPU --rescue_forward on --primer_mismatch 2 -l 300
fi

if [ ! -f $BASE.otu_table.txt ];  then
 amptk cluster -i $BASE.demux.fq.gz -o $BASE --uchime_ref 16S --usearch usearch9 --map_filtered -e 0.9 --cpus $CPU
fi

if [ ! -f $BASE.otu_table.taxonomy.txt ]; then
 amptk taxonomy -f $BASE.cluster.otus.fa -i $BASE.otu_table.txt -d 16S
fi
