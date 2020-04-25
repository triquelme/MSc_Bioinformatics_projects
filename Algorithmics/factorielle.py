def factorielle(n):
    if n==1:
        return 1
    return factorielle(n-1)*n
print(factorielle(3))
