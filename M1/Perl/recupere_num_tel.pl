#!/usr/bin/perl

use warnings;

open (TEL,"tel.txt");
while(<TEL>){
    chomp;
    @elem=split(" ",$_);
    push(@tab,@elem);
}
close (TEL);

for $x (@tab){
    if ($x=~ /^[+]*(\d+)-(\d+)-(\d+)-(\d+)-(\d+)/){
	print "$x";
	print "\n";
    }
}

 
