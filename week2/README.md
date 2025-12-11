# CMEE Coursework — Week 2 (Python Fundamentals)

## Overview

This folder contains materials for Week 2 of the CMEE coursework, focused on Python programming fundamentals: list comprehensions, control flow, data structures, and a small bioinformatics exercise (sequence alignment).

## Directory Structure

```
week2/
├── code/
│   ├── align_seqs.py
│   ├── basic_csv.py
│   ├── basic_io1.py
│   ├── basic_io2.py
│   ├── basic_io3.py
│   ├── boilerplate.py
│   ├── cfexercises1.py
│   ├── cfexercises2.py
│   ├── conditionals.py
│   ├── control_flow.py
│   ├── debugme.py
│   ├── dictionary.py
│   ├── lc1.py
│   ├── lc2.py
│   ├── loops.py
│   ├── my_example_script.py
│   ├── oaks_debugme.py
│   ├── oaks.py
│   ├── scope.py
│   ├── sysargv.py
│   ├── test_control_flow.py
│   ├── tuple.py
│   └── using_name.py
├── data/
│   ├── sequences.csv
│   ├── test.txt
│   ├── testcsv.csv
│   └── TestOaksData.csv
├── results/
└── sandbox/
```

## Scripts Overview (`code/`)

Each script demonstrates a specific Python programming concept or technique.

| Script | Purpose |
|--------|---------|
| `lc1.py` | Bird species data processing with list comprehensions and loops |
| `lc2.py` | Rainfall data filtering using comprehensions (>100mm or <50mm) |
| `dictionary.py` | Taxonomic data organization with dict/set comprehensions |
| `cfexercises1.py` | Control flow exercises with comparisons and sorting |
| `cfexercises2.py` | Factorial implementations (iterative and recursive) with doctests |
| `control_flow.py` | Examples of Python control flow fundamentals |
| `conditionals.py` | Conditional statement demonstrations |
| `loops.py` | Loop examples and patterns |
| `tuple.py` | Tuple data structure examples |
| `scope.py` | Variable scope demonstrations |
| `align_seqs.py` | Sliding-window sequence alignment algorithm |
| `oaks_debugme.py` | Oak species filtering with doctests and fuzzy matching |
| `oaks.py` | Extract genus *Quercus* from taxonomic CSV data |
| `basic_io1.py` | File reading examples |
| `basic_io2.py` | File writing examples |
| `basic_io3.py` | Combined I/O operations |
| `basic_csv.py` | CSV parsing demonstrations |
| `sysargv.py` | Command-line argument handling |
| `using_name.py` | `__name__` variable usage examples |
| `debugme.py` | Debugging exercise script |
| `boilerplate.py` | Python script template |
| `my_example_script.py` | General teaching example |
| `test_control_flow.py` | Unit tests for control flow functions |

## Data Overview (`data/`)

### Sequence Files
Example DNA/protein sequences used to practice:
- Sequence alignment algorithms
- String manipulation
- File parsing

**Files:**
- `sequences.csv`

### Taxonomic Data
Species datasets used to practice:
- Data filtering
- Pattern matching
- CSV manipulation

**Files:**
- `TestOaksData.csv`

### General Files
Simple datasets for I/O exercises:
- `test.txt` — Example text file for I/O operations
- `testcsv.csv` — Example CSV for parsing exercises

## Prerequisites

- Python 3.8+ (3.12 available in supplied virtual environment)
- Standard library modules only (no external dependencies)
- `pytest` (optional) for running `test_control_flow.py`

## Example Workflows

**Run list comprehension examples:**
```bash
cd ~/Documents/CMEECourseWork/week2/code
python3 lc1.py
python3 lc2.py
```

**Execute control flow exercises:**
```bash
python3 cfexercises1.py
python3 cfexercises2.py
```

**Perform sequence alignment:**
```bash
python3 align_seqs.py
# Check results/alignment_result.txt for output
```

**Filter oak species:**
```bash
python3 oaks_debugme.py
```

**Run tests:**
```bash
pytest -q test_control_flow.py
```

## Learning Outcomes

By completing Week 2, you should be comfortable with:
- List comprehensions and comprehension syntax
- Control flow: conditionals, loops, recursion
- Python data structures: lists, tuples, sets, and dictionaries
- File input/output and simple CSV parsing
- Basic algorithm design: sliding-window sequence alignment
- Debugging with doctests and simple unit tests

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
