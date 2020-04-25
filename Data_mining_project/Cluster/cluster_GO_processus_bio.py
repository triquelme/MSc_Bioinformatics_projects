# coding: utf-8

#Initialisation d'un dictionnaire 'Familles_Proteines' qui aura comme clés le nom des familles de protéines
#et comme valeurs associées le nom des protéines dans chaque famille
GO_processus_biologiques={}

nb_lignes = 0

#Ouverture du fichier de données 
fic = open("data","r")

for ligne in fic:	

	nb_lignes += 1

	if nb_lignes > 1 and nb_lignes < 500: 

		colonne = ligne.split("\t") 
	
		proteine_nom1 = colonne[1] 
		
		if colonne[32] != '':
			processus = colonne[32]
			liste_processus = processus.split(";")

		for processus in liste_processus:	
			if processus not in GO_processus_biologiques:
				GO_processus_biologiques[processus]=[proteine_nom1]			
			else:
				GO_processus_biologiques[processus].append(proteine_nom1)	

			
#Fermeture du fichier de données à la fin de son parcours		
fic.close()

#affichage du dictionnaire pour vérifier son contenu

#print GO_processus_biologiques

res = open("resultat_GO.txt", "w")

res.write("Processus biologique\tProtéine\tRelation\n")

nb_GO = 0
for i in GO_processus_biologiques.keys():
	nb_GO += 1
	if nb_GO < 100:
		res.write("Cluster général\t" + i + "\tgénérale\n")
nb_GO =0
for i in GO_processus_biologiques.keys():
	nb_GO +=1
	if nb_GO < 100:
		for j in GO_processus_biologiques[i]:
			res.write(i + "\t" + j + "\trôle biologique\n" )

res.close()
