# coding: utf-8

#Initialisation d'un dictionnaire 'Familles_Proteines' qui aura comme clés le nom des familles de protéines
#et comme valeurs associées le nom des protéines dans chaque famille
Familles_Proteines={}

nb_lignes = 0

fic = open("data","r")

for ligne in fic:
	
	nb_lignes += 1
	
	if nb_lignes > 1 and nb_lignes < 500: 
	
		colonne = ligne.split("\t") 
	
		colonne[len(colonne)-1] = colonne[len(colonne)-1].rstrip() 
	
		proteine_nom1 = colonne[1] 
	
		if colonne[len(colonne)-1] != '':
	
			proteine_famille1 = colonne[len(colonne)-1] 
	
		if proteine_famille1 not in Familles_Proteines:
	
			Familles_Proteines[proteine_famille1]=[proteine_nom1]			
		else:
	
			Familles_Proteines[proteine_famille1].append(proteine_nom1)	
			
fic.close()

#print Familles_Proteines
#print "\n"
#print Familles_Proteines.keys()

#for key, value in Familles_Proteines.iteritems():
#	print key, value

for i in Familles_Proteines.keys():
	for j in Familles_Proteines[i]:
		print j


res = open("resultat_familles.txt", "w")

res.write("Famille\tProtéine\tRelation\n")

for i in Familles_Proteines.keys():
		res.write("Cluster général\t" + i + "\tgénérale\n")

for i in Familles_Proteines.keys():
	for j in Familles_Proteines[i]:
		 res.write(i + "\t" + j + "\tfamiliale\n" )

res.close()

	
"""
for i in range (len(criteres)):
	if (taux[i]>50):
		res.write(criteres[i])
		res.write(" = ")
		res.write(str(taux[i]))
		res.write("%")
		res.write("\n")
res.close()

"""
