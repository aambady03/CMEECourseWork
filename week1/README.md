# CMEE Coursework Repository

## Project Overview
This repository contains coursework materials for the Computational Methods in Ecology and Evolution (CMEE) program at Imperial College London.

---

## Week 1: Linux, Shell Scripting and Basic Coding Functions

### Description
Week 1 focuses on Linux shell scripting, basic text-processing utilities, and working with FASTA and tabular data. Scripts demonstrate fundamental concepts in Bash programming and data manipulation.

### Directory Structure
```
week1/
├── code/
│   ├── boilerplate.sh
│   ├── compile_latex.sh
│   ├── concatenatetwofiles.sh
│   ├── countlines.sh
│   ├── csvtospace.sh
│   ├── firstexample.tex
│   ├── FirstExample.pdf
│   ├── my_example_script.sh
│   ├── tabtocsv.sh
│   ├── tiff2png.sh
│   ├── unix_prac1.txt
│   └── variables.sh
├── data/
│   ├── fasta/
│   │   ├── 407228326.fasta
│   │   ├── 407228412.fasta
│   │   └── E.coli.fasta
│   ├── Temperatures/
│   │   ├── 1800.csv
│   │   ├── 1801.csv
│   │   ├── 1802.csv
│   │   └── 1803.csv
│   └── at3_1m4_01.tif
├── results/
│   └── .gitkeep
├── sandbox/
└── README.md
```

### Scripts Overview (`code/`)

| Script | Purpose |
|--------|---------|
| `boilerplate.sh` | Template for new Bash scripts (shebang, author, usage, structure) |
| `compile_latex.sh` | Compiles a LaTeX file and bibliography into a PDF |
| `concatenatetwofiles.sh` | Safely merges two files into one output file |
| `countlines.sh` | Counts the number of lines in a text file with input validation |
| `csvtospace.sh` | Converts comma-separated values to space-separated formatting |
| `tabtocsv.sh` | Converts tab-delimited files into CSV format |
| `tiff2png.sh` | Converts TIFF images to PNG (requires ImageMagick) |
| `variables.sh` | Demonstration script for shell variables, user input, and arguments |
| `my_example_script.sh` | General-purpose example used in teaching practical exercises |
| `unix_prac1.txt` | Document of notes or tasks used in the Unix practical |
| `firstexample.tex` / `FirstExample.pdf` | Example LaTeX source and compiled document |

### Data Overview (`data/`)

#### FASTA Files (`data/fasta/`)
Example sequence data used to practice:
- File reading
- Searching with `grep`
- Counting bases
- Writing small parsing scripts

**Files:**
- `407228326.fasta`
- `407228412.fasta`
- `E.coli.fasta`

#### Temperature CSV Files (`data/Temperatures/`)
Simple tabular datasets used to practice:
- Looping over files
- CSV manipulation
- Basic summarization

**Files:**
- `1800.csv`
- `1801.csv`
- `1802.csv`
- `1803.csv`

#### Other Data Files
- `at3_1m4_01.tif` — Demonstration file for testing image conversion (`tiff2png.sh`)

### Example Workflows

**Count lines in a file:**
```bash
bash code/countlines.sh data/fasta/E.coli.fasta
```

**Convert a tab-delimited file to CSV:**
```bash
bash code/tabtocsv.sh data/input.txt > data/output.csv
```

**Combine two files:**
```bash
bash code/concatenatetwofiles.sh file1.txt file2.txt merged.txt
```

**Convert a TIFF image to PNG:**
```bash
bash code/tiff2png.sh data/at3_1m4_01.tif
```

**Compile a LaTeX document:**
```bash
bash code/compile_latex.sh code/firstexample.tex
```

### Learning Outcomes
By completing Week 1, you should be comfortable with:
- Navigating a Unix shell
- Writing, executing, and debugging Bash scripts
- Using `grep`, `awk`, `sed`, `cut`, and pipes
- Automating file processing workflows
- Converting file formats (CSV, TSV, TIFF → PNG)
- Understanding script structure and reproducibility principles

---

## Author
**Anaga Ambady**  
Email: aa6725@ic.ac.uk

## Version History
View full commit log:
```bash
git log --oneline
```

## License
This repository contains coursework for the CMEE program at Imperial College London.  
Use is limited to educational purposes.