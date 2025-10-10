#!/bin/bash
# Author: Anaga Ambady anaga.ambady25@imperial.ac.uk
# Script: 
# Description: 
# Date: Oct 2025

#check input for tif


for f in ../data/*.tif; 
    do  
        echo "Converting $f"; 
        convert "$f"  "$(basename "$f" .tif).png"; 
    done