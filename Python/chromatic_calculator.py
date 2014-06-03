#!/usr/bin/python

def get_current():
    print("Enter how many sockets of each color your item CURRENTLY has:")
    red = input("Red: ")
    blue = input("Blue: ")
    green = input("Green: ")

    sockets = [red,blue,green]
    try:
        curr = [int(i) for i in sockets]
    except ValueError:
        curr = [0,0,0]
	
    return curr

def get_desired():
    print("Enter how many sockets of each color you WANT your item to have:")
    red = input("Red: ")
    blue = input("Blue: ")
    green = input("Green: ")

    sockets = [red,blue,green]

    return [int(i) for i in sockets]  

# Grab our input
x = 13

current = [0,0,0]
desired = [0,0,0]
sum_current = sum(current)
sum_desired = sum(desired)
negative = 0

while sum_current <= 0 or sum_current > 6 or negative > 0:
    current = get_current()
    sum_current = sum(current)
    
    negative = 0
    for num in current:
        if num < 0:
            negative += 1
            
    if sum_current <= 0 or sum_current > 6 or negative > 0:
        print("Please enter a valid number of sockets (between 1 and 6 total)")

while sum_desired <= 0 or sum_desired > 6 or negative > 0 or \
      sum_desired != sum_current:
    desired = get_desired()
    sum_desired = sum(desired)
    
    negative = 0
    for num in desired:
        if num < 0:
            negative += 1
            
    if sum_desired <= 0 or sum_desired > 6 or negative > 0:
        print("Please enter a valid number of sockets (between 1 and 6 total)")
    elif sum_desired != sum_current:
        print("Please enter the same number of total sockets as your item currently has")

