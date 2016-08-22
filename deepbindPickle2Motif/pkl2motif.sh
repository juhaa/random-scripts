#!/bin/bash
#
# Convert pickle-file from DeepBind to motif images
# Jun 2016, Juha Mehtonen
#
#

PICKLE=$1
DIR=$2

SCRIPTS="/home/users/jmehtone/scripts/deepbindPickle2Motif"

mkdir -p $DIR
cd $DIR

if [ ! -f "$PICKLE" ]; then
  echo "File not found."
  exit 1
fi

python $SCRIPTS"/"pickle2pfms.py -i $PICKLE

Rscript $SCRIPTS"/"pfms2motif.R $DIR $DIR
 
