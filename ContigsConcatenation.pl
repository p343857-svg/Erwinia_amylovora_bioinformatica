#!/usr/bin/perl -w

################################################################################
#Este script concatena todas las secuencias existentes en un mismo archivo,
#eliminando los encabezados fasta de cada una de ellas
################################################################################


use strict; 

my $usage = "Usage: perl ContigsConcatenation.pl <ENTRADA.EXTENSION> <SALIDA.EXTENSION> <NOMBRE>\n";
unless(@ARGV) {
        print $usage;
        exit;
}

chomp @ARGV;
my $archivo =   $ARGV[0];
my $salida =    $ARGV[1];
my $nombre =    $ARGV[2];


unless (open (FILE, $archivo)) {
        print "El archivo $archivo pudo abrirse\n\nPrograma terminado!\n";
        exit;
}

open(OUT, ">$salida");
print OUT ">$nombre\n";
close OUT;

$/=">";       
      
my $FastaChar = <FILE>;
my @Contigs = <FILE>;
chomp @Contigs;
close FILE;     
     
$/="\n";

foreach my $Contig(@Contigs){
        (my $ContigHeader, my @SeqInLines) = split ('\n', $Contig);
        my $ContigSeq = join('',@SeqInLines);
        
        open(FILE, ">>$salida");
        print FILE $ContigSeq."X";
        close FILE;
}
