#!/bin/bash
#
# Jun 2016, Juha Mehtonen
#
#

function gen {
  sh $SCRIPTS"bed2fasta.sh" $DIR"/"$1 $REF
  sh $SCRIPTS"fasta2deepbind.sh" $DIR"/"$1".fa" $PEAKLENGTH
  mv peaks_AC.seq.gz $1"_"$PEAKLENGTH"_AC.seq.gz"
  mv peaks_B.seq.gz $1"_"$PEAKLENGTH"_B.seq.gz"
  rm -f $NPEAKS".peaks.fa"
}

DIR=$1
REF=$2
PEAKLENGTH=$3

SCRIPTS="/home/users/jmehtone/scripts/"

for file in $DIR/*; do
  [ -f "${file}" ] || continue
  subfile="$(basename "${file}")"
  gen $subfile
done
