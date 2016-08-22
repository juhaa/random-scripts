#!/bin/bash
#
# Apr 2016, Juha Mehtonen
#
#

cd $1

for file in $1/*; do
  [ -f "${file}" ] || continue
  f="$(basename "${file}")"
  cp $f tmp.bed
  cut -f1-6 tmp.bed | sed "1 i\track name=\"${f}\" description=\"${f}\"" > $f
  rm tmp.bed
done
