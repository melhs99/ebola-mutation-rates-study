library(NELSI)

trees <- dir(pattern = 'RA.+bestTree.+T1_.+fasta$')

lsd_cmd <- '/Applications/phylo_apps/lsd-0.3beta-master/bin/lsd_mac -i INTREE -d INDATE -f 100 -c -s 1000 -r a'

get_lsd_rate <- function(tr_file, get.p = T, lsd_cmd){
	     tr <- read.tree(tr_file)
	     date_file <- paste0(tr_file, '.date')
	     make.lsd.dates(tr, grep.sep = '.+@', outfile = date_file, random = F)
	     true_cmd <- gsub('INDATE', date_file, gsub('INTREE', tr_file, lsd_cmd))
	     system(true_cmd)
	     true_lines <- grep('^rate', readLines(paste0(tr_file, '.result')), value = T)
	     true_rate <- strsplit(true_lines, ' ')[[1]][c(2, 3, 5)]
	     if(get.p){
		random_rates <- vector()
		for(i in 1:100){
		      make.lsd.dates(tr, grep.sep = '.+@', outfile = paste0(date_file, '.random'), random = T)
	      	      random_cmd <- gsub('INDATE', paste0(date_file, '.random'), gsub('INTREE', tr_file, lsd_cmd))
	     	      system(random_cmd)
	     	      random_lines <- grep('^rate', readLines(paste0(tr_file, '.result')), value = T)
	     	      random_rates[i] <- strsplit(random_lines, ' ')[[1]][2]
		}
		return(list(true_rate, sum(as.numeric(true_rate[1]) > as.numeric(random_rates)), random_rates))
	     }else{
		return(true_rate)
	     }
}

t1 <- get_lsd_rate(trees[2], get.p = T, lsd_cmd = lsd_cmd)


