#!/bin/R
args <- commandArgs(T)
data <- read.table(args[1],header = F, stringsAsFactors = F)
out <- args[2]
c <- as.numeric(args[3])/100
data$pval=apply(data[,4:5],1,function(x){ifelse((x[1]+x[2])== 0,1,binom.test(x[1],(x[1]+x[2]),1-c,alternative = c("greater"))$p.value)})
data$qval=p.adjust(data$pval,"BH")
write.table(data, file = out ,sep="\t",quote=F,col.names = F,row.names=F,eol="\n")

