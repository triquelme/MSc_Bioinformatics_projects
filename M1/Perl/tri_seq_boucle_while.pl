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
my $in;

open ($in, "oligo.txt");

#trier les seq en fonction de leur taille

while (<$in>){
    chomp;
    $l=length($_); #$_ prend le contenu d'une ligne du fichier texte
    if ($l<6){
	push(@small_seq,$_);
    }
    elsif ($l>=6 and $l<=10){
	push(@medium_seq,$_);
    }
    else {
	push(@large_seq,$_);
    }
}

close ($in);

print "small_seq: @small_seq\n";
print "medium_seq: @medium_seq\n";
print "large_seq: @large_seq\n";	

# trouver le plus long oligo

$max=0;
$res="";

open ($in, "oligo.txt");

while (<$in>) {
    chomp;
    $l=length($_);
    if ($l>$max) {
	$max=$l; #stock la longueur de l'oligonucleotide dans $max
	$res=$_; #stock l'oligonucleotide dans $res
    }
}

close ($in);

print "la plus grande chaine est: $res\n";


