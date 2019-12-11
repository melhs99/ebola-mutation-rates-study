library(ape)

complete_tree <- read.tree('pruned2018-2019-BioNJ_tree.tree')

subtree1 <- read.nexus('subtree_1.tree')
subtree1$tip.label <- gsub('\'', '', subtree1$tip.label)
write.tree(subtree1, file = 'subtree_1.newick.tree')
remainder_tree <- drop.tip(complete_tree, subtree1$tip.label)
write.tree(remainder_tree, file = 'remainder_tree1.tree')

subtree2 <- read.nexus('subtree2')
subtree2$tip.label <- gsub('\'', '', subtree2$tip.label)
write.tree(subtree2, file = 'subtree_2.newick.tree')

subtree3 <- drop.tip(remainder_tree, subtree2$tip.label)
write.tree(subtree3, file = 'subtree_3.newick.tree')