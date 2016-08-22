#!/bin/bash

CHIP_GSE_DIR=$1
PEAKS=$2

for dir in $CHIP_GSE_DIR/*; do
  [ -d "${dir}" ] || continue
  subdir="$(basename "${dir}")"
  if [[ ! $subdir =~ "input" ]]
  then
    PDIR=$CHIP_GSE_DIR"/"$subdir"/"
    getTopPeaks.pl $PDIR"peaks.txt" $PEAKS > $PDIR$PEAKS".peaks.txt"
    pos2bed.pl $PDIR$PEAKS".peaks.txt" > $PDIR$PEAKS".peaks.bed"
    cat $PDIR"/"$PEAKS".peaks.bed" >> $CHIP_GSE_DIR"/"$PEAKS".peaks.pooled.tmp"
  fi
done

sort -u -k1,1 -k2,2n -k3,3n -k5,5 $CHIP_GSE_DIR"/"$PEAKS".peaks.pooled.tmp" > $CHIP_GSE_DIR"/"$PEAKS".peaks.pooled.bed"
rm $CHIP_GSE_DIR"/"$PEAKS".peaks.pooled.tmp"
