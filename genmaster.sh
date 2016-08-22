#!/bin/bash
#
# Apr 2016, Juha Mehtonen
#
#

function gen {
  sh $SCRIPTS"getPeakSequences.sh" $DIR"/"$1"/" $REF $NPEAKS
  sh $SCRIPTS"fasta2deepbind.sh" $NPEAKS".peaks.fa" $PEAKLENGTH
  mv peaks_AC.seq.gz $1"_"$PEAKLENGTH"_AC.seq.gz"
  mv peaks_B.seq.gz $1"_"$PEAKLENGTH"_B.seq.gz"
  rm -f $NPEAKS".peaks.fa"
}

DIR=$1
REF=$2
NPEAKS=$3
PEAKLENGTH=$4

SCRIPTS="/home/users/jmehtone/scripts/"

for dir in $DIR/*; do
  [ -d "${dir}" ] || continue
  subdir="$(basename "${dir}")"
  gen $subdir
done
