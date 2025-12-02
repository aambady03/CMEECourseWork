#!/usr/bin/env python3

"""Some functions exemplifying the use of control
statements and list comprehensions.

Author: Anaga Ambady (aa6725@ic.ac.uk)
Version: 1.0.0
Date: Oct 2025
"""

## imports ##
import sys # module to interface our program with the operating system

# define functions
# calculate the square root of y and print result
def foo_1(y):
    """Calculates the square root of y."""
    root = y ** 0.5
    return f"{root} is the square root of {y}"

# prints the larger out of two values
def foo_2(x, y):
    """Compares two values and returns a string identifying the larger."""   
    if x > y: 
        return f"{x} is larger than {y}."
    return f"{y} is the larger than {x}."

# orders the numbers based on decreasing size
# prints largest
def foo_3(x, y, z):
    """Sorts three numbers and returns the largest value and the sorted list."""
    sorted_list = sorted([x, y, z], reverse=True)
    message = f"{sorted_list[0]} is the largest value from list"
    return message, sorted_list

# calculates a factorial using a loop
def foo_4(x):
    """Calculates x! using an iterative for loop."""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return f"{x} factorial is {result} (e.g., {x}! = {result})"  

#a Helper function to calculate
def calculate(n):
        if n == 1 or n == 0:
            return 1
        else:
            return n * calculate(n - 1)
    
# calculate factorial using recursion
def foo_5(x):
    """Calculates x! using recursion."""
    #b Calculate result
    result = calculate(x)
    
    #c Build steps string
    steps = " × ".join(str(i) for i in range(x, 0, -1))
    
    #d Return formatted string
    return f"{x} is factorised into {result}"

# calculate factorial using 'for' loop
def foo_6(x):
    """Calculates x! using an iterative for loop, showing factors."""
    facto = 1
    factors = []
    for i in range(x, 0, -1):
        facto *= i
        factors.append(str(i))
    return f"{x} is factorised into {' * '.join(factors)} = {facto}"

## functions ##
def main(argv):
    """Main function to test foo_1 with different inputs."""
    
    print(foo_1(100))#"Testing foo (square root function):"
    print(foo_2(10,5))#"Testing foo (conditional operations to return larger value):"
    print(foo_3(1,2,3))#"Testing foo (conditional operations to order larger value first):"
    print(foo_4(4))#Testing foo (factorial function)
    print(foo_5(4))#Testing foo (fac function with recursion)
    print(foo_6(4))#Testing foo (fac function using 'for' loop)
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)




    