#!/bin/sh
# Author: Anaga Ambady anaga.ambady25@imperial.ac.uk
# Script: concatenatetwofiles.sh 
# Description: Checks to see if there an argument corresponding to a
# existing file then merges two input files into a
# third empty file ($3)
# Arguments: concatenatetwofiles.sh <input.txt> <input2.txt> <emptyfile.txt>
# Date: Oct 2025

#counts how many arguments the user typed
if [ $# -ne 3 ]; then
    echo "Error: incorrect number of arguments"
    exit 1
#check if first input file exists($1)
if [ ! -f "$1" ]; then
    echo "Error: file '$1' not found"
    exit 1
fi   


#Check if the second input file exists($2)
if [ ! -f "$2" ]; then
    echo "Error: Input file '$2' not found"
    exit 1
fi

#$1 file contents overwrites $3 
echo "Copying $1 file material to $3"
cat "$1" > "$3"

#appends $2 contents into $3
cat "$2" >> "$3"

#show merged file is completed in new file ($3)
echo
echo "Merged File content:"
echo "---------------------"
cat "$3"
echo "---------------------"
echo
exit 0
