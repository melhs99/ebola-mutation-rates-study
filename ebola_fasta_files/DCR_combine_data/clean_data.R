library(NELSI)

aln <- read.dna('mafft_combined_DCR.fasta', format = 'fasta')

subset <- aln[1:29, ]

write.dna(subset, file = 'lam_sequences.fasta', format = 'fasta', nbcol = -1, colsep = '')
