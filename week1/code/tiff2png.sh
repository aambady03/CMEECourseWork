#!/bin/bash
# Author: Anaga Ambady anaga.ambady25@imperial.ac.uk
# Script: Shell script to convert tif file to png
# Description: Locates tif file and then converts to a png
# Date: Oct 2025

# check if ImageMagick in installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Please install it first."
    exit 1
fi

#check input for tif
#converts tiff to png
for f in ../data/*.tif; 
    do  
        echo "Converting $f"; 
        convert "$f"  "$(basename "$f" .tif).png"; 
    done

