#!/usr/bin/env python3

##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
##Description:  A simple script to demonstrate profiling in Python

# Function to compute squares of numbers up to 'iters'
def my_squares(iters):
    out = [i ** 2 for i in range(iters)]
    return out

# Function to join a string 'iters' times
def my_join(iters, string):
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

# Main function to run the above two functions
def run_my_funcs(x,y):
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")