#!/bin/sh
# Author: Anaga Ambady anaga.ambady25@imperial.ac.uk
# Script: csvtospace.sh
# Description: Checks to see if there is an existing input file
# Converts comma seperated file to space-seperated
# Otherwise prints error message and tells user to enter input
# Usage: bash csvtospace.sh <input.csv>
# Date: Oct 2025

#check for input file
if [ -z "$1" ]; then
    echo "Usage: $0 input_file.txt" 
    exit 1
fi

#assign input variable
input="$1"

#check if file exists
if [ ! -f "$input" ]; then
    echo "Error: file '$input' not found"
    exit 1
fi

#create output filename (removes .csv suffix)
outfile="${input%.csv}.txt"


#converts csv to space-seperated and save as file name
tr "," " " < "$input" > "$outfile"


#prints message for user
echo "Success! Creating a space delimited version of $input ..."
echo "Created! Output is saved to $outfile"
exit 0 