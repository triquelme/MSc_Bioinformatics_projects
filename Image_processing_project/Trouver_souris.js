/********************************************************************************************************************
* Trouver dans quelle zone est la souris et affichage des zones où elle se trouve le plus avec un gradient de couleur
* Thomas RIQUELME 
* 06/04/2016
*********************************************************************************************************************/

// 1- On récupère les positions x,y et la slice z dans le tableau xls ouvert dans ImageJ

var results = ResultsTable.getResultsTable();  
var xvalues = results.getColumn(results.getColumnIndex("X"));
var yvalues = results.getColumn(results.getColumnIndex("Y"));
var zvalues = results.getColumn(results.getColumnIndex("Slice"));

// 2- Initialisation des variables

var A1 = 0; // compteur du nombre de fois que la position de la souris s'est trouvé dans la zone A1
var A2 = 0;
var A3 = 0;
var B1 = 0;
var B2 = 0;
var B3 = 0;
var C1 = 0;
var C2 = 0;
var C3 = 0;

// 3- Test de l'appartenance de la position x,y de la souris a une zone donnée

for (var i=1; i < zvalues.length; i++) {
	
	if ((0 < xvalues[i] && xvalues[i] < 155) && (0 < yvalues[i] && yvalues[i]< 160)) { A1 +=1 ;}

	else if ((0 < xvalues[i] && xvalues[i] < 155) && (160 < yvalues[i] && yvalues[i]< 320)) { A2 +=1 ;}

	else if ((0 < xvalues[i] && xvalues[i] < 155) && (320 < yvalues[i] && yvalues[i]< 480)) { A3 +=1 ;}

	else if ((155 < xvalues[i] && xvalues[i] < 310) && (0 < yvalues[i] && yvalues[i] < 160)) { B1 +=1 ;}

	else if ((155 < xvalues[i] && xvalues[i] < 310) && (160 < yvalues[i] && yvalues[i] < 320)) { B2 +=1 ;}

	else if ((155 < xvalues[i] && xvalues[i] < 310) && (320 < yvalues[i] && yvalues[i] < 480)) { B3 +=1 ;}

	else if ((310 < xvalues[i] && xvalues[i] < 465) && (0 < yvalues[i] && yvalues[i] < 160)) { C1 +=1 ;}

	else if ((310 < xvalues[i] && xvalues[i] < 465) && (160< yvalues[i] && yvalues[i] < 320)) { C2 +=1 ;}

	else if ((310 < xvalues[i] && xvalues[i] < 465) && (320< yvalues[i] && yvalues[i]< 480)) { C3 +=1 ;}
}

// 4- Affichage du nombre d'apparitions de la souris dans chaque zone pendant la minute étudiée et stockage des résultats dans une liste appelée 'zone'

IJ.log("Nombre d'apparitions dans A1 :" + A1);
IJ.log("Nombre d'apparitions dans A2 :" + A2);
IJ.log("Nombre d'apparitions dans A3 :" + A3);
IJ.log("Nombre d'apparitions dans B1 :" + B1);
IJ.log("Nombre d'apparitions dans B2 :" + B2);
IJ.log("Nombre d'apparitions dans B3 :" + B3);
IJ.log("Nombre d'apparitions dans C1 :" + C1);
IJ.log("Nombre d'apparitions dans C2 :" + C2);
IJ.log("Nombre d'apparitions dans C3 :" + C3);

var zone = [A1,A2,A3,B1,B2,B3,C1,C2,C3] // liste des résultats pour chaque zone pour pouvoir ensuite tester toutes les zones dans une boucle

// 6- Enregistrement des coordonnées de chaque zone dans une liste appelée 'coor' pour pouvoir ensuite colorier la zone correspondant à ces coordonnées

var coor = [    // liste des coordonnées de chaque zone 
[1,1,154,159],  // coordonnées zone A1 (les 2 premiers chiffres sont respectivement les valeurs en abscisse et en ordonnée du coin supérieur gauche du rectangle, le troisième est la largeur du rectangle et le quatrième la hauteur)
[1,161,154,159],// coordonnées zone A2 (etc dans le meme ordre que la liste des zones)
[1,321,154,159],
[156,1,154,159],
[156,161,154,159],
[156,321,154,159],
[311,1,154,159],
[311,161,154,159],
[311,321,154,159]
];

// 7- On récupère l'image template d'une grille vide ouverte dans ImageJ et on la stocke dans la variable imp

var imp = IJ.getImage(); 

// 8- Convertion de l'image imp en RGB color afin de pouvoir y afficher les couleurs

IJ.run(imp, "RGB Color", ""); 

// 9- Test du score de chaque zone et coloriage en conséquence de la zone sur l'image template en suivant un gradient de couleur du jaune au violet 

for (var i=0; i < zone.length ; i++) { // boucle qui parcourt toutes les zones

	if (zone[i] < 30) { yellow (coor[i][0],coor[i][1],coor[i][2],coor[i][3]) } //si la valeur du compteur i d'une zone est inférieure à 30 la fonction yellow va colorier en jaune la région correspondant aux coordonnées de la zone i

	else if (zone[i] > 30 && zone[i] <100) { orange (coor[i][0],coor[i][1],coor[i][2],coor[i][3]) }

	else if (zone[i] > 100 && zone[i] <150) { red (coor[i][0],coor[i][1],coor[i][2],coor[i][3]) }

	else { purple (coor[i][0],coor[i][1],coor[i][2],coor[i][3]) }

}

// 10- Fonctions de coloriage

function yellow(a,b,c,d){
	var roi = Roi(a,b,c,d) // crée une variable roi qui stocke une région d'intérêt Roi ('Region of interest') qui prend les valeurs a,b,c,d 
	IJ.setForegroundColor ( 255, 195, 0 ); // définit la couleur de l'avant plan comme 'jaune'
	imp.getProcessor().fill(roi); // remplit la région d'intérêt en jaune sur l'image template
}

function orange(a,b,c,d){
	var roi = Roi(a,b,c,d)
	IJ.setForegroundColor ( 255, 87, 51 ); 
	imp.getProcessor().fill(roi);
}

function red(a,b,c,d){
	var roi = Roi(a,b,c,d)
	IJ.setForegroundColor ( 199, 0, 57 ); 
	imp.getProcessor().fill(roi);
}

function purple(a,b,c,d){
	var roi = Roi(a,b,c,d)
	IJ.setForegroundColor ( 144, 12, 63 ); 
	imp.getProcessor().fill(roi);
}
