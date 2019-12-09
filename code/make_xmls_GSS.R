

make_xml <- function(dna_data, template, outname, randomise.dates = F, ultra = F){
  dna_data <- as.character(dna_data)
  if(ultra){
    taxon_block <- paste0(paste0('<taxon id=\"', rownames(dna_data), '\">\n</taxon>'), collapse = '\n')
  }else{		
    dates <- gsub('.+@', '', rownames(dna_data))
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

template_strict_dates <- readLines('GSS_template_strict_dates.xml')
template_ucld_dates <- readLines('GSS_template_ucld_dates.xml')
template_strict_ultra <- readLines('GSS_template_strict_ultra.xml')
template_ucld_ultra <- readLines('GSS_template_ucld_ultra.xml')

#Example to run this code

#make_xml(seq_data, template_strict_dates, output)
dir("../ebola_fasta_files/")
input_files<-paste0("../ebola_fasta_files/", c("ebola_2018Public.fasta","ebola_early2014.fasta","ebola_liberia.fasta")) 
input_data<-read.dna(input_files[1],format="fasta")
source("make_xmls_GSS.R")
input_files
library(ape)
input_data<-read.dna(input_files[1],format="fasta")
make_xml(input_data,template_strict_dates,'ebola_2018Public_sc_het')
make_xml(input_data,template_strict_ultra,'ebola_2018Public_sc_iso')
make_xml(input_data,template_ucld_dates,'ebola_2018Public_ucld_het')
make_xml(input_data,template_ucld_ultra,'ebola_2018Public_ucld_iso')