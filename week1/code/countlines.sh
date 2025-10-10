#!/bin/sh
# Author: Anaga Ambady anaga.ambady25@imperial.ac.uk
# Script: countlines.sh
# Description: Checks if input file exists and is readable 
# Counts the number of lines in file 
# Usage: countlines.sh <inputfile>
# Date: Oct 2025

#check if there is an input file
if [ -z "$1" ]; then
    echo "Usage; $0 <filename>"
    echo "Error: No input file entered"
    exit 1
fi

#check if file exists
if [ ! -f "$1" ]; then
    echo "Error: file '$1' not found"
    exit 1
fi   

# Check if the file is readable
if [ ! -r "$1" ]; then
    echo "Error: '$1' is not readable."
    exit 1
fi

#display line count for file
NumLines=$(wc -l < "$1")
echo "The file $1 has $NumLines lines"
echo