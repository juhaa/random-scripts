#!/bin/bash
#
# Get DNA sequences from reference genome matching bed-file
#
# Sep 2016, Juha Mehtonen
#
# Usage: sh bed2fasta.sh [bed-file] [ref genome]
# Example: sh bed2fasta.sh example.bed mm9
# Output: [bed-file].fa
#


BED=$1
REF=$2
GVER="UCSC"

GPATH="/home/work/public/iGenomes/"

if [ $REF = "hg19" ]
then
GSPEC="Homo_sapiens"
else
        if [ $REF = "mm9" -o $REF = "mm10" ]
        then
        GSPEC="Mus_musculus"
        else
        echo "Couldn't find reference genome."
        exit 1
        fi
fi

REFFA=$GPATH$GSPEC"/"$GVER"/"$REF"/Sequence/WholeGenomeFasta/genome.fa"

# Get DNA sequence
bedtools getfasta -fi $REFFA -bed $BED -fo $BED".fa"

