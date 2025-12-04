##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
##Description: 

def buggyfunc(x):
    y = x
    for i in range(x):
        y = y-1
        z = x/y #division by 0
    return z

buggyfunc(20)