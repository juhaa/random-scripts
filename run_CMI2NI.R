# run_CMI2NI.R
# Run the CMI2NI.m script from R
# data: nxd matrix or data frame where rows are samples and columns are variables
# order: number of iterations. Defaults to NULL (run until no change in network).

run_CMI2NI <- function(data, order = NULL) {
  
  if(!all(apply(data,2,is.numeric))) stop("data must be numeric.")
  if(!is.numeric(order) & !is.null(order)) stop("order must be numeric or NULL.")
  
  write.table(t(data), "/home/users/jmehtone/temp/cmmdata.txt", row.names = F, col.names = F, quote = F, sep = "\t")
  
  lambda = 0
  start = "matlab -nojvm -nodisplay -nosplash -r \""
  path = "addpath('/home/users/jmehtone/scripts');"
  read = "X = dlmread('/home/users/jmehtone/temp/cmmdata.txt');"
  if(is.null(order)) { run = paste0("[~,Gval,~] = CMI2NI(X,",lambda,");") 
  } else { run = paste0("[~,Gval,~] = CMI2NI(X,",lambda,",",order,");") }
  write = "dlmwrite('/home/users/jmehtone/temp/cmmresult.txt',Gval,'\\t');"
  exit = "exit;\""
  
  system(paste(start, path, read, run, write, exit))
  
  result = read.delim("/home/users/jmehtone/temp/cmmresult.txt", header = F)
  colnames(result) = rownames(result) = colnames(data)
  
  return(result)
  
}