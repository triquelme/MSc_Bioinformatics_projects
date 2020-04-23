open (KIN, "kinases_map.txt");

while(<KIN>){
    chomp;
    @ligne=split('\|',$_);
    if ($ligne[4]<600000){
	$t{$ligne[4]}=$ligne[0];
    }
}

close (KIN);

while(($cle,$val)=each(%t)){
    print "$cle, $val\n";
}


