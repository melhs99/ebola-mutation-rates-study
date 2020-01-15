library(NELSI)

public_seq <- read.dna('vipr_dcr_data.fasta', format = 'fasta')

lam_seq <- read.dna('lam_sequences_dates.fasta', format = 'fasta')


public_accns <- sapply(names(public_seq), function(x) strsplit(x, '[|]')[[1]][2], USE.NAMES = F)
lam_accns <- sapply(rownames(lam_seq), function(x) gsub('[.].+', '', x), USE.NAMES = F)

public_non_overlap <- public_seq[-which(public_accns %in% lam_accns)]
public_non_overlap <- public_non_overlap[grep('Zaire', names(public_non_overlap))]
write.dna(public_non_overlap, file = 'vipr_dcr_data_dates.fasta',
			      format = 'fasta', nbcol = -1, colsep = '')

