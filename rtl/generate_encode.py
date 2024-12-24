import math 
p = 1
width = 512
y = ["0" for i in range(width)]
x = ["x[" + str(i) + "]" for i in range(width)]
for i in range(int(math.log(width, 2))):
    print(i)
    for j in range(p):
        tmp = y[j]
        if(tmp == "0"):
            y[j] = x[i]
        else:
            y[j] = "(" + tmp + "|" + x[i] + ")"
        if(tmp == "0"): 
            y[j + p] = "0"
        else: 
            y[j + p]= "(" + tmp + "&" + x[i] + ")"
    p = p + p


for i in range(len(y)): 
    print("y[" + str(i) + "] = " + y[i] + ";")

