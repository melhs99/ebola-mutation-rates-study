library(ape)

large_aln <- read.dna('2014_large_3.fasta', format = 'fasta')

geo_match <- grep('Sierra_Leone', rownames(large_aln))
geo_secs <- large_aln[geo_match, ]

write.dna(geo_secs, file = 'sierra_leone_testoutput.fasta', format = 'fasta', nbcol = -1, colsep = '')
