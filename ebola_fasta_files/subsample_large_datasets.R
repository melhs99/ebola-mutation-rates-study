library(ape)


par(mfrow = c(2, 1))
######### Sierra leone
sierra_leone <- read.dna('sierra_leone_testoutput.fasta', format = 'fasta')
dates <- as.numeric(gsub('.+@', '', rownames(sierra_leone)))
intervals <- c(2012, 2014.5, 2015, 2015.5, 2016)
select_sequences <- list()

for(i in 1:(length(intervals)-1)){
      seq_matches <- dates > intervals[i] & dates <= intervals[i+1]
      if(sum(seq_matches) < 200){
        select_sequences[[i]] <- rownames(sierra_leone)[seq_matches]
      }else{
	limit_dates <- rownames(sierra_leone)[seq_matches][c(which.min(dates[seq_matches]), which.max(dates[seq_matches]))]
	subsample <- sample(x = rownames(sierra_leone)[seq_matches][!rownames(sierra_leone)[seq_matches] %in% limit_dates], size = 198)	
	select_sequences[[i]] <- c(subsample, limit_dates)
      }
      write.dna(sierra_leone[select_sequences[[i]], ],
        file = paste0(intervals[i], '-', intervals[i+1], '_sierra_leone_max200.fasta'), format = 'fasta',
	nbcol = -1, colsep = '')
}

jittered <- rnorm(length(dates))
plot(dates, jittered)
for(i in intervals) lines(rep(i, 2), c(-4, 4), col = 'red')
points(dates[rownames(sierra_leone) %in% unlist(select_sequences)], jittered[rownames(sierra_leone) %in% unlist(select_sequences)], pch = 20, col = 'red') 

########## Large 2014
large2014 <- read.dna('2014_large_3.fasta', format = 'fasta')

dates <- as.numeric(gsub('.+@', '', rownames(large2014)))
intervals <- c(2012, 2014.5, 2015, 2015.5, 2016)
select_sequences <- list()

for(i in 1:(length(intervals)-1)){
      seq_matches <- dates > intervals[i] & dates <= intervals[i+1]
      if(sum(seq_matches) < 200){
        select_sequences[[i]] <- rownames(large2014)[seq_matches]
      }else{
	limit_dates <- rownames(large2014)[seq_matches][c(which.min(dates[seq_matches]), which.max(dates[seq_matches]))]
	subsample <- sample(x = rownames(large2014)[seq_matches][!rownames(large2014)[seq_matches] %in% limit_dates], size = 198)	
	select_sequences[[i]] <- c(subsample, limit_dates)
      }
      write.dna(large2014[select_sequences[[i]], ],
        file = paste0(intervals[i], '-', intervals[i+1], '_large2014_max200.fasta'), format = 'fasta',
	nbcol = -1, colsep = '')
}

jittered <- rnorm(length(dates))
plot(dates, jittered)
for(i in intervals) lines(rep(i, 2), c(-4, 4), col = 'red')
points(dates[rownames(large2014) %in% unlist(select_sequences)], jittered[rownames(large2014) %in% unlist(select_sequences)], pch = 20, col = 'red') 
