# Generate the input files for DeepBind
#
# Apr 2016, Juha Mehtonen
#
# Give as input files AC and B containing one DNA sequence on each row, where:
# - AC has all true peaks
# - B has real peaks at odd rows and background seqs at even rows
#
# Usage: Rscript generateDeepBindInput.R AC_file B_file
#

args = commandArgs(T)
AC = toupper(scan(args[1], what = "character"))
B = toupper(scan(args[2], what = "character"))

n = length(AC)
ids = formatC(seq(1,n*2,2), width = 5, format = "d", flag = "0")
AC = data.frame(cbind(rep("A",n), paste("seq",ids,"peak",sep="_"), AC, rep(1,n)))

n = length(B)
ids_tmp = formatC(seq(2,n,2), width = 5, format = "d", flag = "0")
ids_peak = paste("seq", ids_tmp, "peak", sep = "_")
ids_shuf = paste("seq", ids_tmp, "shuf", sep = "_")

ids = c(rep(0,n))
j = 1
for (i in 1:n) {
   if (i %% 2 == 1) {
      ids[i] = ids_peak[j]
   }
   else {
      ids[i] = ids_shuf[j]
      j = j + 1
   }
}
B = data.frame(cbind(rep("B",n), ids, B, rep(c(1,0),n/2)))

colnames(AC) = colnames(B) = c("FoldID", "EventID", "seq", "Bound")

write.table(AC, args[1], quote = F, col.names = T, row.names = F, sep = "\t")
write.table(B, args[2], quote = F, col.names = T, row.names = F, sep = "\t") 
