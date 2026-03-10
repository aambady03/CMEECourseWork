#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -J 1-100

cd $HOME

module load R

echo "R is starting job $PBS_ARRAY_INDEX"
echo "Loaded R version: $(R --version | head -n1)"
echo "Working directory: $(pwd)"
Rscript --vanilla aa6725_HPC_2025_neutral_cluster.R

echo "R job $PBS_ARRAY_INDEX has finished running"