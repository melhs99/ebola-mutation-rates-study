library(NELSI)

aln <- read.dna('vipr_lam_aligned.fasta', format = 'fasta')

cladeA2018 <- readLines('2018_cladeA.txt')
cladeB2018 <- readLines('2018_cladeB.txt')

cladeA2014 <- readLines('2014_cladeA.txt')
cladeB2014 <- readLines('2014_cladeB.txt')

#All 2018
all2018 <- aln[c(cladeA2018, cladeB2018), ]
write.dna(all2018, file = 'dcr_all_2018.fasta', format = 'fasta', nbcol = -1, colsep = '')

#Clade A 2018
cladeA_2018 <- aln[cladeA2018, ]
write.dna(cladeA_2018, file = 'dcr_cladeA_2018.fasta', format = 'fasta', nbcol = -1, colsep = '')

#Clade B 2018
cladeB_2018 <- aln[cladeB2018, ]
write.dna(cladeB_2018, file = 'dcr_cladeB_2018.fasta', format = 'fasta', nbcol = -1, colsep = '')
