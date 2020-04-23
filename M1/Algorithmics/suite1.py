def suite(n):
    if n==0:
        return 3
    return 2*suite(n-1)+1
print(suite(2))
