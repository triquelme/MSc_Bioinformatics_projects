#!/usr/bin/perl

use warnings;
use strict;

my $max;
my $res;
my $seq;
my $l;

my @small_seq;
my @medium_seq;
my @large_seq;

my @tab = qw(tcgtgccca tgtt cccga ttcatcag ggcaag ctg ggtgtaccggtgatcac ccaccta cctgaattat);

#trier les seq en fonction de leur taille

for $seq (@tab) {
    $l=length($seq);
    if ($l<6){
	push(@small_seq,$seq);
    }
    elsif ($l>=6 and $l<=10){
	push(@medium_seq,$seq);
    }
    else {
	push(@large_seq,$seq);
    }
}

print "small_seq: @small_seq\n";
print "medium_seq: @medium_seq\n";
print "large_seq: @large_seq\n";	

# trouver le plus long oligo

$max=0;
$res="";
for $seq (@tab) {
    $l=length($seq);
    if ($l>$max) {
	$max=$l; #stock la longueur de l'oligonucleotide dans $max
	$res=$seq; #stock l'oligonucleotide dans $res
    }
}

print "la plus grande chaine est: $res\n";
