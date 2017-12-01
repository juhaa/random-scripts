#!/bin/bash
#
# Dec 2017, Juha Mehtonen
#
#

folder=$(readlink -f $1)
cd $folder

for file in $folder/*; do
  [ -f "${file}" ] || continue
  f="$(basename "${file}")"
  if [[ $f == *.bed ]] && [[ ! $(head -1 $f) =~ "track name=" ]]
  then
    echo "$f --> $f.viz"
    awk -v OFS='\t' '{print $1,$2,$3,$4,'0',$6}' $f | sed "1 i\track name=\"${f}\" description=\"${f}\"" > $f".viz"
  fi
done
