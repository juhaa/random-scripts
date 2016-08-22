#!/usr/bin/python

# author: Juha Mehtonen, Jun 2016

import sys, string, getopt, cPickle, numpy

def main(argv):
  inputfile = ''

  try:
    opts, args = getopt.getopt(argv,"hi:",["input="])
  except getopt.GetoptError:
    print 'pickle2pfms.py -i <inputfile>'
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print 'pickle2pfms.py -i <inputfile>'
      sys.exit()
    elif opt in ("-i", "--input"):
      inputfile = arg

  with open(inputfile) as f:
    _ = cPickle.load(f)
    pfms = _["pfms"]
    ics  = _["ic"]
    counts = _["counts"]

  for i in range(len(pfms)):
    numpy.savetxt("pfm%s_%s.txt" % (i,counts[i]), pfms[i], delimiter="\t")


if __name__ == "__main__":
  main(sys.argv[1:])

