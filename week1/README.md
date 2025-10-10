# Project Title

MY CMEE Coursework Repository

-week 1 : Linux, Shell Scripting and Basic Coding Functions

## Description

Basic Bash Scripts
1. FASTA file questions; analysis done of 'fasta' code in code
Improving shell Script
2. Shell Scripts for merging two files together 
3. Shell Scripts for counting the number of lines per file
4. Shell Scripts for converting tab delimeted files into comma seperated files
Write Shell Script
5. Shell Scripts for converting comma seperated values file to space delimeted
LaTex
6. Compiling txt files into a pdf with reference and bibliography

## Getting Started


### Dependencies
path: 
week1- ~/Documents/CMEECourseWork/week1/code

### Executing program

* Running Programme
1. This script processes E.coli genome data in FASTA format by first counting total lines across files and then extracting the sequence without headers. It calculates the genome length, counts individual nucleotides (A, T, G, C), sums these into AT and GC totals, and finally computes the AT/GC ratio, which is useful for understanding the genome’s nucleotide composition. The script also includes checks to handle edge cases like division by zero.
2. This script checks for required input files, merges the contents of two specified files by overwriting and appending into a new file, and then displays the merged file content, ensuring proper usage and error handling throughout.
3. The script checks if an input filename is provided, verifies that the file exists, and confirms it is readable. If any of these checks fail, it outputs an error and exits. If all checks pass, it counts and displays the number of lines in the specified file.
4. This script checks for a valid input file, converts a tab-delimited .txt file into a comma-delimited .csv file by replacing tabs with commas, and saves the output with a new filename, providing user feedback throughout.
5. This script first checks if an input filename is provided as an argument; if not, it displays usage instructions and exits. It then verifies whether the specified input file exists, exiting with an error message if it doesn't. The script creates an output filename by replacing the .csv extension of the input file with .txt. It converts the CSV file into a space-separated format by replacing commas with spaces, saving the result to the new output file. Finally, it prints success messages to inform the user of the conversion and the location of the output file before exiting.
6. Compiling bibliography and main text into pdf format using LaTeX



---

### Authors

Anaga Ambady
[aa6725@ic.ac.uk]

## Version History

*See git commit history

## License

-
## Acknowledgments

-
