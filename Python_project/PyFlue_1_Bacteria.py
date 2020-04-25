import sys

#Fonctions

def creer_grille():
    for i in range(7):
        grille.append(['__']*7)

def affiche_grille():
    for i in grille:
        print i

def placer_pion():
    for cle in bac.keys():
        x=bac[cle]["x"]
        y=bac[cle]["y"]
        grille[y][x]=cle
    for cle in mol.keys():
        x=mol[cle]["x"]
        y=mol[cle]["y"]
        grille[y][x]=cle
    
def menu_deplacement():
    print "pour aller a gauche, tapez 'q'"
    print "pour rester ou vous etes, tapez 's'"
    print "pour aller en bas, tapez 'x'"
    print "pour aller a droite, tapez 'd'"
    print "pour aller en haut, tapez 'z'"
    print "pour arreter la partie, tapez 'p'"
        
def deplacer_mol(bac_vivante):
    for cle in mol.keys():
        x=mol[cle]["x"]
        y=mol[cle]["y"]
        grille[y][x]='__'    # pour effacer ancienne position dans la grille

        print "deplacer", cle
        move=False
        while move==False:
            move=True
            menu_deplacement()
            rep=raw_input("saisir deplacement:")
            
            if rep=='q':
                mol[cle]["x"]-=1
            elif rep=='s':
                mol[cle]["x"]+=0
                mol[cle]["y"]+=0
            elif rep=='x':
                mol[cle]["y"]+=1
            elif rep=='d':
                mol[cle]["x"]+=1
            elif rep=='z':
                mol[cle]["y"]-=1
            elif rep=='p':
                sys.exit()
            else:
                print "entrez une commande valide"
                move=False

            x1=mol[cle]["x"]
            y1=mol[cle]["y"]
            if grille[y1][x1]=="M1" or grille[y1][x1]=="M2" or grille[y1][x1]=="M3":
                print"Emplacement deja occupe par une autre molecule, veuillez saisir un autre deplacement"
                mol[cle]["x"]=x
                mol[cle]["y"]=y # pour remettre coordonnees de depart dans le dictionnaire
                move=False
            elif grille[y1][x1]=="B0":
                grille[y1][x1]=cle
                affiche_grille()
                print"La bacterie a ete tue, vous avez gagne la partie!"
                bac_vivante=False
            else:
                grille[y1][x1]=cle
                affiche_grille()
    return bac_vivante
            

def distance(bac_vivante):
    for i in bac.keys():
        for j in mol.keys():
            d=abs(bac[i]["x"]-mol[j]["x"])+abs(bac[i]["y"]-mol[j]["y"])
            if d==1:
                bac[i]["vie"]-=1
                print "vie",i,":",bac[i]["vie"]
                if bac[i]["vie"]==0:
                    print "la bacterie n'as plus aucun point de vie et meurt, vous avez gagne la partie!"
                    bac_vivante=False
    return bac_vivante
            
                
                
    
    
    
#Variables

grille=[]
bac={}    #separation d'un dictionaire unique 'pion' en 2 dictionnaires bac et mol 
mol={}    #pour ensuite pouvoir deplacer les molecules sans bouger la bacterie
bac["B0"]={"x":3,"y":3,"vie":3}
mol["M1"]={"x":2,"y":6}
mol["M2"]={"x":3,"y":6}
mol["M3"]={"x":4,"y":6}
tour=1
bac_vivante=True


#Programme principal
    
    
creer_grille()
placer_pion()
affiche_grille()
while bac_vivante==True:
    print "tour=",tour
    bac_vivante=deplacer_mol(bac_vivante)
    bac_vivante=distance(bac_vivante)
    tour+=1
    



