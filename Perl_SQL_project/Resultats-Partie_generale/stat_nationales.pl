#!/usr/bin/perl
use warnings;
use strict;
use Encode;
use utf8;
use DBI;
use lib "/net/cremi/triquelme/DBD-XBase-1.06/lib";	    

#connexion

my $dbp = DBI->connect("DBI:Pg:dbname=triquelme;host=dbserver","triquelme","", {"RaiseError" => 1});

# Variable Type de commerce

my @commerce=("hypermarche",
  "supermarche",
  "grande_surface_bricolage",
  "superette",	          
  "epicerie",	          
  "boulangerie",	          
  "boucherie_charcuterie",	      
  "produits_surgel",	      
  "poissonnerie",	              
  "librairie",	              
  "magasin_vetements",	      
  "magasin_equipements_foyer",
  "magasin_chaussures",	   
  "magasin_electromenager",
  "magasin_meubles",	 
  "magasin_sports",         
  "magasin_revetements",	 
  "droguerie",              
  "parfumerie",	         
  "bijouterie",     	 
  "fleuriste",	         
  "magasin_optique",
  "station_service");     

# statistiques_nationales.html

open (STA, ">statistiques_nationales.html");
print STA "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>
<html xmlns='http://www.w3.org/199/xhtml' xml:lang='fr'>
<head>
	<meta http-equiv='Content-Type' content='text/html'; charset='ISO-8859-1'>
	<title>Statistiques Nationales</title>
</head>

<body>
	<center>
		<h1>Statistiques Nationales</h1>
		<table border='1'>
<th>Type de commerce</th>
<th>Region qui en comporte le plus</th>
<th>Region qui en comporte le moins</th>
";


for ( my $i = 0 ; $i < ($#commerce +1) ; $i++){
    # Requête qui en a le plus
my $req1= $dbp->prepare("select nom_reg,sum($commerce[$i]) 
from france.regions, france.communes
where france.regions.code_reg = france.communes.code_region 
group by nom_reg order by sum($commerce[$i]) desc limit 1")
    or die $dbp->errstr();
$req1->execute() or die $req1->errstr();
my ($nom,$nb) = $req1->fetchrow_array;

    # Requête qui en a le moins
my $req2= $dbp->prepare("select nom_reg,sum($commerce[$i]) 
from france.regions, france.communes
where france.regions.code_reg = france.communes.code_region 
group by nom_reg order by sum($commerce[$i]) limit 1")
    or die $dbp->errstr();
$req2->execute() or die $req2->errstr();
my ($nom2,$nb2) = $req2->fetchrow_array;

    
    print STA "<tr>
<td align='center'>$commerce[$i]</td>
<td align='center'>$nom($nb)</td>
<td align='center'>$nom2($nb2)</td>

</tr>";}

print STA "</table>
	</center>
</body>
</html>";

close STA;
