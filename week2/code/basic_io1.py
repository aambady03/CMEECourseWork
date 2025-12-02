##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025

#############################
# FILE INPUT# code shows how to fetch code from another file and run it
#and then modify 
#############################
# Open a file for reading
f = open('../data/test.txt', 'r')
# use "implicit" for loop:
# if the object is a file, python will cycle over lines
for line in f:
    print(line)

# close the file
f.close()

# Same example, skip blank lines
f = open('../data/test.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()
