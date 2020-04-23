#!/usr/bin/perl
use warnings;
use strict;
use Encode;
use utf8;
use DBI;
use lib "/net/cremi/triquelme/DBD-XBase-1.06/lib";	    

my $dbp = DBI->connect("DBI:Pg:dbname=triquelme;host=dbserver","triquelme","", {"RaiseError" => 1});
my $dbx = DBI->connect("DBI:XBase:.") or die $DBI::errstr;


# Creation table departements

print "Creation de la table Departements\n";
my $sql_creation_table_departements ="
CREATE TABLE france.departements  (
  code_reg	       INT	       NOT NULL ,
  code_dep             VARCHAR( 10 )   NOT NULL ,
  code_chef	       VARCHAR( 6 )    NOT NULL ,
  nom_dept	       VARCHAR( 100 )  NOT NULL ,
  PRIMARY KEY ( code_dep )
);";

my $sth = $dbp->prepare($sql_creation_table_departements);
my $num = $sth->execute();



print " creation table departements reussie \n";

# Insertion des donnees dans la table departements

print "insertion des donnees dans la table departements\n";
my $sth1 = $dbx->prepare("select code_reg ,code_dep,code_chef,nom_dept from depts2015") or die $dbp->errstr();
print "2\n";
$sth1->execute() or die $sth1->errstr();
print "3\n";

while (my @data1 = $sth1->fetchrow_array()) {
    $data1[3] =~ tr/\'/ /;
    my $sql_insert_departement = "INSERT INTO france.departements VALUES ($data1[0], '$data1[1]', '$data1[2]', '$data1[3]');";
    print "$sql_insert_departement \n";
    my $sth = $dbp->prepare($sql_insert_departement);
    my $num = $sth->execute();
}
print "4\n";

$sth->finish;

# Deconnection de la base de données

$dbp->disconnect();

