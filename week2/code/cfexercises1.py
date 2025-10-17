#!/usr/bin/env python3

"""Some functions exemplifying the use of control statements"""
__appname__ = '[cfexercises1]'
__author__ = 'Anaga Ambady' 'aa6725@imperial.ac.uk'
__version__ = '0.0.1'

## imports ##
import sys # module to interface our program with the operating system

def foo_1(y):
    """Calculate the square root of y.
    Generate a message showing the square root of y (with decimals)."""
    root = y ** 0.5
    return f"{root} is the square root of {y}"

def foo_2(x, y):
    """Returns the larger number"""
    if x > y: 
        return f"{x} is larger than {y}."
    return f"{y} is the larger than {x}."

def foo_3(x, y, z):
    """Swaps the larger value so largest is first"""
    if x > y:
        x, y = y, x
    if x > z:
        x, z = z, x
    if y > z:
        y, z = z, y
    return [x, y, z] 
def foo_3(x, y, z):
    """Sorts list of numbers and prints largest number"""
    sorted_list = sorted([x, y, z], reverse=True)
    message = f"{sorted_list[0]} is the largest value from list"
    return message, sorted_list

def foo_4(x):#factorial: e.g.for 3: 3*2*1=6
    """Calculate factorial using a loop"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return f"{x} factorial is {result} (e.g., {x}! = {result})"  


def foo_5(x):
    """Calculate factorial using recursion"""
    
    # Helper function to calculate
    def calculate(n):
        if n == 1:
            return 1
        return n * calculate(n - 1)
    
    # Calculate result
    result = calculate(x)
    
    # Build steps string
    steps = " × ".join(str(i) for i in range(x, 0, -1))
    
    # Return formatted string
    return f"{x}! = {steps} = {result}"

def foo_6(x):
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
    print(foo_6(4))#Testing foo (fac function using while loop)
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)




    