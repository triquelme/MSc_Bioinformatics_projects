def suite(n):
    if n==0:
        return 0
    elif n==1:
        return 1
    return 2*suite(n-1)-suite(n-2)+1
print(suite(4))
