#!/bin/sh
# Author: Anaga Ambady anaga.ambady25@imperial.ac.uk
# Script: tabtocsv.sh
# Description: Checks to see if there is an existing input file
# Saves the output into a .csv file
# Otherwise prints error message and tells user to enter input
# Arguments: 1 -> tab delimited file
# Date: Oct 2025

#check for input file
if [ -z "$1" ]; then
    echo "Usage: $0 input_file.txt" 
    exit 1
fi

#check if file exists
if [ ! -f "$1" ]; then
    echo "Error: file '$1' not found"
    exit 1
fi

#removes txt suffix
#convert file to csv and save as file name
outfile="${1%.txt}.csv"

#prints message for user
echo "Creating a comma delimited version of $1 ..."
tr "\t" ","< "$1" > "$outfile"
echo "Done! Output is saved to $outfile"
exit 0