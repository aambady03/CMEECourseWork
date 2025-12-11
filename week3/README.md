# CMEE Coursework — Week 3 (R Programming & Data Analysis)

## Overview

This folder contains materials for Week 3 of the CMEE coursework, focused on R programming: statistical analysis, data manipulation (apply family), performance comparisons (vectorization vs loops), and file I/O.

## Directory Structure

```
week3/
├── code/
│   ├── apply1.R
│   ├── apply2.R
│   ├── basic_io.R
│   ├── boilerplate.R
│   ├── break.R
│   ├── browse.R
│   ├── controlflow.R
│   ├── data_wrang.R
│   ├── florida.R
│   ├── floridaanalysis.tex
│   ├── girko.R
│   ├── my_bars.R
│   ├── next.R
│   ├── plotLin.R
│   ├── pp_regress.R
│   ├── preallocate.R
│   ├── r_conditionals.R
│   ├── sample.R
│   ├── sq_lin.R
│   ├── tree_height.R
│   ├── try.R
│   └── vectorize1.R
├── data/
│   ├── EcolArchives-E089-51-D1.csv
│   ├── JustOaksData.csv
│   ├── hist_cor.png
│   ├── KeyWestAnnualMeanTemperature.RData
│   ├── PoundHillData.csv
│   ├── PoundHillMetaData.csv
│   ├── Resource.csv
│   ├── Results.txt
│   ├── Rplot original plot.png
│   └── trees.csv
├── results/
└── sandbox/
```

## Scripts Overview (`code/`)

Each script demonstrates a specific R programming concept or analytical technique.

| Script | Purpose |
|--------|---------|
| `apply1.R` | Demonstrations of `apply`, `sapply`, and `lapply` for matrix operations |
| `apply2.R` | Advanced apply-family functions for data-frame aggregations |
| `basic_io.R` | Reading and writing data formats (`read.csv`, `write.csv`, `load`) |
| `controlflow.R` | Control flow examples: `if`, `for`, `while`, `repeat` constructs |
| `r_conditionals.R` | Conditional statement demonstrations in R |
| `preallocate.R` | Performance comparison: preallocated vs non-preallocated loops |
| `vectorize1.R` | Vectorization vs loop performance experiments |
| `pp_regress.R` | Predator-prey body mass regression analysis |
| `plotLin.R` | Simple linear regression plotting routines |
| `tree_height.R` | Calculate tree heights from distances and angles |
| `girko.R` | Girko's circular law demonstration with random matrices |
| `florida.R` | Florida temperature analysis and correlation exercises |
| `floridaanalysis.tex` | LaTeX report for Florida data analysis |
| `data_wrang.R` | Data manipulation and wrangling techniques |
| `my_bars.R` | Custom bar plot generation examples |
| `sq_lin.R` | Comparison of linear vs quadratic models |
| `break.R` | Loop break statement demonstrations |
| `next.R` | Loop next statement demonstrations |
| `try.R` | Error handling with try-catch blocks |
| `browse.R` | Debugging with browser() function |
| `sample.R` | Random sampling demonstrations |
| `boilerplate.R` | R script template |

## Data Overview (`data/`)

### Temperature Data
Time series data used for correlation and trend analysis:
- `KeyWestAnnualMeanTemperature.RData` — Annual temperature records

### Ecological Datasets
Large-scale ecological data for trait analysis and modeling:
- `EcolArchives-E089-51-D1.csv` — Body-size scaling and trait distributions
- `PoundHillData.csv` — Species-by-quadrat abundance data
- `PoundHillMetaData.csv` — Metadata for PoundHill dataset
- `Resource.csv` — Resource-consumer relationship data

### Tree Data
Field measurements for geometric calculations:
- `trees.csv` — Tree distance and angle measurements

### Taxonomic Data
Subset data for filtering exercises:
- `JustOaksData.csv` — Oak species taxonomic data

### Output Files
- `Results.txt` — Example text output from analysis scripts
- `hist_cor.png` — Histogram/correlation plot
- `Rplot original plot.png` — Reference plot for replication exercises

## Prerequisites

- R (base) — Scripts use only base R functions; no external packages required
- RStudio or X11 graphical device for viewing plots

## Example Workflows

**Run apply-family demonstrations:**
```r
setwd("~/Documents/CMEECourseWork/week3/code")
source("apply1.R")
source("apply2.R")
```

**Calculate tree heights:**
```r
source("tree_height.R")
# Check results/ directory for output
```

**Compare performance (vectorization vs loops):**
```r
source("preallocate.R")
source("vectorize1.R")
```

**Perform regression analysis:**
```r
source("pp_regress.R")
source("plotLin.R")
```

**Run Florida temperature analysis:**
```r
source("florida.R")
```

## Learning Outcomes

By completing Week 3, you should be comfortable with:
- Using `apply`, `sapply`, and `lapply` functions for vectorized operations
- Understanding performance trade-offs: preallocation and vectorization vs naive loops
- Performing simple statistical analyses and generating publication-ready plots
- Reading and writing common data formats programmatically in R
- Implementing control flow structures in R
- Debugging R code with browser() and error handling

## Author

Anaga Ambady  
Email: aa6725@ic.ac.uk

## Version History

View full commit log:
```bash
git log --oneline
```

## License

This repository contains coursework for the CMEE program at Imperial College London.  
Use is limited to educational purposes.

## Acknowledgments

- CMEE course instructors and teaching assistants
- Imperial College London