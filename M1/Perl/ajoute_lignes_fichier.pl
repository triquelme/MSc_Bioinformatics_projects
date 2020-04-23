#!/usr/bin/perl

use warnings;

open(SOURCE,"oligo.txt");
$cpt=0;
@tab;

while(<SOURCE>){
    chomp;
    $cpt+=1;
    $elem= $cpt." ".$_;
    push(@tab,$elem);
}

close(SOURCE);

open (RESULT, ">result_file.txt");

for $x (@tab) {
    print RESULT $x;
}

close (RESULT);
