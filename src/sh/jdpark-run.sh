#!/bin/bash

# bash jdpark-run.sh tmp/jdj-option-bwa.txt out/spades-bwa/scaffolds.fasta

if [ $# -eq 0 ]; then
  echo "bash x.sh <JDJ OPTION> <FASTA FILE>"
  exit
fi

JDJOPTION=$1
FASTA=$2

cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
perl src/pl/ExSeedsJava.pl $JDJOPTION $FASTA log




echo "perl src/pl/ExSeedsJava.pl $JDJOPTION $FASTA log" | mail -s "job is finished" goshng@gmail.com



