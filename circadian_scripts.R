###### Network inference methods with circadian data

setwd("/home/work/public/biowhat/circadian/")

# Load data
data = read.delim("exprs_in_fit.txt")
anno = read.delim("genes_in_fit.txt")
pdata = read.delim("pdata.txt")
pdata = pdata[match(colnames(data), pdata$gsm),]


v = apply(data,1, var)
idx = which(v > 8) # High variance gene indices
idx = c(idx, which(v > 1 & v < 1.01)) # Low variance gene indices
idx = sort(idx)
genes = as.character(anno$symbol[idx]) # Get gene symbols
D = data.frame(t(data[idx,]), pdata$tissue) # Low and high variance gene data
colnames(D) = c(genes, "tissue")

###### Test out CCM with high variance & relatively low variance genes

# install.packages("multispatialCCM")
library(multispatialCCM)

maxE = 21 # Max embedding dimension to test out (21 is max for 24 timepoints)
Emat = matrix(0, nrow = maxE-1, ncol = length(genes))
colnames(Emat) = genes
timepoints = 24
u = length(unique(D$tissue))
D2 = matrix(nrow = nrow(D) + u - 1, ncol = length(genes)) # Matrix to contain input data for spatialCCM
colnames(D2) = genes

# Format D to input data form D2
for(i in genes) {
  x = D[,i]
  n = timepoints
  for(j in 1:(u-1)) {
    x = append(x, NA, n)
    n = n + timepoints + 1
  }
  D2[,i] = x
}

# Calculate different embedding dimension scores for each gene
for(i in genes) {
  for(E in 2:maxE) {
    Emat[E-1,i] = SSR_pred_boot(A = D2[,i], E = E, predstep = 1, tau = 1)$rho
  }
}

# E contains best embedding dimensions for each gene
E = apply(Emat, 2, function(x) { which(x == max(x)) + 1 })

# Check whether predictive ability declines (rho) (should decline?)
check = list()
check[[i]] = SSR_check_signal(A = D2[,i], E = E[i], tau = 1, predsteplist = 1:20)

# Test each gene against each other for causality
ccm_result_pvals = matrix(0, nrow = ncol(D2), ncol = ncol(D2))
rownames(ccm_result_pvals) = colnames(ccm_result_pvals) = colnames(D2)

# Collect CCM results to list
ccm = list()
a <- Sys.time()
for(i in 1:(nrow(ccm_result_pvals)-1)) {
  gene_i = rownames(ccm_result_pvals)[i]
  x_i = D2[,gene_i]
  for(j in (i+1):ncol(ccm_result_pvals)) {
    gene_j = colnames(ccm_result_pvals)[j]
    x_j = D2[,gene_j]
    ccm_i = CCM_boot(x_i, x_j, E[gene_i], tau = 1, iterations = 100)
    ccm_j = CCM_boot(x_j, x_i, E[gene_j], tau = 1, iterations = 100)
    sigtest = ccmtest(ccm_i,ccm_j)
    ccm_result_pvals[i,j] = sigtest[1]
    ccm_result_pvals[j,i] = sigtest[2]
    ccm[[gene_i]][[gene_j]] = ccm_i
    ccm[[gene_j]][[gene_i]] = ccm_j
  }
}
b <- Sys.time()
b-a

# Plotting function for CCM results
plotCCM = function(geneA, geneB, legend = T) {
  x = ccm[[geneA]][[geneB]]
  y = ccm[[geneB]][[geneA]]
  r = range(x$Lobs,y$Lobs)
  plot(x$Lobs, x$rho, type = "l", col = 1, lwd = 2, xlim = r, ylim = c(0,1), xlab = "L", ylab = "rho")
  matlines(x$Lobs, cbind(x$rho - x$sdevrho, x$rho + x$sdevrho), lty = 3, col = 1)
  lines(y$Lobs, y$rho, type = "l", col = 2, lty = 2, lwd = 2)
  matlines(y$Lobs, cbind(y$rho - y$sdevrho, y$rho + y$sdevrho), lty = 3, col = 2)
  if(legend) legend("topleft", c(paste(geneA, "->", geneB), paste(geneB, "->", geneA)), lty = 1:2, col = 1:2, lwd = 2, bty ="n")
}






###### aracne
library(minet)

D1 = D[1:24,1:45]
mim = build.mim(D1, estimator = "mi.shrink", disc = "equalwidth", nbins = sqrt(nrow(D1)))
res = aracne(mim)





###### 
library(GRENITS)

D1 = data[,pdata$tissue=="heart"]

LinearNet("GRENITS_out/", D1)
analyse.output("GRENITS_out")







