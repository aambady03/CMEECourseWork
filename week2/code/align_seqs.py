#!/usr/bin/env python3

"""DNA sequence alignment programme

This script takes an input for 2 DNA sequences and then finds the alignment with the 
greatest number of matched alignments.

Author: Anaga Ambady (aa6725@ic.ac.uk)
Version: 1.0.0
Date: Oct 2025
"""
## import ##
import csv
import os

# define functions
# calculate alignment score based on matches
def calculate_score(s1, s2, l1, l2, startpoint):
    """Calculates the aligment score between the shorter
sequence (s2) and a segment of the longer sequence (s1)
starting at 'startpoint'"""
    score = 0
    for i in range(l2):
        if (i + startpoint < l1) and s1[i + startpoint] == s2[i]:
            score += 1
    return score


#read dna sequences
def read_sequences(file_path):
    """Read sequences from a CSV file"""
    with open(file_path, "r") as f:
        reader = csv.reader(f)
        sequences = [row[0].strip() for row in reader if row]
    return sequences

def order_sequences(seq1, seq2):
    """Return the longer and shorter sequences saved as an
    object"""
    l1, l2 = len(seq1), len(seq2)
    if l1 >= l2:
        return seq1, seq2, l1, l2
    return seq2, seq1, l2, l1

def find_best_alignment(s1, s2, l1, l2):
    """Find the best alignment between both sequences"""
    best_align = None
    best_score = -1
    
    # find best alignment
    for i in range(l1):
        score = calculate_score(s1, s2, l1, l2, i)
        if score > best_score:
            best_align = "." * i + s2
            best_score = score

    return best_align, best_score

def write_results(output_file, alignment, reference_seq, score):
    """Write the alignment results to file"""
    with open(output_file, "w") as out:
        out.write("Best alignment:\n")
        out.write(alignment + "\n")
        out.write(reference_seq + "\n")
        out.write(f"Best score: {score}\n")


def perform_alignment(input_file, output_file):
    """Perform sequence alignment workflow""" 
    sequences = read_sequences(input_file)
    seq1, seq2 = sequences[0], sequences[1]

    s1, s2, l1, l2 = order_sequences(seq1, seq2)
    best_align, best_score = find_best_alignment(s1, s2, l1, l2)

     # write result files
    write_results(output_file, best_align, s1, best_score)
    print(f"Alignment complete. Results saved to {os.path.abspath(output_file)}")


# defines relative file locations
def main():
    """Main function to perform sequence alignment
    and save results"""
    input_file = "../data/sequences.csv"
    output_file = "../results/alignment_result.txt"
    perform_alignment(input_file, output_file)

   
   
if __name__ == "__main__":
    main()