#!/usr/bin/env python3

"""DNA sequence alignment programme

This script takes an input for 2 DNA sequences and then finds the alignment with the 
greatest number of matched alignments.

Author: Anaga Ambady (aa6725@ic.ac.uk)
Version: 1.0.0
Date: Oct 2025
"""
import csv, os

def calculate_score(s1, s2, l1, l2, startpoint):
    score = 0
    for i in range(l2):
        if (i + startpoint < l1):
            if s1[i + startpoint] == s2[i]:
                score += 1
    return score

def main():
    input_file = "../data/sequences.csv"
    output_file = "../results/alignment_result.txt"
    
    # Read sequences from CSV file
    with open(input_file, "r") as f:
        reader = csv.reader(f)
        sequences = [row[0].strip() for row in reader if row]
    
    seq1, seq2 = sequences[0], sequences[1]
    
    # Determine which is longer
    l1, l2 = len(seq1), len(seq2)
    if l1 >= l2:
        s1, s2 = seq1, seq2
    else:
        s1, s2 = seq2, seq1
        l1, l2 = l2, l1  # swap the two lengths
    
    my_best_align = None
    my_best_score = -1
    
    # Try all possible alignments
    for i in range(l1):
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2
            my_best_score = z
    
    with open(output_file, "w") as out:
        out.write("Best alignment:\n")
        out.write(my_best_align + "\n")
        out.write(s1 + "\n")
        out.write(f"Best score: {my_best_score}\n")
    
    print(f"Alignment complete. Results saved to {os.path.abspath(output_file)}")

if __name__ == "__main__":
    main()