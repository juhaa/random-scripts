#!/bin/bash
#
# Convert fasta file to DeepBind input by splitting sequences to train and test inputs and optionally shorten the sequences.
# Minimum # of peaks: 1000
# (DeepBind is made to work with sequences of length 101)
#
# Apr 2016, Juha Mehtonen
#
# Usage: sh fasta2deepbind.sh [fasta file] [seq lengths]
# Example: sh fasta2deepbind.sh fasta.fa 101
#


DATA=$1

sed '1~2d' $DATA > peaks.seq

if ! [ -z "$2" ]
then
python shortenSequences.py -i peaks.seq -o peaks.seq.tmp -n $2
mv peaks.seq.tmp peaks.seq
fi

head -1000 peaks.seq | sed '1~2d' > peaks_AC.seq
head -1000 peaks.seq | sed '0~2d' > peaks_odd.seq
tail -n +1001 peaks.seq >> peaks_AC.seq
rm peaks.seq

python DinucShuffle.py -i peaks_odd.seq -o peaks_B.seq -d
rm peaks_odd.seq

Rscript generateDeepBindInput.R peaks_AC.seq peaks_B.seq

gzip peaks_AC.seq
gzip peaks_B.seq
