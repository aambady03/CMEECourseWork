#!/bin/sh
# Author: Anaga Ambady anaga.ambady25@imperial.ac.uk
# Script: variables.sh
# Description: Illustrates the use of variables 
# Converts comma seperated file to space-seperated
# Otherwise prints error message and tells user to enter input
# Usage: bash variables.sh <input.csv>
# Date: Oct 2025

# Special variables

echo "This script was called with $# parameters"
echo "The script's name is $0".
echo "The arguments are $1 and $2".
echo "The first argument is $1 and "
echo "the second argument is $2".

# Assigned Variables; Explicit declaration:
MY_VAR='some string' 
echo 'The current value of the variable is:' $MY_VAR
echo
echo 'Please enter a new string'
read MY_VAR


## Assigned Variables; Reading (multiple values) from user input:
echo 'Enter two numbers separated by space(s)'
read a b

MY_SUM=$((a + b))
echo
echo "you entered $a and $b ; Their sum is:"

## Assigned Variables; Command substitution
echo "$MY_SUM"