#!/usr/bin/perl
use warnings;
use strict;
use Encode;
use utf8;
use DBI;
use lib "/net/cremi/triquelme/DBD-XBase-1.06/lib";
use Spreadsheet::ParseExcel;	    

my $dbp = DBI->connect("DBI:Pg:dbname=triquelme;host=dbserver","triquelme","", {"RaiseError" => 1});

# Creation de la table commune

print "Creation de la table communes\n";
my $sql_creation_table_communes ="
CREATE TABLE france.communes (
  code_communes	                        VARCHAR( 6 )	  NOT NULL ,
  nom_communes          	        VARCHAR( 100 )    NOT NULL ,
  code_dept                             VARCHAR( 10 )     NOT NULL ,
  code_region	                        INT     	  ,  
  code_region2016                       INT               ,  
  hypermarche	                        INT 	          ,
  supermarche	                        INT 	          ,
  grande_surface_bricolage	        INT 	          ,
  superette	                        INT 	          ,
  epicerie	                        INT 	          ,
  boulangerie	                        INT 	          ,
  boucherie_charcuterie	                INT 	          ,
  produits_surgel	                INT 	          ,
  poissonnerie	                        INT 	          ,
  librairie	                        INT 	          ,
  magasin_vetements	                INT 	          ,
  magasin_equipements_foyer	        INT 	          ,
  magasin_chaussures	                INT 	          ,
  magasin_electromenager	        INT 	          ,
  magasin_meubles	                INT 	          ,
  magasin_sports                 	INT 	          ,
  magasin_revetements	                INT 	          ,
  droguerie                     	INT 	          ,
  parfumerie	                        INT 	          ,
  bijouterie     	                INT 	          ,
  fleuriste	                        INT 	          ,
  magasin_optique	                INT 	          ,
  station_service                       INT 	          ,
  PRIMARY KEY ( code_communes )
  );";

my $sth = $dbp->prepare($sql_creation_table_communes);
my $num = $sth->execute();
print "check\n";

# Insertion des donnees dans la table communes
print "insertion des donnees dans la table commune\n";
my $parser = Spreadsheet::ParseExcel->new();
print "etape 1\n";
my $workbook = $parser->parse('equip-serv-commerce-com-2014.xls');
if ( !defined $workbook ) {die $parser->error(), ".\n";}

my $worksheet;

print "etape 2\n";
foreach ( $workbook->worksheets() ) {
	$worksheet = $_;
	last if $_->get_name() eq 'COM';
}
my ( $row_min, $row_max ) = $worksheet->row_range();
my ( $col_min, $col_max ) = $worksheet->col_range();

print "etape 3\n";
my $res="";
for my $row ( 6 .. $row_max ) {
	$res=$res."INSERT INTO france.communes VALUES(";
 	 
	for my $col ( $col_min..$col_max) {
		my $cell = $worksheet->get_cell( $row, $col );
		if ($cell && $col!=$col_min){
	  	  $res=$res.",";
		}
		next unless $cell;
		$res = $res."'";
		$res=$res.quote($cell->value());
		$res=$res."'";
    	}
    	$res=$res.");\n";
}
print "etape 4\n";

utf8::upgrade($res);
$dbp->do($res);

sub quote{
    my $donne=shift;
    $donne=~s/\'/\ /g;
    return $donne;
}

print "etape 5\n";

$sth->finish;
$dbp->disconnect();
