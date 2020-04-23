#!/usr/bin/perl
use warnings;
use strict;
use Encode;
use utf8;
use DBI;
use lib "/net/cremi/triquelme/DBD-XBase-1.06/lib";	    

#connexion

my $dbp = DBI->connect("DBI:Pg:dbname=triquelme;host=dbserver","triquelme","", {"RaiseError" => 1});

my $entite;
my $nom;

open (COM, "entite_nom.txt");
while(<COM>){
    chomp;
    my @elem = split(":",$_);
    $entite= $elem[0];
    $nom= $elem[1];
}
close COM;

print "$entite \n";
print "$nom \n";

#test type entite (region, departement, commune) => selon le type d'entité creation de tableau avec caracteristiques specifiques
#exemple pour commune:

if ($entite eq "commune") {
    print "ok \n";
    open (COP, ">$nom.html");
print COP "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>
<html xmlns='http://www.w3.org/199/xhtml' xml:lang='fr'>
<head>
	<meta http-equiv='Content-Type' content='text/html'; charset='ISO-8859-1'>
	<title>Partie détaillée - $nom </title>
</head>

<body>
	<center>
		<h1>$nom</h1>
		<table border='1'>
<th>Région d'appartenance</th>
<th>Département d'appartenance</th>";

    # requete region d'appartenance
    my $req1= $dbp->prepare("select nom_reg from france.regions, france.communes 
where nom_communes='$nom' and france.regions.code_reg = france.communes.code_region")
or die $dbp->errstr();
$req1->execute() or die $req1->errstr();
    my $reg = $req1->fetchrow_array;
    
print COP "<tr>
<td align='center'>$reg</td>
</tr>
</table>
	</center>
</body>
</html>";
close COP;
}

