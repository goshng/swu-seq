#!/bin/bash

# bash src/sh/jdpark-manual.sh X0 MK_20G data/contig00-95-100.fa

if [ $# -eq 0 ]; then
  echo "bash x.sh <JDJ OPTION> <FASTA FILE>"
  exit
fi

I=$1
BLASTDB=$2
FASTA=$3

cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
# perl src/pl/ExSeedsJava.pl $JDJOPTION $FASTA log


# Create JDJ's option file.
echo Length_Seed=101                 > tmp/jdj-option-spades$I.txt
echo DB_Name=out/$BLASTDB.blastdb   >> tmp/jdj-option-spades$I.txt
echo Result_Path=out/jdj-spades$I/  >> tmp/jdj-option-spades$I.txt
echo Raw_Read_Length=101            >> tmp/jdj-option-spades$I.txt
echo Direction_Extension=Both       >> tmp/jdj-option-spades$I.txt
echo Min_Similarity=95              >> tmp/jdj-option-spades$I.txt
echo Min_Length=95                  >> tmp/jdj-option-spades$I.txt
echo Max_Match=1000                 >> tmp/jdj-option-spades$I.txt
echo No_Threads=4                   >> tmp/jdj-option-spades$I.txt
echo Dust=On                        >> tmp/jdj-option-spades$I.txt
echo Number_iteration=2000          >> tmp/jdj-option-spades$I.txt
echo Removal_Duplicates=On          >> tmp/jdj-option-spades$I.txt
echo Max_Match_Iteration=1000       >> tmp/jdj-option-spades$I.txt
echo Min_Match_Iteration=3          >> tmp/jdj-option-spades$I.txt
echo Min_Similarity_Iteration=90    >> tmp/jdj-option-spades$I.txt
echo Min_Length_Iteration=80        >> tmp/jdj-option-spades$I.txt
echo Max_Length_Iteration=95        >> tmp/jdj-option-spades$I.txt
echo Min_Similarity_Cluster=97      >> tmp/jdj-option-spades$I.txt
echo Min_Length_Cluster=90          >> tmp/jdj-option-spades$I.txt
echo Min_Reads_Cluster=3            >> tmp/jdj-option-spades$I.txt
echo Min_Residues_Consensus=2       >> tmp/jdj-option-spades$I.txt
echo Majority_Residues_Consensus=80 >> tmp/jdj-option-spades$I.txt

bash src/sh/jdpark-run.sh tmp/jdj-option-spades$I.txt $FASTA

echo "perl src/pl/ExSeedsJava.pl $JDJOPTION $FASTA log" | mail -s "job is finished" goshng@gmail.com



