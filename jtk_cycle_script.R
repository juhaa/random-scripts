# Load JKT_CYCLE functions
source("/home/users/jmehtone/JTK_cycle/JTK_CYCLEv3.1.R")

setwd("/home/work/public/biowhat/circadian/")

project <- "circ"

# Read data
options(stringsAsFactors=FALSE)
data = read.delim("exprs_in_fit.txt")
anno = read.delim("genes_in_fit.txt")

rownames(data) <- anno$probeID
jtkdist(timepoints = ncol(data), reps = 1, normal = F, alt = F)

periods <- 2:24
jtk.init(periods,2)

cat("JTK analysis started on",date(),"\n")
flush.console()

st <- system.time({
  res <- apply(data,1,function(z) {
    jtkx(z)
    c(JTK.ADJP,JTK.PERIOD,JTK.LAG,JTK.AMP)
  })
  res <- as.data.frame(t(res))
  bhq <- p.adjust(unlist(res[,1]),"BH")
  res <- cbind(bhq,res)
  colnames(res) <- c("BH.Q","ADJ.P","PER","LAG","AMP")
  results <- res[order(res$ADJ.P,-res$AMP),]
})
print(st)

save(results,file=paste("JTK",project,"rda",sep="."))
write.table(results,file=paste("JTK",project,"txt",sep="."),row.names=F,col.names=T,quote=F,sep="\t")



library(ggplot2)
for(i in 70:80) {
  probe = rownames(results)[i]
  y = as.numeric(data[rownames(data)==probe,])
  x = seq_along(y)
  print(qplot(x = x,y = y, geom = "path"))
}



