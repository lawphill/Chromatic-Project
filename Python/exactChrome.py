#!/usr/bin/python

from math import factorial,exp,log
from itertools import permutations,combinations_with_replacement,combinations
from numpy import matrix,append,zeros,ones,mean,divide,sum,dot
from cmath import sqrt,pi


colors = [1,2,3]
req = [100,100,0]

# Model parameter
X = 12

# Create modified desired list
desired = []
for i in range(0,3):
    for j in range(0,colors[i]):
        desired.append(i+1)

# Color weights
p = [r+X for r in req]
Pr = p[0] / sum(p)
Pg = p[1] / sum(p)
Pb = p[2] / sum(p)

N = sum(colors)
Nfact = factorial(N)

combs_iter = combinations_with_replacement([r+1 for r in range(3)],N)

# Bring this into a usable form
combs = []
for i in combs_iter:
    combs.append(i)
	
Ncombs = len(combs)
Pcomb = []
Pperm = []

# Calculate probability of each combination
for i in combs:
    Nr = i.count(1)
    Ng = i.count(2)
    Nb = i.count(3)

    Pperm.append(Pr**Nr * Pg**Ng * Pb**Nb)
    Pcomb.append(Nfact/(factorial(Nr)*factorial(Ng)*factorial(Nb)) * Pr**Nr * Pg**Ng * Pb**Nb)

    
# Create Transition Matrix
T = zeros((Ncombs,Ncombs))
T = matrix(T)
count = 0
for i in combs:
    T[count,:] = Pcomb[:]
    T[count,count] = (Pcomb[count]-Pperm[count])/(1-Pperm[count])
    total = sum(T[count,:])
    T[count,:] = divide(T[count,:],total)

    if list(i) == desired:
        T[count,:] = 0
        T[count,count] = 1
        ind = count
        
    count += 1
    
# Create Fundamental Matrix & Identity Matrix
# Notation from  http://en.wikipedia.org/wiki/Absorbing_Markov_chain
Q = zeros((Ncombs-1,Ncombs-1))
I = zeros((Ncombs-1,Ncombs-1))

for i in range(len(T)):
    if i < ind:
        xind = i
    elif i > ind:
        xind = i-1
    else:
        xind = -1
        
    for j in range(len(T)):
        if j < ind:
            yind = j
        elif j > ind:
            yind = j-1
        else:
            yind = -1
        if xind > -1 and yind > -1:
            Q[xind,yind] = T[i,j]
            if xind == yind:
                I[xind,yind] = 1
                          
Nmat = matrix(I-Q)
Nmat = Nmat.I

t = Nmat * ones((len(Nmat),1))
print("Mean: " + str(int(mean(t))))

# Let's do some Inexact calculations!
T[ind,ind] = 0
prob_per_chrome = dot(matrix(Pcomb),T[:,ind])

def num_chromes():
    print("Let's calculate your chance of getting your desired item after a set number of chromes\nHow many will you try?")
    n = input("N: ")

    try:
        val = int(n) > 0        
    except ValueError:
        if n == 'q':
            return 0
        else:
            print("Sorry, let's that again or press 'q' to end\n")
            n = num_chromes()
	
    if int(n) > 0:
        return int(n)
    else:
        n = num_chromes()

# Ask user about a particular chance after a particular number of chromes        
#n = num_chromes()
#prob_so_far = 1 - (1 - prob_per_chrome)**n
#print(prob_so_far)

# Calculate the median
# The solution for x for .5 = 1 - (1-p)**x is
# (-.69315 + 6.2832i * n)/log(1-p)
# or (-log(2) + 2i * pi * n)/log(1-p)
n_inf = 1 # This can be any real number
x = (-log(2) + 2*sqrt(-1)*pi*n_inf)/log(1-prob_per_chrome)
print("Median: " + str(int(x.real)))