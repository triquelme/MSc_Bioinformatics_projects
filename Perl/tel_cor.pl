#!/usr/bin/perl

use warnings;
use strict;

open (TEL,"tel.txt");
my @tab;
my @elem;

while(<TEL>){
    chomp;
    @elem=split(" ",$_);
    push(@tab,@elem);
}
close (TEL);

my $el;
    
for $el (@tab){
    if ($el=~ /[+] \d{2} ([-]\d{2}){4}/){
	print $el, "\n";
    }
    if ($el =~ / \d{2}([-]\d{2}){4} /) {
	print $el, "\n";
    }
}
