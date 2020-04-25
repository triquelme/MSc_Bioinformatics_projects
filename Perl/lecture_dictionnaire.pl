%t=(ala=>A,cys=>C);
$t{met}=M;

while (($cle,$val)=each(%t)){
    print "cle: $cle, valeur: $val\n";
}

for $cle (keys(%t)) {
    print "cle: $cle, valeur: $t{$cle}\n";
}

@l=keys(%t);
print "@l\n";

@li=values(%t);
print "@li\n"
