# coding: utf-8

#Initialisation d'un dictionnaire 'Familles_Proteines' qui aura comme clés le nom des familles de protéines
#et comme valeurs associées le nom des protéines dans chaque famille
Familles_Proteines={}

# creation d'un compteur nb_ligne pour compter le nombre de ligne en parcourant le fichier
nb_lignes = 0

#Ouverture du fichier de données 
fic = open("data","r")

#Parcours des lignes du fichier de données
for ligne in fic:
	#on incrémente le compteur ligne de 1
	nb_lignes += 1

	#parcours a partir de la ligne 2 pour ne pas prendre en compte la premiere ligne d'entete des colonnes
	if nb_lignes > 1: 

#on split les lignes puis les colonnes
		#séparation des lignes en valeur par colonne
		colonne = ligne.split("\t") 
		#suppression du saut de ligne dans la dernière colonne
		colonne[len(colonne)-1] = colonne[len(colonne)-1].rstrip() 
		#récuperation du nom de la protéine contenu dans la colonne 2 du tableau de données et stockage dans une variable 'proteine_nom1'

#on enregistre le nom, la famille et l'organisme auquel appartient la proteine
		proteine_nom1 = colonne[0] 
		#vérification que la dernière colonne du tableau de données contenant le nom de la famille de la proteine n'est pas vide
		if colonne[len(colonne)-1] != '':
			#récuperation du nom de la famille de la protéine contenu dans la dernière colonne du tableau de données et stockage dans une variable 'proteine_famille1'
			proteine_famille1 = colonne[len(colonne)-1] 
		#vérification que le nom de la famille de la protéine se trouve dans le dictionnaire
		organisme1 = colonne[5]

#test et ajout dans le dictionnaire
		if proteine_famille1 not in Familles_Proteines:
			#si le nom de la famille de la protéine n'est pas encore dans le dictionnaire, il est ajouté comme clé au dictionnaire et le nom de la proteine lui est associé comme première valeur au sein d'une liste qui pourra contenir d'autres noms
			Familles_Proteines[proteine_famille1]={}
		if organisme1 not in Familles_Proteines[proteine_famille1]:
			Familles_Proteines[proteine_famille1][organisme1]=[proteine_nom1]
		elif organisme1 in Familles_Proteines[proteine_famille1]:
			Familles_Proteines[proteine_famille1][organisme1].append(proteine_nom1)
			
		

#Fermeture du fichier de données à la fin de son parcours		
fic.close()

#affichage du dictionnaire pour vérifier son contenu
print Familles_Proteines



