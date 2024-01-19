library(ggplot2)
len=read.table("str.length",head=F)
result=read.table("simulation.estimation_count.results",head=F)
result$V2 <- as.character(result$V2)
df <- do.call(rbind, replicate(11, len, simplify = FALSE))
result$V2[which(result$V2=="N1")]=-1
result$V2[which(result$V2=="N2")]=-2
result$V2[which(result$V2=="N3")]=-3
result$V2[which(result$V2=="N4")]=-4
result$V2[which(result$V2=="N5")]=-5
result$V2[which(result$V2=="P0")]=0
result$V2[which(result$V2=="P1")]=1
result$V2[which(result$V2=="P2")]=2
result$V2[which(result$V2=="P3")]=3
result$V2[which(result$V2=="P4")]=4
result$V2[which(result$V2=="P5")]=5
df$V3 <- c(rep(0, nrow(len)),rep(1, nrow(len)),rep(2, nrow(len)),rep(3, nrow(len)),rep(4, nrow(len)),rep(5, nrow(len)),rep(-1, nrow(len)),rep(-2, nrow(len)),rep(-3, nrow(len)),rep(-4, nrow(len)),rep(-5, nrow(len)))
df$V4 <- 0
str=as.character(unique(len$V1))
for(i in str){
for(j in -5:5){
if(length(which(result$V1==i&result$V2==j)))
df$V4[which(df$V1==i&df$V3==j)]=length(which(result$V1==i&result$V2==j))
}
}

dff=expand.grid(len=c(20,30,40,50,60,70,80,90),gap=-5:5,mean=0)
for(m in -5:5){
dff$mean[which(dff$len==20&dff$gap==m)]=mean(df$V4[which(df$V2<=25&df$V2>=15&df$V3==m)])
dff$mean[which(dff$len==30&dff$gap==m)]=mean(df$V4[which(df$V2<=35&df$V2>=26&df$V3==m)])
dff$mean[which(dff$len==40&dff$gap==m)]=mean(df$V4[which(df$V2<=45&df$V2>=36&df$V3==m)])
dff$mean[which(dff$len==50&dff$gap==m)]=mean(df$V4[which(df$V2<=55&df$V2>=46&df$V3==m)])
dff$mean[which(dff$len==60&dff$gap==m)]=mean(df$V4[which(df$V2<=65&df$V2>=56&df$V3==m)])
dff$mean[which(dff$len==70&dff$gap==m)]=mean(df$V4[which(df$V2<=75&df$V2>=66&df$V3==m)])
dff$mean[which(dff$len==80&dff$gap==m)]=mean(df$V4[which(df$V2<=85&df$V2>=76&df$V3==m)])
dff$mean[which(dff$len==90&dff$gap==m)]=mean(df$V4[which(df$V2>=86&df$V3==m)])
}
dff$mean=dff$mean*10

ggplot(dff, aes(x = len, y = gap, fill = mean)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Mappability", x = "STR length", y = "Copy difference") +  theme_bw()
ggsave("Mappability.png",dpi = 400, width = 8, height = 8)
