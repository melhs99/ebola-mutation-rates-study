
library(NELSI)
library(phangorn)

nsims <- 10
evol_rate <- 0.005
tag <- 'ultra_rel2'
ultra <- F
relaxed_clock <- T
sdrate <- 2

#dna_data <- seq_data
#outname = 'test'
#randomise.dates = F
#ultra = F
#template <- template_strict_dates
#seq_data <- read.dna(paste0('fasta_files/', temp_name), format = 'fasta')
make_xml <- function(dna_data, template, outname, randomise.dates = F, ultra = F){
  dna_data <- as.character(dna_data)
  if(ultra){
    taxon_block <- paste0(paste0('<taxon id=\"', rownames(dna_data), '\">\n</taxon>'), collapse = '\n')
  }else{		
    dates <- gsub('.+_', '', rownames(dna_data))
    if(randomise.dates) dates <- sample(dates)
    taxon_block <- paste0(paste0('<taxon id=\"', rownames(dna_data), '\">\n<date value=\"', dates, '\" direction=\"forwards\" units=\"years\"/>\n</taxon>'),
  	      	 		       collapse = '\n')
  }
  aln_block <- paste0(sapply(1:nrow(dna_data), function(x) paste0('<sequence>\n<taxon idref=\"', rownames(dna_data)[x], '\"/>\n',
	     paste0(dna_data[x, ], collapse = ''), '\n</sequence>')), collapse = '')

  replace_text <- c(TAXON_BLOCK=taxon_block, ALN_BLOCK=aln_block, OUT_FILE=outname)
  for(tex in 1:length(replace_text)){
    template <- gsub(names(replace_text)[tex], replace_text[tex], template)
  }
  writeLines(template, con = paste0(outname, '.xml'))
}

template_strict_dates <- readLines('gss_rep2/GSS_template_strict_dates.xml')
template_ucld_dates <- readLines('gss_rep2/GSS_template_ucld_dates.xml')
template_strict_ultra <- readLines('gss_rep2/GSS_template_strict_ultra.xml')
template_ucld_ultra <- readLines('gss_rep2/GSS_template_ucld_ultra.xml')

#fasta_files <- dir('fasta_files_lowrate', pattern = 'fasta')
fasta_files <- dir('replicate_fasta_files_lowrate', pattern = 'fasta')
for(i in 1:length(fasta_files)){
  temp_name <- fasta_files[i]
  print(temp_name)
  seq_data <- read.dna(paste0('replicate_fasta_files_lowrate/', temp_name), format = 'fasta')
  out_name <- gsub('[.]fasta', '', temp_name)
  #
  make_xml(seq_data, template_strict_dates, paste0('GSS_strict_dates_', out_name))
  make_xml(seq_data, template_ucld_dates, paste0('GSS_ucld_dates_', out_name))
  make_xml(seq_data, template_strict_ultra, paste0('GSS_strict_ultra_', out_name), ultra = T)
  make_xml(seq_data, template_ucld_ultra, paste0('GSS_ucld_ultra_', out_name), ultra = T)
  make_xml(seq_data, template_strict_dates, paste0('GSS_strict_random_', out_name), randomise.dates = T)
  make_xml(seq_data, template_ucld_dates, paste0('GSS_ucld_random_', out_name), randomise.dates = T)
}










stop('w')
make_xml <- function(dna_data, template, outname, randomise.dates = F){
    dna_data <- as.character(dna_data)
    dates <- gsub('.+_', '', rownames(dna_data))
    if(randomise.dates){
        dates <- sample(dates)
	outname <- paste0(outname, '_random')
    }

    date_block <- paste(paste0(rownames(dna_data), '=', dates), collapse = ',')
    seq_data <- sapply(1:nrow(dna_data), function(x) paste(dna_data[x, ], collapse = ''))
    seq_block <-  paste0(paste0('<sequence id=\"seq_',
                                rownames(dna_data), '\" taxon=\"',
                                rownames(dna_data), '\" totalcount=\"4\" value=\"',
                                seq_data,'\"/>'), collapse = '\n')
    replace_text <- c(SEQ_DATA = seq_block, DATE_DATA=date_block, OUT_FILE=outname)
    for(i in 1:length(replace_text)){
        template <- gsub(names(replace_text)[i], replace_text[i], template)
    }
    writeLines(template, paste0(outname, '.xml'))
}


for(nsim in 1:nsims){
    if(ultra){
        system('/Applications/phylo_apps/BEAST250/bin/beast BD_ultra_anyN.xml')
        tr <- read.tree('BD_ultra_tree.newick.tree')
        dates <- runif(n = length(tr$tip.label), min = 0, max = max(allnode.times(tr, keeproot = T)))
    }else{
        system('/Applications/phylo_apps/BEAST250/bin/beast BD_sim_temp.xml')
        tr <- read.tree('BD_tree.newick.tree')
        dates <- round(allnode.times(tr, tipsonly = T, reverse = T, keeproot = T), 2)
    }
    tr$tip.label <- paste0('A', '_', tr$tip.label, '_', dates)
#plot(ladderize(tr), root.edge = T, show.tip.label = T)
    phylogram <- tr
    if(relaxed_clock){
	phylogram$edge.length <- phylogram$edge.length * rlnorm(length(phylogram$edge.length),
			      meanlog = log(evol_rate), sdlog = sdrate)
    }else{
	phylogram$edge.length <- phylogram$edge.length * evol_rate
    }
    gamma_rates <- phangorn::discrete.gamma(1, 4)
    temp_list <- list()
    for(i in 1:length(gamma_rates)){
        temp_list[[i]] <- as.DNAbin(simSeq(phylogram, l = 1000, rate = gamma_rates[i]))
    }
    sim_data <- cbind(temp_list[[1]], temp_list[[2]], temp_list[[3]], temp_list[[4]])
#    write.dna(sim_data, file = paste0(tag, '_ultra_sim_', nsim, '.fasta'), format = 'fasta', nbcol = -1, colsep = '')
    #
    template_dates <- readLines('with_dates_template.xml')
    outname_dates <- paste0(tag, '_dates_sim_', nsim)
    make_xml(sim_data, template_dates, outname_dates)
    make_xml(sim_data, template_dates, outname_dates, randomise.dates = T)
    #
    template_ultra <- readLines('no_dates_template.xml')
    outname_ultra <- paste0(tag, '_ultra_sim_', nsim)
    make_xml(sim_data, template_ultra, outname_ultra)
    #
    template_dates_ucld <- readLines('with_dates_template_ucld.xml')
    outname_dates_ucld <- paste0(tag, '_datesucld_sim_', nsim)
    make_xml(sim_data, template_dates_ucld, outname_dates_ucld)
    make_xml(sim_data, template_dates_ucld, outname_dates_ucld, randomise.dates = T)
    #
    template_ultra_ucld <- readLines('no_dates_template_ucld.xml')
    outname_ultra_ucld <- paste0(tag, '_ultraucld_sim_', nsim)
    make_xml(sim_data, template_ultra_ucld, outname_ultra_ucld)
}
