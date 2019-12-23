#!/bin/bash

subset_data=`ls *max200*`

for i in $subset_data; do
    echo $i
    /Applications/phylo_apps/standard-RAxML-master/raxmlHPC-PTHREADS-AVX -s $i -m GTRCAT -p 3424 -n T1_$i
done
