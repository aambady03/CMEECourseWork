##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
###Description: Reads a csv file, stores ever row as a tuple 
##and prints the value from the first column of row
##then reads the original CSV and creates a new one with only
##species and body mass

import csv

# Read a file containing:
# 'Species','Infraorder','Family','Distribution','Body mass male (Kg)'
with open('../data/testcsv.csv','r') as f:

    csvread = csv.reader(f)
    temp = []
    for row in csvread:
        temp.append(tuple(row))
        print(row)
        print("The species is", row[0])

# write a file containing only species name and Body mass
with open('../data/testcsv.csv','r') as f:
    with open('../data/bodymass.csv','w') as g:

        csvread = csv.reader(f)
        csvwrite = csv.writer(g)
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0], row[4]])
