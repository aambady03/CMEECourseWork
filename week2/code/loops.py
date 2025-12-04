##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
###Description: A script of 'for' and 'while' loops

# FOR loops
# prints values from 0 to 4
for i in range(5):
    print(i)

# a for loop that prints the loop
my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)

# a for loop that sums up cumulative numbers 
total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
    print(total)

# WHILE loop
# a while loop that prints from 1 to 100
z = 0
while z < 100:
    z = z + 1
    print(z)