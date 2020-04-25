def binomiale(n,k):
    return factorielle(n)/(factorielle(k)*factorielle(n-k))

def binomiale_recursif(n,p):
    if n>=0 and p==0:
        return 1
    if n>=0 and p==n:
        return 1
    return binomiale(n-1,p-1)+binomiale(n-1,p)

print binomiale(5,2)
print binomiale_recursif(5,2)
