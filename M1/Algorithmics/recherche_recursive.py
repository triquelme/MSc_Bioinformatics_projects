T=[1,6,2,7,5,4,6,9,6,10]
e=4

def recherche(T,e):
    return recherche_recursive(T,0,e)

def recherche_recursive(T,i,e):
    if i>=len(T):
        return None
    if T[i]==e:
        return i
    return recherche_recursive(T,i+1,e)

print recherche(T,e)
