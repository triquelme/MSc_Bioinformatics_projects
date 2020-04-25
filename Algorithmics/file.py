def creer_file():
    return[]

def enfiler(F,e):
    F.append(e)

def defiler(F):
    return F.pop(0)

F=creer_file()
enfiler(F,1)
enfiler(F,2)
enfiler(F,3)

print (defiler(F))
print (defiler(F))
print (defiler(F))
