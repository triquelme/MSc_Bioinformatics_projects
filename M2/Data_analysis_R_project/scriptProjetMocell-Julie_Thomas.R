setwd('/autofs/netapp/account/cremi/triquelme/MOCELL/PROJET-MOCELL')
"Lecture des profils d'expression génique dans les différentes expériences"
data=read.table("P_EXPR.txt",header=T)
data
class(data)

# Lecture de la liste des gènes d’intérêt et chargement dans un vecteur
focus<-read.table("P_GOI.txt", header=TRUE)
list_focus <-as.vector(focus[,"id"])
list_focus

# Filtrage des données d’expression correspondant aux gènes d'intérêt
filter_list <- data[,"id"] %in% list_focus
filter_list
data_focus<-data[filter_list,]
data_focus

# Nécessaire de décaler la première colonne pour récupérer les labels des lignes
rownames(data_focus)

# Les labels que l'on souhaite sont dans la première colonne
data_focus[,1]
rownames(data_focus)=data_focus[,1]
data_focus
data_focus=data_focus[,-1]
data_focus

# La fonction t() permet d'inverser les colonnes et lignes - nécessaire pour pouvoir
#calculer les corrélation entre les gènes qui au départ correspondent aux lignes-
data_focus=t(data_focus)
data_focus

# calculer la corrélation entre toutes les colonnes d'une matrice
#(nécessaires de donner en paramètres une dataframe)
result_correlation=cor(data_focus)
result_correlation

#Utiliser la fonction melt pour convertir une matrice en liste d'interaction
library("reshape2", lib.loc="/autofs/netapp/account/cremi/triquelme/R/x86_64-pc-linux-gnu-library/3.2")
list_correlation=melt(result_correlation)
list_correlation

#On sélectionne uniquement les correlations dont la valeur est supérieur à 0.75
list_correlation=list_correlation[abs(list_correlation["value"])>0.75,]

#Il est nécessaire de supprimer les paires redondantes (on est partie d'une matrice symétrique)
#Création d'une nouvelle colonne Alphabétique pour stipuler si le nome du gene A est ordonné
#selon l'aphabet par rapport au nom du gene B
list_correlation["Alphabétique"]<-as.character(list_correlation[,"Var1"])<as.character(list_correlation[,"Var2"])
list_correlation

#Supression des lignes où l'ordre de classement entre les deux noms de gènes ne suit par
#l'ordre alphabétique (permet de supprimer les doublons)
list_correlation=list_correlation[list_correlation[,4]==TRUE,]
list_correlation

#Supression de la colonne transitoire alphabétique - n'est plus nécessaire-
list_correlation=list_correlation[,-4]

#Supression de la colonne Value
list_correlation=list_correlation[,-3]

#Ajout de la colonne Interaction pour donner le type, ici ce sont les paires dont
#l'expression est corrélée.
list_correlation["type"]="correlation_pair"
list_correlation

#Lecture de la tables d'interactions Protéine-Proteine de ces gènes
data_PPI=read.table("P_PPI.txt",header=T,sep='\t')
data_PPI

# Filtrage des données PPI correspondant aux gènes d'intérêt
#Premier filtrage sur les gènes de la colonne 'id1'
filter_PPI_id1 <- data_PPI[,"id1"] %in% list_focus
filter_PPI_id1
data_PPI_focus<-data_PPI[filter_PPI_id1,]
data_PPI_focus

#Deuxième filtrage sur les gènes de la colonne 'id2'
filter_PPI_id2 <- data_PPI_focus[,"id2"] %in% list_focus
filter_PPI_id2
data_PPI_focus2<-data_PPI_focus[filter_PPI_id2,]
data_PPI_focus2

#Changement du nom des deux premières colonnes pour qu'elles correspondent dans les deux
#listes
colnames(list_correlation)[1]="id1"
colnames(list_correlation)[2]="id2"
list_correlation

colnames(data_PPI_focus2)[3]="type"
data_PPI_focus2

#Extraction des noms de gènes de la liste de co-expression pour les utiliser comme filtre
#sur les PPI (on ne s'intéresse pas aux PPI des gènes pour lesquelles pas de données
#d'expression)
#id1<-as.vector(list_correlation[,"id1"])
#id2<-as.vector(list_correlation[,"id2"])

#list_net_genes <- c(id1,id2)
#list_net_genes <- unique(list_net_genes)
#list_net_genes

#Fusion des deux listes pour créer un nouveau data frame et le sauvegarder dans un fichier
LISTE=rbind(list_correlation,data_PPI_focus2)
LISTE

write.table (LISTE,"LISTE_projet_MOCELL.txt", sep="\t",row.names=FALSE,quote=F)

#write.table (list_correlation,"list_correlation_projet_MOCELL.txt", sep="\t",row.names=FALSE,quote=F)
#write.table (data_PPI_focus2,"data_PPI_focus2_projet_MOCELL.txt", sep="\t",row.names=FALSE,quote=F)








