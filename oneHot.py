#!/bin/python
#
# Transform DNA sequence into ordinal matrix (One-hot encoding)

import sys, getopt
import numpy as np
import scipy.io as sio
from Bio import SeqIO

_ord2acgt = ['N']*256;    # lookup table for str.translate, so that 0123 => GATC
_ord2acgt[0] = 'A';
_ord2acgt[1] = 'C';
_ord2acgt[2] = 'G';
_ord2acgt[3] = 'T';
_ord2acgt = "".join(_ord2acgt)

_acgt2ord = ['\xff']*256;    # lookup table for str.translate, so that GATC => 0123
_acgt2ord[ord('a')] = _acgt2ord[ord('A')] = '\x00';
_acgt2ord[ord('c')] = _acgt2ord[ord('C')] = '\x01';
_acgt2ord[ord('g')] = _acgt2ord[ord('G')] = '\x02';
_acgt2ord[ord('t')] = _acgt2ord[ord('T')] = '\x03';
_acgt2ord[ord('u')] = _acgt2ord[ord('U')] = '\x03';
_acgt2ord = "".join(_acgt2ord)

_acgtcomplement = ['\xff']*256;    # lookup table for str.translate, so that GATC => CTAG
_acgtcomplement[ord('a')] = _acgtcomplement[ord('A')] = 'T';
_acgtcomplement[ord('c')] = _acgtcomplement[ord('C')] = 'G';
_acgtcomplement[ord('g')] = _acgtcomplement[ord('G')] = 'C';
_acgtcomplement[ord('t')] = _acgtcomplement[ord('T')] = 'A';
_acgtcomplement[ord('u')] = _acgtcomplement[ord('U')] = 'A';
_acgtcomplement[ord('n')] = _acgtcomplement[ord('N')] = 'N';
_acgtcomplement = "".join(_acgtcomplement)

def main(argv):
  inputfile = ''
  outputfile = ''
  try:
    opts, args = getopt.getopt(argv,"hi:o:",["input=","output="])
  except getopt.GetoptError:
    print 'oneHot.py -i <inputfile> -o <outputfile>'
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print 'oneHot.py -i <inputfile> -o <outputfile>'
      sys.exit()
    elif opt in ("-i", "--input"):
      inputfile = arg
    elif opt in ("-o", "--output"):
      outputfile = arg
  handle_in = open(inputfile, "rU")
  seqs = list(SeqIO.parse(handle_in, "fasta"))
  handle_in.close()
  n = len(seqs)
  N = len(str(seqs[1].seq))
  D = 4
  out = np.zeros((n,N,D),dtype=np.uint8)
  for i in range(0,n-1):
    out[i,:,:] = acgt2mask(str(seqs[i].seq))
  sio.savemat(outputfile, {'data':out})
  

def acgt2ord(s):
    """
    Convert an RNA string ("ACGT") into a numpy row-vector
    of ordinals in range {0,1,2,3,255} where 255 indicates "padding".
    """
    x = s.translate(_acgt2ord)
    return np.ndarray(shape=(1,len(x)),buffer=x,dtype=np.uint8)


def ord2acgt(x):
    """
    Convert a vector of integral values in range {0,1,2,3}
    to an RNA string ("ACGT"). Integers outside that range will
    be translated to a "padding" character (".").
    """
    s = str(np.asarray(x,dtype=np.uint8).data).translate(_ord2acgt)
    return s


def ord2mask(x):
    """
    Convert a vector of length N with integral values in range {0,1,2,3}
    into an Nx4 numpy array, where for example "2" is represented by
    row [0,0,1,0].
    """
    mask = np.zeros((x.size,4))
    mask[np.arange(x.size),x] = 1
    return mask


def acgt2mask(s):
    """
    Convert an RNA string ("ACGT") of length N into an Nx4 numpy
    array, where for example "G" is represented by row [0,0,1,0].
    """
    return ord2mask(acgt2ord(s))

def acgtcomplement(s):
    """
    Complement a DNA string ("ACGT" to "TGCA").
    """
    return s.translate(_acgtcomplement)

def revcomp(s):
    """
    Reverse complement a DNA string ("ATTGC" to "GCAAT").
    """
    return s.translate(_acgtcomplement)[::-1]


if __name__ == "__main__":
  main(sys.argv[1:])
