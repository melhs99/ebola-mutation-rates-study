
#install.packages('devtools')
#install_github('sebastianduchene/NELSI')

library(NELSI)

tr <- read.tree('RAxML_bestTree.test_subset1_ml')
make.lsd.dates(tr, grep.sep = '.+@', outfile = 'test_subset1_ml.date')


## lsd is the path to lsd in the /bin script:
#  -i is for the inpt tree file,
#  -d the date file created above with make.lsd.dates
#  -r is for optimising the root of the tree. Option 'a' means all root positions
#  -c is to constrain all branch lengths to be positive
#  -f is the number of parametetric bootstrap replicates to obtain uncertainty
#     in rates and dates
#  -s defines sequence length and anything above 1000 seems to give the same results.
# Remember to save the .result file that contains the rate and tmrca estimates.
##############
#lsd -i RAxML_bestTree.test_subset1_ml -d test_subset1_ml.date -r a -c -f 100 -s 1000
#https://github.com/tothuhien/lsd-0.3beta
