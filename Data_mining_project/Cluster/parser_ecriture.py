#Liste des criteres choisis
criteres=["Entry","Entry_name","Status","Protein_names","Gene_names","Organism","Length","Mass_spectrometry","Mass","Sequence","Sequence_uncertainty","EC_number","Absorption","Catalytic_activity","Cofactor","Enzyme_regulation","Kinetics","Pathway","Redox_potential","Temperature_dependence","pH_dependence","Active_site","Binding_site","Calcium_binding","DNA_binding","Metal_binding","Nucleotide_binding","Site","Annotation","Interacts_with","Tissue_specificity","Induction","Gene_ontology(biological_process)","Gene_ontology(molecular_function)","Gene_ontology(cellular_component)","Allergenic_properties","Involvement_in_disease","Intramembrane","Transmembrane","Topological_domain","3D","Beta_strand","Helix","Turn","Sequence_similarities","Protein_families"]

#Initialisation d'un compteur pour compter les iterations de chaque critere
cpt=[]


for i in range(len(criteres)):
    cpt.append(0.0)

#Calcul du nombre de cases remplies pour chaque critere

nb_lignes = 0.0 # creation d'un compteur nb_ligne pour compter le nombre de ligne en parcourant le fichier (necessaire pour le calcul du taux de remplissage a l'etape suivante)

fic = open("data.csv", "r") #ouverture du fichier 'data'

for ligne in fic: #parcours des lignes du fichier
	
	nb_lignes += 1

	values = ligne.split("\t") #separe les lignes de textes a chaque tabulation

	values[len(values)-1] = values[len(values)-1].rstrip() #pour supprimer le retour a la ligne a la fin de la ligne (concerne la derniere colonne)

	#print values[len(values)-1]

	for i in range (len(values)):
		if values[i] != '':
			cpt[i]+=1

fic.close()

#Calcul du taux de remplissage pour chaque critere

taux=[]
for i in range(len(cpt)):
    taux.append(0.0)
for i in range(len(cpt)):   
	taux[i]= (cpt[i]/ nb_lignes)*100

	
#Affichage des resultats

res = open("pourcentages", "w")
for i in range (len(criteres)):
	if (taux[i]>50):
		res.write(criteres[i])
		res.write(" = ")
		res.write(str(taux[i]))
		res.write("%")
		res.write("\n")
res.close()











