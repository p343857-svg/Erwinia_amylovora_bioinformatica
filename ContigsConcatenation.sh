#Auto pega contig (Zilia)
for f in *.fasta
do
gene=$(echo $f | sed 's'/.fasta//)
perl ContigsConcatenation.pl $f $gene'.join.fasta' $gene
done
