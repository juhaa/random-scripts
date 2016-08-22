## Random scripts for various tasks

- CMI2NI.m
	- Conditional mutual inclusive information(CMI2)-based Network Inference method for gene expression data.
	- Author: Xiujun Zhang.

- run_CMI2NI.R
	- R wrapper for CMI2NI.m.

- jtk_cycle_script.R
	- example script for using JTK_Cycle, an algorithm to identify rhythmic components in large, genome-scale data sets and estimate their period length, phase, and amplitude.
	- Author: [Karl Kornacker](https://scholar.google.com/citations?user=1hw5bX4AAAAJ&hl=en) and [John Hogenesch](http://www.med.upenn.edu/apps/faculty/index.php/g275/p8127424).

- doubletShuffle.py
	- Script for shuffling a sequence while preserving the doublet fequency.
	- Author: Babak Alipanahi

- oneHot.py
	- Script to transform DNA sequence into ordinal matrix (One-hot encoding)

- shortenSequences.py
	- Script to shorten file containing sequences of various length to user-defined length from both ends equally.

- generateDeepBindInput.R
	- Script to generate valid DeepBind input files from two files containing DNA sequences.

- getPeakSequences.sh
	- Get DNA sequences from reference genome matching top peaks.

- genmaster.sh
	- Master script to get peak sequences from peakfiles and generate fasta files.

- genUCSCbed.sh
	- Add to a folder of bed-files header info to be compatible with UCSC genome browser.

- pool_top_chip_peaks.sh
	- Pool multiple chip files together.

- bed2fasta.sh
	- Get DNA sequences from reference genome matching bed-file.

- fasta2deepbind.sh
	- Convert fasta file to DeepBind input by splitting sequences to train and test inputs and optionally shorten the sequences.

- genmaster2.sh
	- Master script to convert folder of bed-files to fasta-files.

- DinucShuffle.py
	- Shuffle fasta or plain sequence files with dinucleotide shuffle.

------------------

- pickle2pfms.py
	- Convert DeepBind pickle-files to PFMs.

- pfms2motif.R
	- Plot PFMs as motif logos.

- pkl2motif.sh
	- Master script to convert DeepBind pickle-files to motif logos.
