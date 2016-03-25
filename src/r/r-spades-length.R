N = 9

spades.length <- read.delim("~/Run/kim-chlroplast/out/spades-length.txt", header=TRUE)

ncontigs = 15
spades.length20 = head(spades.length, n=ncontigs)

totalLengths = colSums(spades.length20)

yrange = range(spades.length20)
# yrange[2] = max(totalLengths)
xrange = c(0,N)

colors <- rainbow(ncontigs) 
linetype <- c(1:ncontigs) 
plotchar <- seq(18,18+ncontigs,1)


pdf("~/Run/kim-chlroplast/out/spades-length.pdf")


plot(xrange, yrange, type="n", xlab="Itertation", ylab="Length of Contigs (bp)" ) 

for (i in 1:ncontigs) { 
  lines(0:N, spades.length20[i,], type="b", lwd=1.5, lty=linetype[i], col=colors[i], pch=plotchar[i])
} 

# lines(0:6, totalLengths, type="b", lwd=1.5, lty=linetype[1], col=colors[1], pch=plotchar[1]) 

# add a title and subtitle 
title("Contigs Growth", "Juncus")

# add a legend 
legend(xrange[1], yrange[2], 1:ncontigs, cex=0.8, col=colors,
  	pch=plotchar, lty=linetype, title="Contig")


dev.off()

warnings()
