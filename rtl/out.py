lgk = 10
k = 2 ** lgk
for i in range(k):
    print(str(k) + "'b", end = "")
    for j in range(k):
        if (i + j == k - 1):
            print("1", end="")
        else:
            print("0", end="")
    bits = f'{i:0{lgk}b}'
    # print(bits)
    print(f':out={lgk}\'b{bits};')
