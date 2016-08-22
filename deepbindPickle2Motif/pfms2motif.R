#
# Jun 2016, Juha Mehtonen
#

args = commandArgs(T)

indir = args[1]
outdir = args[2]

library(seqLogo)

pwms = list.files(path = indir, pattern = "^pfm[0-9]*_[0-9]*[.]txt$")

pdf(paste0(outdir,"/motifs.pdf"))
for (i in pwms) plot(makePWM(t(read.delim(i))))
graphics.off()

