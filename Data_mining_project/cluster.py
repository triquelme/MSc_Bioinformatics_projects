# coding: utf-8

#Initialisation d'un dictionnaire 'Familles_Proteines' qui aura comme clés le nom des familles de protéines
#et comme valeurs associées le nom des protéines dans chaque famille
Familles_Proteines={}

#Ouverture du fichier de données 
fic = open("data","r")

#Parcours des lignes du fichier de données
for ligne in fic:
	#parcours a partir de la ligne 2 pour ne pas prendre en compte la premiere ligne d'entete des colonnes
	if ligne > 1: 
		#séparation des lignes en valeur par colonne
		colonne = ligne.split("\t") 
		#suppression du saut de ligne dans la dernière colonne
		colonne[len(colonne)-1] = colonne[len(colonne)-1].rstrip() 
		#récuperation du nom de la protéine contenu dans la colonne 2 du tableau de données et stockage dans une variable 'proteine_nom1'
		proteine_nom1 = colonne[1] 
		#vérification que la dernière colonne du tableau de données contenant le nom de la famille de la proteine n'est pas vide
		if colonne[len(colonne)-1] != '':
			#récuperation du nom de la famille de la protéine contenu dans la dernière colonne du tableau de données et stockage dans une variable 'proteine_famille1'
			proteine_famille1 = colonne[len(colonne)-1] 
		#vérification que le nom de la famille de la protéine se trouve dans le dictionnaire
		if proteine_famille1 not in Familles_Proteines:
			#si le nom de la famille de la protéine n'est pas encore dans le dictionnaire, il est ajouté comme clé au dictionnaire et le nom de la proteine lui est associé comme première valeur au sein d'une liste qui pourra contenir d'autres noms
			Familles_Proteines[proteine_famille1]=[proteine_nom1]			
		else:
			#sinon, si le nom de la famille de la protéine existe deja comme clé dans le dictionnaire, le nom de la proteine est ajoute a la liste des noms de proteines associée à cette clé
			Familles_Proteines[proteine_famille1].append(proteine_nom1)	
			
#Fermeture du fichier de données à la fin de son parcours		
fic.close()

#affichage du dictionnaire pour vérifier son contenu
print Familles_Proteines




