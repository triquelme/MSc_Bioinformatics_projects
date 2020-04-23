#!/usr/bin/perl
use warnings;
use strict;
use Encode;
use utf8;
use DBI;
use lib "/net/cremi/triquelme/DBD-XBase-1.06/lib";	    

my $dbp = DBI->connect("DBI:Pg:dbname=triquelme;host=dbserver","triquelme","", {"RaiseError" => 1});
my $dbx = DBI->connect("DBI:XBase:.") or die $DBI::errstr;

#Creation du schema france

$dbp->do('DROP SCHEMA IF EXISTS france CASCADE;') or die "Impossible de supprimer le schema\n\n";
print "Creation du schema\n";
my $sql_creation_schema="CREATE SCHEMA france ;";
my $sth = $dbp->prepare($sql_creation_schema);
my $num = $sth->execute();

# Creation de la table regions

print "Creation de la table regions\n";
my $sql_creation_table_regions ="
CREATE TABLE france.regions (
  code_reg            INT 	      NOT NULL ,
  code_chef           VARCHAR( 6 )    NOT NULL ,
  nom_reg	      VARCHAR( 100 )  NOT NULL ,
  
  PRIMARY KEY ( code_reg )
);";

$sth = $dbp->prepare($sql_creation_table_regions);
$num = $sth->execute();

print " creation table region reussie \n";

# Creation de la table regions2016

print "Creation de la table regions2016\n";
my $sql_creation_table_regions2016 ="
CREATE TABLE france.regions2016 (
  code_reg2           INT 	      NOT NULL ,
  code_chef2          VARCHAR( 6 )    NOT NULL ,
  nom_reg2	      VARCHAR( 100 )  NOT NULL ,
  
  PRIMARY KEY ( code_reg2 )
);";

$sth = $dbp->prepare($sql_creation_table_regions2016);
$num = $sth->execute();

print " creation table region2016 reussie \n";

# Insertion des donnees dans la table regions

print "insertion des donnees dans la table regions\n";
my $sth1 = $dbx->prepare("select code_reg ,code_chef,nom_reg from reg2015") or die $dbp->errstr();
print "2\n";
$sth1->execute() or die $sth1->errstr();
print "3\n";

while (my @data1 = $sth1->fetchrow_array()) {
    $data1[2] =~ tr/\'/ /;
    my $sql_insert_region = "INSERT INTO france.regions VALUES ($data1[0], '$data1[1]', '$data1[2]');";
    print "$sql_insert_region \n";
    my $sth = $dbp->prepare($sql_insert_region);
    my $num = $sth->execute();
}
print "4\n";

$sth1->finish();
$sth->finish();

# Insertion des donnees dans la table regions2016

print "insertion des donnees dans la table regions2016\n";
my $sth1 = $dbx->prepare("select code_reg2,code_chef2,nom_reg2 from reg2016") or die $dbp->errstr();
print "2\n";
$sth1->execute() or die $sth1->errstr();
print "3\n";

while (my @data1 = $sth1->fetchrow_array()) {
    $data1[2] =~ tr/\'/ /;
    my $sql_insert_region2016 = "INSERT INTO france.regions2016 VALUES ($data1[0], '$data1[1]', '$data1[2]');";
    print "$sql_insert_region2016 \n";
    my $sth = $dbp->prepare($sql_insert_region2016);
    my $num = $sth->execute();
}
print "4\n";

$sth1->finish();
$sth->finish();

# Deconnection de la base de données

$dbp->disconnect();
