open(COC,"cocci.txt");
while(<COC>){
    chomp;
    @tab=split(' ',$_);
}
close (COC);

%t;

for $x (@tab){
    $cpt=1;
    if(exists($t($x))){
	cpt+=1;
    }
    $t{"$x"}=$cpt
}

while(($cle,$val)=each(%t)){
    print "$val : $cle \n";
}
