#!/bin/sh
# Author: Anaga Ambady anaga.ambady25@imperial.ac.uk
# Script: concatenatetwofiles.sh 
# Description: Merges two files into a third empty file ($3)
# Usage: concatenatetwofiles.sh <input.txt> <input2.txt>
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

#$1 file contents overwrites $3 
echo "Copying $1 file material to $3"
cat "$1" > "$3"

#appends $2 contents into $3
cat "$2" >> "$3"

#show merged file is completed in new file ($3)
echo
echo "=== New file '$3' is complete ==="
echo "Merged File content:"
echo "---------------------"
cat "$3"
echo "---------------------"
echo
exit 0