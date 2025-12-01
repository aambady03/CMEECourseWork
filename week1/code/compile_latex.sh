#!/bin/bash
#Author: Anaga Ambady aa6725@ic.ac.uk
#Scripts: CompileLaTeX.sh
#Desc: compile Latex file
#Arguments: tex file
#Date: Oct 9

pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
evince $1.pdf &

## Cleanup
rm *.aux
rm *.log
rm *.bbl
rm *.blg


