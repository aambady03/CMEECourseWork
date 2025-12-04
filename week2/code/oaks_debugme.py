#!/usr/bin/env python3

"""
Filters oak species from CSV data based on genus name matching.

This script reads a CSV file containing taxa data and extracts only the oak
species (genus Quercus) using fuzzy string matching to handle minor typos.

Author: Anaga Ambady (aa6725@ic.ac.uk)
Version: 1.0.0
Date: Oct 2025
"""

import csv
import sys
import doctest
import difflib


def is_an_oak(name):
    """Determines if a species name is an oak (Quercus) or a close variant,
    using fuzzy matching to allow for minor typos.

    A similarity ratio greater than 0.8 is considered
    a match.

    >>> is_an_oak('Fagus sylvatica')
    False
    >>> is_an_oak('Quercus')
    True
    >>> is_an_oak('Pinus')
    False
    >>> is_an_oak('quercus ')
    True
    >>> is_an_oak('quercuss')
    True
    >>> is_an_oak('Quercuss')
    True
    >>> is_an_oak('Quercus robur')
    True
    >>> is_an_oak('quercus ilex')
    True
    """ 
    # extract genus name (first word) and normalize
    genus = name.strip().split()[0].lower()
    
    # use fuzzy matching to allow for minor typos
    # a ratio > 0.8 means high similarity to 'quercus'
    similarity = difflib.SequenceMatcher(None, genus, 'quercus').ratio()
    return similarity > 0.8

# define relative file paths
def main(argv): 
    with open('../data/TestOaksData.csv', 'r') as f, \
         open('../data/JustOaksData.csv', 'w', newline='') as g:
        
        taxa = csv.reader(f) 
        # skip header row
        header = next(taxa)  
        
        csvwrite = csv.writer(g)
        # write header to output file
        csvwrite.writerow(header)  
        
        oaks_count = 0
        
        for row in taxa:
            # skip empty rows
            if not row:  
                continue
                
            genus = row[0].strip()
            print(f"The genus is: {genus}")
            
            if is_an_oak(genus):
                print('FOUND AN OAK!\n')
                csvwrite.writerow(row)
                oaks_count += 1
        
        print(f"\nTotal oaks found: {oaks_count}")
    
    return 0

    
if __name__ == "__main__":
    status = main(sys.argv)
    print("\nRunning doctests...\n")
    doctest.testmod(verbose=True)