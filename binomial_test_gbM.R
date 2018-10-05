#!/bin/R
args <- commandArgs(T)
data <- read.table(args[1],header = F, stringsAsFactors = F)
out <- args[2]
data$CG_pval=apply(data[,2:4],1,function(x){ifelse(x[2]==0,NA,binom.test(x[1],x[2],x[3],alternative = c("greater"))$p.value)})
data$CHG_pval=apply(data[,5:7],1,function(x){ifelse(x[2]==0,NA,binom.test(x[1],x[2],x[3],alternative = c("greater"))$p.value)})
data$CHH_pval=apply(data[,8:10],1,function(x){ifelse(x[2]==0,NA,binom.test(x[1],x[2],x[3],alternative = c("greater"))$p.value)})
data$CG_qval=p.adjust(data$CG_pval,"BH") 
data$CHG_qval=p.adjust(data$CHG_pval,"BH")
data$CHH_qval=p.adjust(data$CHH_pval,"BH")
write.table(data, file = out,sep="\t",quote=F,col.names = F,row.names=F,eol="\n")

