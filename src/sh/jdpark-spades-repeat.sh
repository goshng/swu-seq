#!/bin/bash

# bash x.sh BLASTDB.file 4 9 500000 1000

if [ $# -eq 0 ]; then
  echo "bash x.sh <BLASTDB> <START> <END> <LENGTH> <CONTIG LENGTH>"
  exit
fi

BLASTDB=$1
START=$2
END=$3
LENGTH=$4
CLENGTH=$5

for ((I=START;I<=END;I++)); do

J=$((I+1))

# Determine the number of FASTA sequences by the length.
NSCAFFOLDS=$(bioawk -c fastx '{ print $name, length($seq) }' < out/spades-bwa-jdj$I/scaffolds.fasta | wc -l)

for ((i=1;i<=NSCAFFOLDS;i++)); do
  TOTALLENGTH=$(bioawk -c fastx '{ print $name, length($seq) }' < out/spades-bwa-jdj$I/scaffolds.fasta | cut -f 2 | head -n $i | awk '{s+=$1} END {print s}')

  CONTIGLENGTH=$(bioawk -c fastx '{ print $name, length($seq) }' < out/spades-bwa-jdj$I/scaffolds.fasta | cut -f 2 | head -n $i | tail -n 1)

  if [ "$CONTIGLENGTH" -lt "$CLENGTH" ]; then
    break
  fi

  if [ "$TOTALLENGTH" -gt "$LENGTH" ]; then
    break
  fi
done


# Create a sub FASTA file by the limit of length.

bash src/sh/filter-fasta-by-totallength.sh out/spades-bwa-jdj$I/scaffolds.fasta $TOTALLENGTH > out/spades-bwa-jdj$I/scaffolds-$TOTALLENGTH.fasta



CORRECTEDTOTALLENGTH=$(bioawk -c fastx '{ print $name, length($seq) }' < out/spades-bwa-jdj$I/scaffolds-$TOTALLENGTH.fasta | cut -f 2 | awk '{s+=$1} END {print s}')

mv out/spades-bwa-jdj$I/scaffolds-$TOTALLENGTH.fasta out/spades-bwa-jdj$I/scaffolds-$CORRECTEDTOTALLENGTH.fasta

TOTALLENGTH=$CORRECTEDTOTALLENGTH

# Create JDJ's option file.
echo Length_Seed=101                 > tmp/jdj-option-spades$I.txt
echo DB_Name=out/$BLASTDB.blastdb      >> tmp/jdj-option-spades$I.txt
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

bash src/sh/jdpark-run.sh tmp/jdj-option-spades$I.txt out/spades-bwa-jdj$I/scaffolds-$TOTALLENGTH.fasta

# REPEAT: NOW
# Grep read IDs of the JDJ run.

bash src/sh/grep-read-id.sh out/jdj-spades$I out/jdj-spades$I.txt
grep "^891" out/jdj-spades$I.txt | cut -c4- | tr -d " " > out/${BLASTDB}_1.id; dos2unix out/${BLASTDB}_1.id
grep "^892" out/jdj-spades$I.txt | cut -c4- | tr -d " " > out/${BLASTDB}_2.id; dos2unix out/${BLASTDB}_2.id
cat out/$BLASTDB-spades$I.txt out/${BLASTDB}_1.id out/${BLASTDB}_2.id | sort -n | uniq > out/$BLASTDB-spades$J.txt
perl src/pl/grep-fq-by-id.pl out/$BLASTDB-spades$J.txt data/${BLASTDB}_1.fq > out/${BLASTDB}_1-spades$J.fq
perl src/pl/grep-fq-by-id.pl out/$BLASTDB-spades$J.txt data/${BLASTDB}_2.fq > out/${BLASTDB}_2-spades$J.fq
# Assemble the bwa-filtered read data set.
bash src/sh/spades-paired-end.sh out/${BLASTDB}_1-spades$J.fq out/${BLASTDB}_2-spades$J.fq out/spades-bwa-jdj$J

done