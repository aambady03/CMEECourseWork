# CMEE Coursework Repository

## Overview

This repository contains coursework materials for the MSc in Computational Methods in Ecology and Evolution (CMEE) at Imperial College London. This README covers Week 2 content, which focuses on Python programming fundamentals including list comprehensions, control flow, and practical bioinformatics applications.

## Repository Structure

```
CMEECourseWork/
└── week2/
    └── code/
        ├── lc1.py
        ├── lc2.py
        ├── dictionary.py
        ├── cfexercises1.py
        ├── align_seq.py
        └── oaks_debugme.py
```

## Week 2: Python Fundamentals

### Scripts Overview

#### 1. List Comprehensions and Data Processing

**lc1.py** - Bird Species Data Processing
- Processes bird species data (Latin names, common names, mean body masses)
- Demonstrates both list comprehensions and conventional loops
- Compares two programming approaches for data extraction

**lc2.py** - Rainfall Data Filtering
- Analyzes UK monthly rainfall data from 1910
- Filters months with rainfall >100mm and <50mm
- Implements filtering using both list comprehensions and conventional loops

**dictionary.py** - Taxonomic Data Organization
- Creates dictionaries mapping taxonomic orders to species sets
- Demonstrates dictionary and set comprehensions
- Shows both conventional and comprehension-based approaches

#### 2. Control Flow

**cfexercises1.py** - Control Flow Demonstrations
- `foo_1(y)`: Calculates square root
- `foo_2(x, y)`: Compares two values
- `foo_3(x, y, z)`: Sorts three numbers in descending order
- `foo_4(x)`: Calculates factorial using loops
- `foo_5(x)`: Recursive factorial calculation with step display
- `foo_6(x)`: Iterative factorial with factorization steps

#### 3. Bioinformatics Application

**align_seq.py** - DNA Sequence Alignment
- Reads two DNA sequences from a CSV file
- Finds optimal alignment with maximum matching bases
- Uses sliding window approach to test all possible alignments
- Outputs best alignment, score, and sequences to a text file

#### 4. Debugging and Data Validation

**oaks_debugme.py** - Oak Species Filter
- Extracts oak species (*Quercus* genus) from taxonomic CSV data
- Implements fuzzy string matching to handle typos (>80% similarity threshold)
- Includes doctests for validation
- Outputs filtered data to a new CSV file

## Getting Started

### Prerequisites

- Python 3.x
- Standard library modules (no external dependencies for most scripts)
- For `oaks_debugme.py`: `difflib` module (included in Python standard library)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd CMEECourseWork/week2/code
```

2. Ensure Python 3 is installed:
```bash
python3 --version
```

### Usage

Run any script from the command line:

```bash
python3 lc1.py
python3 lc2.py
python3 dictionary.py
python3 cfexercises1.py
python3 align_seq.py
python3 oaks_debugme.py
```

**Note**: Some scripts may require input CSV files in the same directory or specified data directory.

## Key Learning Outcomes

- **List Comprehensions**: Efficient data processing and filtering
- **Control Flow**: Conditional statements, loops, and recursion
- **Data Structures**: Lists, tuples, dictionaries, and sets
- **File I/O**: Reading from and writing to CSV and text files
- **Algorithm Design**: Sequence alignment optimization
- **Code Quality**: Debugging, testing, and validation with doctests

## Author

**Anaga Ambady** 
Email: aa6725@ic.ac.uk  
MSc Computational Methods in Ecology and Evolution  
Imperial College London

## Version History

See commit history for detailed version information:
```bash
git log --oneline
```

## License

This project is part of academic coursework at Imperial College London.

## Acknowledgments

- CMEE course instructors and teaching assistants
- Imperial College London
- Course materials and practical sessions