#!/bin/bash
#
# Get DNA sequences from reference genome matching top peaks
#
# Apr 2016, Juha Mehtonen
#
# Usage: sh getPeakSequences.sh [tagdir] [ref genome] [# peaks]
# Example: sh getPeakSequences.sh /home/work/public/biowhat/chipres/tagdirs/GSE56872/GSE56872_RXR_4h_default_mm9/ mm9 1000
#


TAGDIR=$1
REF=$2
PEAKS=$3
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

# Get peaks
if [ $PEAKS = "all" ]
then
grep -v "^#" $TAGDIR"peaks.txt" > $PEAKS".peaks.txt"
else
getTopPeaks.pl $TAGDIR"peaks.txt" $PEAKS > $PEAKS".peaks.txt"
fi

# Convert to bed file
pos2bed.pl $PEAKS".peaks.txt" > $PEAKS".peaks.bed"

# Sort
sort -k1,1 -k2,2n $PEAKS".peaks.bed" | uniq > $PEAKS".peaks.sorted.bed"

# Get DNA sequence
bedtools getfasta -fi $REFFA -bed $PEAKS".peaks.sorted.bed" -fo $PEAKS.peaks.fa

rm $PEAKS".peaks.txt" $PEAKS".peaks.bed" $PEAKS".peaks.sorted.bed"
