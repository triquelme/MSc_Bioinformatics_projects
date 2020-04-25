#!/usr/bin/perl
use warnings;
use strict;
use Encode;
use utf8;
use DBI;
use lib "/net/cremi/triquelme/DBD-XBase-1.06/lib";	    

#connexion

my $dbp = DBI->connect("DBI:Pg:dbname=triquelme;host=dbserver","triquelme","", {"RaiseError" => 1});

# Requête qui affiche le nom des régions

my $regions = $dbp->prepare("select nom_reg from france.regions order by nom_reg") 
or die $dbp->errstr();
$regions->execute() or die $regions->errstr();
my @NR;
while (my $ref = $regions->fetchrow_hashref()) {
  push(@NR,$ref->{'nom_reg'});
}

# Requête 1: Nom des chef-lieux par région
my $req1= $dbp->prepare("select nom_communes from france.regions, france.communes
where france.regions.code_chef = france.communes.code_communes order by nom_reg")
or die $dbp->errstr();
$req1->execute() or die $req1->errstr();
my @REQ1;
while (my $ref = $req1->fetchrow_hashref()) {
  push(@REQ1,$ref->{'nom_communes'});
}

# Requête 2: Nombre de communes par région
my $req2= $dbp->prepare("select count(nom_communes) as nombre_de_communes from france.regions, france.communes
where france.regions.code_reg = france.communes.code_region
group by nom_reg order by nom_reg") or die $dbp->errstr();
$req2->execute() or die $req2->errstr();
my @REQ2;
while (my $ref = $req2->fetchrow_hashref()) {
  push(@REQ2,$ref->{'nombre_de_communes'});
}

# Requête 3: Nb et % de chaque type de commerce par rapport à la région
my $req3= $dbp->prepare("select sum(hypermarche) as hypermarche, sum(cast(hypermarche as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_hypermarche,

sum(supermarche) as supermarche, sum(cast(supermarche as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_supermarche,

sum(grande_surface_bricolage) as grande_surface_bricolage, sum(cast(grande_surface_bricolage as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_grande_surface_bricolage,

sum(superette) as superette, sum(cast(superette as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_superette,

sum(epicerie) as epicerie, sum(cast(epicerie as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_epicerie,

sum(boulangerie) as boulangerie, sum(cast(boulangerie as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_boulangerie,

sum(boucherie_charcuterie) as boucherie_charcuterie, sum(cast(boucherie_charcuterie as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_boucherie_charcuterie,

sum(produits_surgel) as produits_surgel, sum(cast(produits_surgel as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_produits_surgel,

sum(poissonnerie) as poissonnerie, sum(cast(poissonnerie as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_poissonnerie,

sum(librairie) as librairie, sum(cast(librairie as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_librairie,

sum(magasin_vetements) as magasin_vetements, sum(cast(magasin_vetements as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_magasin_vetements,

sum(magasin_equipements_foyer) as magasin_equipements_foyer, sum(cast(magasin_equipements_foyer as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_magasin_equipements_foyer,

sum(magasin_chaussures) as magasin_chaussures, sum(cast(magasin_chaussures as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_magasin_chaussures,

sum(magasin_electromenager) as magasin_electromenager, sum(cast(magasin_electromenager as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_magasin_electromenager,

sum(magasin_meubles) as magasin_meubles, sum(cast(magasin_meubles as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_magasin_meubles,

sum(magasin_sports) as magasin_sports, sum(cast(magasin_sports as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_magasin_sports,

sum(magasin_revetements) as magasin_revetements, sum(cast(magasin_revetements as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_magasin_revetements,

sum(droguerie) as droguerie, sum(cast(droguerie as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_droguerie,

sum(parfumerie) as parfumerie, sum(cast(parfumerie as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_parfumerie,

sum(bijouterie) as bijouterie, sum(cast(bijouterie as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_bijouterie,

sum(fleuriste) as fleuriste, sum(cast(fleuriste as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_fleuriste,

sum(magasin_optique) as magasin_optique, sum(cast(magasin_optique as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_magasin_optique,

sum(station_service) as station_service, sum(cast(station_service as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service)) as pourcentage_station_service

from france.regions, france.communes
where france.regions.code_reg = france.communes.code_region
group by nom_reg order by nom_reg") or die $dbp->errstr();
$req3->execute() or die $req3->errstr();
my @REQ3a; my @REQ3b; my @REQ3c; my @REQ3d;my @REQ3e;my @REQ3f;my @REQ3g;my @REQ3h;my @REQ3i;my @REQ3j;my @REQ3k;my @REQ3l;my @REQ3m;my @REQ3n;my @REQ3o;my @REQ3p;my @REQ3q;my @REQ3r;my @REQ3s;my @REQ3t;my @REQ3u;my @REQ3v;my @REQ3w;my @REQ3aa; my @REQ3bb; my @REQ3cc; my @REQ3dd;my @REQ3ee;my @REQ3ff;my @REQ3gg;my @REQ3hh;my @REQ3ii;my @REQ3jj;my @REQ3kk;my @REQ3ll;my @REQ3mm;my @REQ3nn;my @REQ3oo;my @REQ3pp;my @REQ3qq;my @REQ3rr;my @REQ3ss;my @REQ3tt;my @REQ3uu;my @REQ3vv;my @REQ3ww;
while (my $ref = $req3->fetchrow_hashref()) {
    push(@REQ3a,$ref->{'hypermarche'});
    push(@REQ3b,$ref->{'supermarche'});
    push(@REQ3c,$ref->{'grande_surface_bricolage'});
    push(@REQ3d,$ref->{'superette'});
    push(@REQ3e,$ref->{'epicerie'});
    push(@REQ3f,$ref->{'boulangerie'});
    push(@REQ3g,$ref->{'boucherie_charcuterie'});
    push(@REQ3h,$ref->{'produits_surgel'});
    push(@REQ3i,$ref->{'poissonnerie'});
    push(@REQ3j,$ref->{'librairie'});
    push(@REQ3k,$ref->{'magasin_vetements'});
    push(@REQ3l,$ref->{'magasin_equipements_foyer'});
    push(@REQ3m,$ref->{'magasin_chaussures'});
    push(@REQ3n,$ref->{'magasin_electromenager'});
    push(@REQ3o,$ref->{'magasin_meubles'});
    push(@REQ3p,$ref->{'magasin_sports'});
    push(@REQ3q,$ref->{'magasin_revetements'});
    push(@REQ3r,$ref->{'droguerie'});
    push(@REQ3s,$ref->{'parfumerie'});
    push(@REQ3t,$ref->{'bijouterie'});
    push(@REQ3u,$ref->{'fleuriste'});
    push(@REQ3v,$ref->{'magasin_optique'});
    push(@REQ3w,$ref->{'station_service'});
    push(@REQ3aa,$ref->{'pourcentage_hypermarche'});
    push(@REQ3bb,$ref->{'pourcentage_supermarche'});
    push(@REQ3cc,$ref->{'pourcentage_grande_surface_bricolage'});
    push(@REQ3dd,$ref->{'pourcentage_superette'});
    push(@REQ3ee,$ref->{'pourcentage_epicerie'});
    push(@REQ3ff,$ref->{'pourcentage_boulangerie'});
    push(@REQ3gg,$ref->{'pourcentage_boucherie_charcuterie'});
    push(@REQ3hh,$ref->{'pourcentage_produits_surgel'});
    push(@REQ3ii,$ref->{'pourcentage_poissonnerie'});
    push(@REQ3jj,$ref->{'pourcentage_librairie'});
    push(@REQ3kk,$ref->{'pourcentage_magasin_vetements'});
    push(@REQ3ll,$ref->{'pourcentage_magasin_equipements_foyer'});
    push(@REQ3mm,$ref->{'pourcentage_magasin_chaussures'});
    push(@REQ3nn,$ref->{'pourcentage_magasin_electromenager'});
    push(@REQ3oo,$ref->{'pourcentage_magasin_meubles'});
    push(@REQ3pp,$ref->{'pourcentage_magasin_sports'});
    push(@REQ3qq,$ref->{'pourcentage_magasin_revetements'});
    push(@REQ3rr,$ref->{'pourcentage_droguerie'});
    push(@REQ3ss,$ref->{'pourcentage_parfumerie'});
    push(@REQ3tt,$ref->{'pourcentage_bijouterie'});
    push(@REQ3uu,$ref->{'pourcentage_fleuriste'});
    push(@REQ3vv,$ref->{'pourcentage_magasin_optique'});
    push(@REQ3ww,$ref->{'pourcentage_station_service'});
}

# Home page: region.html

open (FRA, ">regions.html");
print FRA "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>
<html xmlns='http://www.w3.org/199/xhtml' xml:lang='fr'>
<head>
	<meta http-equiv='Content-Type' content='text/html'; charset='ISO-8859-1'>
	<title>Partie générale - REGIONS </title>
</head>

<body>
	<center>
		<h1>Régions de France</h1>
		<table border='1'>
<th>Noms des régions</th>
<th>Chef-Lieu</th>
<th>Nombre de communes</th>
<th>Nombre d'hypermarchés</th>
<th>Pourcentage d'hypermarchés</th>
<th>Nombre de supermarchés</th>
<th>Pourcentage de supermarchés</th>
<th>Nombre de magasins de bricolage</th>
<th>Pourcentage de magasins de bricolage</th>
<th>Nombre de superettes</th>
<th>Pourcentage de superettes</th>
<th>Nombre d'épiceries</th>
<th>Pourcentage d'épiceries</th>
<th>Nombre de boulangeries</th>
<th>Pourcentage de boulangeries</th>
<th>Nombre de boucherie charcuterie</th>
<th>Pourcentage de boucherie charcuterie</th>
<th>Nombre de produits_surgelés</th>
<th>Pourcentage de produits_surgelés</th>
<th>Nombre de poissonneries</th>
<th>Pourcentage de poissonneries</th>
<th>Nombre de librairies</th>
<th>Pourcentage de librairies</th>
<th>Nombre de magasins de vêtements</th>
<th>Pourcentage de magasins de vêtements</th>
<th>Nombre de magasins d'équipements foyer</th>
<th>Pourcentage de magasins d'équipements foyer</th>
<th>Nombre de magasins de chaussures</th>
<th>Pourcentage de magasins de chaussures</th>
<th>Nombre de magasins electromenager</th>
<th>Pourcentage de magasins electromenager</th>
<th>Nombre de magasins meubles</th>
<th>Pourcentage de magasins meubles</th>
<th>Nombre de magasins de sport</th>
<th>Pourcentage de magasins de sport</th>
<th>Nombre de magasins de revêtement</th>
<th>Pourcentage de magasins de revêtement</th>
<th>Nombre de drogueries</th>
<th>Pourcentage de drogueries</th>
<th>Nombre de parfumeries</th>
<th>Pourcentage de parfumeries</th>
<th>Nombre de bijouteries</th>
<th>Pourcentage de bijouteries</th>
<th>Nombre de fleuristes</th>
<th>Pourcentage de fleuristes</th>
<th>Nombre de magasin_optique</th>
<th>Pourcentage de magasin_optique</th>
<th>Nombre de station_service</th>
<th>Pourcentage de station_service</th>
";

for ( my $i = 0 ; $i < ($#NR +1) ; $i++){
    print FRA "<tr>
<td align='center'> <a href=\"$NR[$i].html\"> $NR[$i] </a></td>";
    open (REG,">$NR[$i].html");
    print REG "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>
<html xmlns='http://www.w3.org/199/xhtml' xml:lang='fr'>
<head>
	<meta http-equiv='Content-Type' content='text/html'; charset='ISO-8859-1'>
	<title> Région $NR[$i] </title>
</head>

<body>
	<center>
		<h1>Région $NR[$i]</h1>
		<table border='1'>
<th>Noms des départements</th>
<th>Chef-Lieu</th>
<th>Nombre de communes</th>
<th>Nombre d'hypermarchés</th>
<th>Pourcentage d'hypermarchés</th>
<th>Nombre de supermarchés</th>
<th>Pourcentage de supermarchés</th>
<th>Nombre de magasins de bricolage</th>
<th>Pourcentage de magasins de bricolage</th>
<th>Nombre de superettes</th>
<th>Pourcentage de superettes</th>
<th>Nombre d'épiceries</th>
<th>Pourcentage d'épiceries</th>
<th>Nombre de boulangeries</th>
<th>Pourcentage de boulangeries</th>
<th>Nombre de boucherie charcuterie</th>
<th>Pourcentage de boucherie charcuterie</th>
<th>Nombre de produits_surgelés</th>
<th>Pourcentage de produits_surgelés</th>
<th>Nombre de poissonneries</th>
<th>Pourcentage de poissonneries</th>
<th>Nombre de librairies</th>
<th>Pourcentage de librairies</th>
<th>Nombre de magasins de vêtements</th>
<th>Pourcentage de magasins de vêtements</th>
<th>Nombre de magasins d'équipements foyer</th>
<th>Pourcentage de magasins d'équipements foyer</th>
<th>Nombre de magasins de chaussures</th>
<th>Pourcentage de magasins de chaussures</th>
<th>Nombre de magasins electromenager</th>
<th>Pourcentage de magasins electromenager</th>
<th>Nombre de magasins meubles</th>
<th>Pourcentage de magasins meubles</th>
<th>Nombre de magasins de sport</th>
<th>Pourcentage de magasins de sport</th>
<th>Nombre de magasins de revêtement</th>
<th>Pourcentage de magasins de revêtement</th>
<th>Nombre de drogueries</th>
<th>Pourcentage de drogueries</th>
<th>Nombre de parfumeries</th>
<th>Pourcentage de parfumeries</th>
<th>Nombre de bijouteries</th>
<th>Pourcentage de bijouteries</th>
<th>Nombre de fleuristes</th>
<th>Pourcentage de fleuristes</th>
<th>Nombre de magasin_optique</th>
<th>Pourcentage de magasin_optique</th>
<th>Nombre de station_service</th>
<th>Pourcentage de station_service</th>
";
    # Requête qui affiche le nom des départements

my $regions = $dbp->prepare("select nom_dept from france.regions, france.departements where nom_reg='$NR[$i]' and france.regions.code_reg = france.departements.code_reg") 
or die $dbp->errstr();
$regions->execute() or die $regions->errstr();
my @ND;
while (my $ref = $regions->fetchrow_hashref()) {
  push(@ND,$ref->{'nom_dept'});
}    
    for ( my $i = 0 ; $i < ($#ND +1) ; $i++){

 # Requête 4 Nom des chef-lieux par département
my $req4= $dbp->prepare("select nom_communes from france.departements, france.communes 
where nom_dept='$ND[$i]' and france.departements.code_chef = france.communes.code_communes order by nom_dept")
or die $dbp->errstr();
$req4->execute() or die $req4->errstr();
my $chef = $req4->fetchrow_array;

# Requête 5 Nombre de communes par département
my $req5= $dbp->prepare("select count(nom_communes) from france.departements, france.communes
where nom_dept='$ND[$i]' and france.departements.code_dep = france.communes.code_dept
group by nom_dept") or die $dbp->errstr();
$req5->execute() or die $req5->errstr();
my $nbc = $req5->fetchrow_array;

print REG "<tr>
<td align='center'> <a> $ND[$i] </a></td>
<td align='center'>$chef</td>
<td align='center'>$nbc</td>";

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

# Requête 6: Nb et % de chaque type de commerce par rapport au nombre total de commerce du département

for ( my $j = 0 ; $j < ($#commerce +1) ; $j++){

my $req6= $dbp->prepare("select sum($commerce[$j]), sum(cast($commerce[$j] as float))*100 / (sum(hypermarche)+ sum(supermarche)+ sum(grande_surface_bricolage)+ 
sum(superette)+ sum(epicerie)+ sum(boulangerie)+ sum(boucherie_charcuterie)+ sum(produits_surgel)+ sum(poissonnerie)+ sum(librairie)+ sum(magasin_vetements)+
sum( magasin_equipements_foyer)+ sum(magasin_chaussures)+ sum(magasin_electromenager)+ sum(magasin_meubles)+ sum(magasin_sports)+ sum(magasin_revetements)+ sum(droguerie)+ sum(parfumerie)+ 
sum(bijouterie)+ sum(fleuriste)+ sum(magasin_optique)+ sum(station_service))
from france.departements, france.communes
where nom_dept='$ND[$i]' and france.departements.code_dep = france.communes.code_dept
group by nom_dept") or die $dbp->errstr();
$req6->execute() or die $req6->errstr();
my ($nb,$per) = $req6->fetchrow_array;

	print REG "
<td align='center'>$nb</td>
<td align='center'>$per</td>";
}
print REG "
</tr>";}
print REG "</table>
	</center>
</body>
</html>";

close REG;

    print FRA "
<td align='center'>$REQ1[$i]</td>
<td align='center'>$REQ2[$i]</td>
<td align='center'>$REQ3a[$i]</td>
<td align='center'>$REQ3aa[$i]</td>
<td align='center'>$REQ3b[$i]</td>
<td align='center'>$REQ3bb[$i]</td>
<td align='center'>$REQ3c[$i]</td>
<td align='center'>$REQ3cc[$i]</td>
<td align='center'>$REQ3d[$i]</td>
<td align='center'>$REQ3dd[$i]</td>
<td align='center'>$REQ3e[$i]</td>
<td align='center'>$REQ3ee[$i]</td>
<td align='center'>$REQ3f[$i]</td>
<td align='center'>$REQ3ff[$i]</td>
<td align='center'>$REQ3g[$i]</td>
<td align='center'>$REQ3gg[$i]</td>
<td align='center'>$REQ3h[$i]</td>
<td align='center'>$REQ3hh[$i]</td>
<td align='center'>$REQ3i[$i]</td>
<td align='center'>$REQ3ii[$i]</td>
<td align='center'>$REQ3j[$i]</td>
<td align='center'>$REQ3jj[$i]</td>
<td align='center'>$REQ3k[$i]</td>
<td align='center'>$REQ3kk[$i]</td>
<td align='center'>$REQ3l[$i]</td>
<td align='center'>$REQ3ll[$i]</td>
<td align='center'>$REQ3m[$i]</td>
<td align='center'>$REQ3mm[$i]</td>
<td align='center'>$REQ3n[$i]</td>
<td align='center'>$REQ3nn[$i]</td>
<td align='center'>$REQ3o[$i]</td>
<td align='center'>$REQ3oo[$i]</td>
<td align='center'>$REQ3p[$i]</td>
<td align='center'>$REQ3pp[$i]</td>
<td align='center'>$REQ3q[$i]</td>
<td align='center'>$REQ3qq[$i]</td>
<td align='center'>$REQ3r[$i]</td>
<td align='center'>$REQ3rr[$i]</td>
<td align='center'>$REQ3s[$i]</td>
<td align='center'>$REQ3ss[$i]</td>
<td align='center'>$REQ3t[$i]</td>
<td align='center'>$REQ3tt[$i]</td>
<td align='center'>$REQ3u[$i]</td>
<td align='center'>$REQ3uu[$i]</td>
<td align='center'>$REQ3v[$i]</td>
<td align='center'>$REQ3vv[$i]</td>
<td align='center'>$REQ3w[$i]</td>
<td align='center'>$REQ3ww[$i]</td>
    </tr>";}

print FRA "</table>
	</center>
</body>
</html>";

close FRA;

