#!/usr/bin/python

# author: Juha Mehtonen, Feb 2016

import sys, string, getopt

def main(argv):
  inputfile = ''
  outputfile = ''

  try:
    opts, args = getopt.getopt(argv,"hi:o:n:",["input=","output="])
  except getopt.GetoptError:
    print 'shortenSequences.py -i <inputfile> -o <outputfile> -n <seq length>'
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print 'shortenSequences.py -i <inputfile> -o <outputfile> -n <seq length>'
      sys.exit()
    elif opt in ("-i", "--input"):
      inputfile = arg
    elif opt in ("-o", "--output"):
      outputfile = arg
    elif opt == '-n':
      n = int(arg)

  with open(inputfile, "rU") as f:
    seq = f.readlines()
  seq[:] = (e[:-1] for e in seq)
  m = (len(seq[1]) - n) / 2.0
  if m > 0:
    if m.is_integer():
      seq[:] = (e[int(m):-(int(m))] for e in seq)
    else:
      seq[:] = (e[int(m-0.5):-(int(m+0.5))] for e in seq)
  handle_out = open(outputfile, "w")
  for e in seq:
    handle_out.write(e+"\n")


if __name__ == "__main__":
  main(sys.argv[1:])

