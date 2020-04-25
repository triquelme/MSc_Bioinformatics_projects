open (HAM, "hamlet.xml");
%tacte;
%tscene;
%tpiece;
@listeNom;
while(<HAM>){
    chomp;
    if (/<PERSONA>/){
	$cptperso+=1;
    }
    if (/<ACT>/){
	%tacte={};
	$cptacte+=1;
	$cptsceneparacte=0;
	$cptpersoparacte=0;
	
    }
    if (/<SCENE>/){
	%tscene={};
	$cptscene+=1;
	$cptsceneparacte+=1;
	$cptpersoparscene=0;
    }
    if (/<\/ACT>/){
	print "\n Il y a $cptsceneparacte scenes dans l'acte $cptacte \n";
	print "Il y a $cptpersoparacte personnages dans l'acte $cptacte \n";
#	while(($cle,$val)=each(%tacte)){
#	    print "$cle, $val\n";
#	}
    }
    if (/<\/SCENE>/){
	print "Il y a $cptpersoparscene personnages dans l'acte $cptacte, scène $cptsceneparacte \n";
#	while(($cle,$val)=each(%tscene)){
#	    print "$cle, $val\n";
#	}
    }
    if (/<SPEAKER>(.*)<\/SPEAKER>/){
	if (exists($tacte{$1})){ #verifie si la clé $1 correspondant a la variable entre les balises SPEAKER existe dans la table %t (remarque: on l'appelle $t et pas %t car on verifie une seule occurence de la table, une seule cle
	    $tacte{$1}+=1;
	}
	else {
	    $tacte{$1}=1;
	    $cptpersoparacte+=1;
	}
	if (exists($tscene{$1})){
	    $tscene{$1}+=1;
	}
	else {
	    $tscene{$1}=1;
	    $cptpersoparscene+=1;
	}
	if (exists($tpiece{$1})){
	    $tpiece{$1}+=1;
	}
	else {
	    $tpiece{$1}=1;
	}
    }
    #Question 6
    if (/To be, or not to be: that is the question/){
	print "Hamlet prononce la réplique 'To be, or not to be : that is the question' dans l'acte $cptacte, scene $cptscene";
    }
} 

close (HAM);
print "Le nombre de personnages dans la pièce est de $cptperso \n";
print "Le nombre d'actes dans la pièce est de $cptacte \n";
print "Le nombre de scenes dans la pièce est de $cptscene \n";


#question 3)

print "\nNoms des personnages triés: \n\n";

for $cle(keys(%tpiece)){
    push(@listeNom,$cle);
}

@listeNomTriee= sort @listeNom;

for (@listeNomTriee){
    print "$_ \n";
}

#Question 4)

print "\nTable d'occurence de paroles pour chaque personnage: \n\n";

while(($cle,$val)=each(%tpiece)){
    print "$cle, $val\n";
}
    








