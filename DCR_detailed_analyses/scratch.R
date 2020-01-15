library(NELSI)


# DCR all | 2018 DCR nextstrain | 2018 DCR public | Tommy's | 2014-2018 Public

# Find duplicates in "all" data set from nextstrain data:
all_dcr <- read.dna('all_congo_data_aligned.fasta', format = 'fasta')
nextstrain_metadata <- read.table('metadata.tsv', head = T, sep = '\t', stringsAsFactors = F)
matches_nextstrain_metadata <- sapply(nextstrain_metadata$strain, function(x) grep(paste0(x, '(@|[|])'), rownames(all_dcr), value = T))

duplicates <- matches_nextstrain_metadata[which(sapply(matches_nextstrain_metadata, function(x) length(x))>1)]
rm_secs <- vector()
for(i in 1:length(duplicates)){
      names_length <- sapply(duplicates[[i]], function(x) nchar(x))
      rm_secs <- c(rm_secs, duplicates[[i]][which.min(names_length)])
}

#######
# DCR all
all_dcr_pruned <- all_dcr[-which(rownames(all_dcr) %in% rm_secs), ]
write.dna(all_dcr_pruned, file = 'all_dcr_pruned.fasta', format = 'fasta', nbcol = -1, colsep = '')

#######
# 2018 DCR nextstrain
nextstrain_names <- vector()
for(i in 1:nrow(nextstrain_metadata)){
      nextstrain_names <- c(nextstrain_names,
      		       grep(nextstrain_metadata$strain[i], rownames(all_dcr_pruned)))
}
# check that this doesn't include any of the public data 


nextstrain_names <- unique(nextstrain_names)
nextstrain_seqs <- all_dcr_pruned[nextstrain_names, ]
write.dna(nextstrain_seqs, file = 'nextstrain_2018_DCR.fasta', format = 'fasta', nbcol = -1, colsep = '')

#####
# 2018 DCR public
all_public_unaligned <- read.dna('GenomicFastaResults.fasta', format = 'fasta')
accns_all_public <- gsub('gb:|[|].+', '', names(all_public_unaligned))


#no_nextstrain <- all_dcr_pruned[-nextstrain_names, ]
#no_nextstrain_dates <- gsub('@.+', '', rownames(no_nextstrain))
#no_nextstrain[

