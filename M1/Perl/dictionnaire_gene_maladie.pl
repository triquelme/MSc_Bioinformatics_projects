%t=(AD4 => "Alzheimer's Disease", BRCA1 => Breast Cancer, DMD => Duchenne Muscular Dystrophy, FMR1 => Fragile X Syndrome, GBA => "Gaucher's Disease");

while (($cle,$val)=each(%t)){
    print "cle: $cle, valeur: $val\n";
}
