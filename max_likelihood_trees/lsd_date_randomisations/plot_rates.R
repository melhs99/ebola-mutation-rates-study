

dat <- read.table('rates_output_prelim.csv', head = T, sep = ',', stringsAsFactors = F)
dat[, 2:4] <- log10(dat[, 2:4])
dat[, 1] <- gsub('RAxML_bestTree.', '', dat[, 1])

ordered <- c(
"test_subset1_ml",
"subset2_tree", 
"subset3_tree",
"2012-2014.5_large2014_max200_tree",
"2014-2014.5_tree",
"2015.5-2016_tree", 
"early2014_T1",                         
"2012-2014.5_sierra_leone_max200_tree",
"Democratic_Republic_of_the_Congo_tree",
"guinea_tree",
"liberia_subset_tree",
"2018Public_T1",
"liberia_T1")


dat <- dat[match(ordered, dat[, 1]), ]

par(mar = c(6, 4, 4, 4))
plot(c(1, nrow(dat)), range(dat[, 3:4]), type = 'n', xaxt = 'n',
	  xlab = '', ylab = 'subst. rate (subs/site/year)')
axis(1, at = 1:nrow(dat), labels = dat[, 1], las = 2,
	cex.axis = 0.5)
for(i in 1:nrow(dat)){
      points(i, dat[i, 2], pch = 20)
      lines(rep(i, 2), dat[i, 3:4])
}

ranges <- c(log10(1e-5), log10(5e-5), log10(1e-4), log10(5e-4),
       log10(1e-3), log(5e-3))
       
for(i in ranges){
  lines(c(0, 20), rep(i, 2),  lty = 2)
}
axis(4, at = round(ranges, 2), labels = ranges, las = 2, cex.axis = 0.5)