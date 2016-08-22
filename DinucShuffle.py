#!/usr/bin/python

# author: Juha Mehtonen, Feb 2016

import sys, string, getopt
import doubletShuffle as ds
from Bio import SeqIO

def main(argv):
  inputfile = ''
  outputfile = ''
  deepbind = False
  fasta = False

  try:
    opts, args = getopt.getopt(argv,"hi:o:df",["input=","output=","deepbind","fasta"])
  except getopt.GetoptError:
    print 'dinucShuffle.py -i <inputfile> -o <outputfile> [-d][-f]'
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print 'DinucShuffle.py -i <inputfile> -o <outputfile> [-d][-f]'
      sys.exit()
    elif opt in ("-i", "--input"):
      inputfile = arg
    elif opt in ("-o", "--output"):
      outputfile = arg
    elif opt in ("-d", "--deepbind"):
      deepbind = True
    elif opt in ("-f", "--fasta"):
      fasta = True
  
  handle_in = open(inputfile, "rU")
  handle_out = open(outputfile, "w")
  if deepbind:
    if fasta:
      for s in SeqIO.parse(handle_in, "fasta"):
        x = str(s.seq)
        y = ds.doublet_shuffle(x)
        handle_out.write(x+"\n"+y+"\n")
    else:
      for s in handle_in:
        x = s.rstrip('\n').rstrip('\r')
        y = ds.doublet_shuffle(x)
        handle_out.write(x+"\n"+y+"\n")
  else:
    if fasta:
      for s in SeqIO.parse(handle_in, "fasta"):
        x = ds.doublet_shuffle(str(s.seq))
        handle_out.write(x+"\n")
    else:
      for s in handle_in:
        x = ds.doublet_shuffle(s.rstrip('\n').rstrip('\r'))
        handle_out.write(x+"\n")
  handle_in.close()
  handle_out.close()
  

if __name__ == "__main__":
  main(sys.argv[1:])
