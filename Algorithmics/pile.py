def creer_pile():
    return[]

def empiler(P,e):
    P.append(e)

def depiler(P):
    return P.pop()

P=creer_pile()
empiler(P,1)
empiler(P,2)
empiler(P,3)
print(depiler(P))
print(depiler(P))
print(depiler(P))
