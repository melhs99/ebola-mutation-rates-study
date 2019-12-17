library(ape)

aln <- read.dna('2014_large_3.fasta', format = 'fasta')

dates <- gsub('.+@', '', rownames(aln))

hist(as.numeric(dates))
plot(as.numeric(dates), 1:length(dates))
quants <- quantile(as.numeric(dates))
for(i in 1:length(quants)) lines(rep( quants[i], 2), c(0, 5000),  col = 'red')
splits <- c(2014, 2014.5, 2015, 2015.5, 2016, 2016.5)
for(i in 1:length(splits)) lines(rep(splits[i], 2), c(0, 5000), col = 'blue')


subset1 <- aln[dates >= splits[1] & dates < splits[2], ]
subset2 <- aln[dates >= splits[2] & dates < splits[3], ]
subset3 <- aln[dates >= splits[3] & dates < splits[4], ]
subset4 <- aln[dates >= splits[4] & dates < splits[5], ]