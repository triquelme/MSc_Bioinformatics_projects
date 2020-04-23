# Fonctions pile
def creer_pile() :
    return []

def empiler(pile,e) :
    pile.append(e)
    
def depiler(pile) :
    return pile.pop()
   
def creer_pile1():
    pile=[]
    empiler(pile,0)
    return pile
    
def empiler1(pile,e):
    taille=depiler(pile)+1
    empiler(pile,e)
    empiler(pile,taille)

def depiler1(pile):
	taille=depiler(pile)-1
	e=depiler(pile)
	empiler(pile,taille)
	return e

def taille(pile):
	taille=depiler(pile)
	empiler(pile,taille)
	return taille


# Fonctions file
def creer_file():
	return creer_pile1()

def enfiler1(File,e):
	return empiler1(File,e)

def defiler1(File):
    F=creer_file() #liste temporaire pour stocker les elements
    for i in range(taille(File)-1):
        element=depiler1(File)
        empiler1(F,element)
    var=depiler1(File)
    for i in range(taille(F)):
        e=depiler1(F)
        empiler1(File,e)
    return var


# Tableau
def creer_tableau():
	return creer_pile1()


def inserer_element(T,Id,e):
    l=creer_pile1()
    for i in range(taille(T)-Id+1):
        x=depiler1(T)
        empiler1(l,x)
    empiler1(T,e)
    for i in range (taille(l)):
        x=depiler1(l)
        empiler1(T,x)

def supprimer_element(T,Id):
	l=creer_pile1()
	for i in range(taille(T)-Id):
		x=depiler1(T)
		empiler1(l,x)
	depiler1(T)
	for i in range(taille(l)):
		x=depiler1(l)
		empiler1(T,x)

def remplacer_element(T,Id,e):
	l=creer_pile1()
	for i in range(taille(T)-Id):
		x=depiler1(T)
		empiler1(l,x)
	depiler1(T)
	empiler1(T,e)
	for i in range(taille(l)):
		x=depiler1(l)
		empiler1(T,x)

def obtenir_element(T,Id):
	l=creer_pile1()
	for i in range(taille(T)-Id):
		x=depiler1(T)
		empiler1(l,x)
        
	element=depiler1(T)
    empiler1(T,element)
    for i in range(taille(l)):
        x=depiler1(l)
        empiler1(T,x)
    return element


#programme principal

pile=creer_pile1()
print pile

empiler1(pile,1)
empiler1(pile,2)
empiler1(pile,3)
empiler1(pile,4)

print pile


depiler1(pile)
depiler1(pile)

print pile

File=creer_file()
print File

enfiler1(File,1)
enfiler1(File,2)
enfiler1(File,3)
enfiler1(File,4)

print File

print(defiler1(File))
print File

defiler1(File)

print File

tab=creer_tableau()
print tab
inserer_element(tab,1,"a")
print tab
inserer_element(tab,2,"b")
print tab
inserer_element(tab,1,"x")
print tab
inserer_element(tab,1,"z")
print tab
remplacer_element(tab,2,"o")
print tab
print " obtenir element "
obtenir_element(tab,1)
