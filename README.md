# CMEE Coursework Repository

## Project Overview
This repository contains coursework materials for the Computational Methods in Ecology and Evolution (CMEE) program at Imperial College London. The coursework covers fundamental and advanced computational skills for ecological and evolutionary research, progressing from shell scripting through Python and R programming.

---

## Repository Structure

```
CMEECourseWork/
├── week1/          # Linux, Shell Scripting & Basic Coding
├── week2/          # Python Fundamentals
├── week3/          # R Programming & Data Analysis
├── week4/          # Advanced R & Code Optimization
└── README.md       # This file
```

---

## Week 1: Linux, Shell Scripting and Basic Coding Functions

### Description
Introduction to Linux shell scripting, text-processing utilities, and working with FASTA and tabular data. Focuses on Bash programming fundamentals and automated data manipulation.

### Key Topics
- Unix shell navigation and file management
- Shell scripting with Bash
- Text processing with `grep`, `awk`, `sed`, `cut`
- File format conversion (CSV, TSV, TIFF)
- LaTeX document compilation

### Technologies
- Bash shell scripting
- ImageMagick
- LaTeX

[View Week 1 README](week1/README.md)

---

## Week 2: Python Fundamentals

### Description
Introduction to Python programming with emphasis on list comprehensions, control flow, data structures, and basic bioinformatics algorithms.

### Key Topics
- List comprehensions and generators
- Control flow: conditionals, loops, recursion
- Python data structures: lists, tuples, sets, dictionaries
- File I/O and CSV parsing
- Sequence alignment algorithms
- Debugging with doctests

### Technologies
- Python 3.8+
- Standard library (csv, sys, os)
- pytest (optional)

[View Week 2 README](week2/README.md)

---

## Week 3: R Programming & Data Analysis

### Description
Introduction to R programming focusing on statistical analysis, data manipulation, performance optimization, and scientific visualization.

### Key Topics
- Apply family functions (`apply`, `sapply`, `lapply`)
- Vectorization vs loops performance
- Statistical modeling and regression
- Data wrangling techniques
- Publication-quality plotting
- Memory management and preallocation

### Technologies
- R (base)
- RStudio
- Base R graphics

[View Week 3 README](week3/README.md)

---

## Week 4: Advanced R Programming

### Description
Advanced R programming techniques using modern packages for data science, including the Tidyverse ecosystem for data manipulation and visualization.

### Key Topics
- Advanced data wrangling with dplyr and tidyr
- Publication-quality visualizations with ggplot2
- Statistical modeling and model comparison
- Code profiling and optimization
- Performance analysis with Python profiling tools

### Technologies
- R 4.0+ with Tidyverse
- ggplot2, dplyr, tidyr
- Python profiling tools

[View Week 4 README](week4/README.md)

---

## General Prerequisites

### Software Requirements
- **Unix/Linux environment** (Linux, macOS, or WSL on Windows)
- **Bash** 4.0+
- **Python** 3.8+
- **R** 4.0+
- **Git** for version control
- **Text editor** (VS Code, Sublime Text, vim, or nano)

### Optional Tools
- RStudio for R development
- pytest for Python testing
- ImageMagick for image processing
- LaTeX distribution for document compilation

---

## Getting Started

### Clone the Repository
```bash
git clone https://github.com/yourusername/CMEECourseWork.git
cd CMEECourseWork
```

### Navigate to Weekly Content
```bash
cd week1    # or week2, week3, week4
```

### Run Example Scripts
```bash
# Week 1 (Bash)
bash code/countlines.sh data/example.txt

# Week 2 (Python)
python3 code/align_seqs.py

# Week 3 (R)
Rscript code/tree_height.R

# Week 4 (Python/R)
python3 code/profileme.py
```

---

## Directory Structure Convention

Each week follows a consistent structure:

```
weekN/
├── code/           # All scripts and source code
├── data/           # Input data files
├── results/        # Output files (generated, not version controlled)
├── sandbox/        # Testing and experimental code
└── README.md       # Week-specific documentation
```

---

## Learning Progression

### Week 1: Foundation
- Master the command line
- Automate repetitive tasks
- Process text and data files

### Week 2: Programming Basics
- Learn core programming concepts
- Work with data structures
- Implement simple algorithms

### Week 3: Statistical Computing
- Analyze ecological data
- Create visualizations
- Optimize code performance

### Week 4: Advanced Techniques
- Modern data science workflows
- Publication-ready outputs
- Professional code optimization

---

## Best Practices

### Version Control
```bash
# Check status
git status

# Add changes
git add .

# Commit with descriptive message
git commit -m "Add Week N exercises"

# Push to remote
git push origin main
```

### Code Organization
- Keep scripts modular and well-commented
- Use meaningful variable and function names
- Follow language-specific style guides (PEP 8 for Python, tidyverse style for R)
- Write documentation for complex functions

### Data Management
- Store raw data in `data/` directories (never modify originals)
- Generate outputs in `results/` directories
- Use `.gitignore` to exclude large data files and results
- Document data sources and preprocessing steps

---

## Author

**Anaga Ambady**  
MSc Computational Methods in Ecology and Evolution  
Imperial College London  
Email: aa6725@ic.ac.uk

---

## Version History

View full commit log:
```bash
git log --oneline
```

View changes for specific week:
```bash
git log --oneline -- week1/
```

---

## License

This repository contains coursework for the CMEE program at Imperial College London.  
Use is limited to educational purposes.

---

## Acknowledgments

- **CMEE Course Instructors and Teaching Assistants**
- **Imperial College London, Department of Life Sciences**
- **Fellow CMEE students for collaboration and support**

---

## Contact

For questions about this repository:
- Email: aa6725@ic.ac.uk
- GitHub: [Your GitHub Profile]

For questions about the CMEE program:
- Visit: [Imperial College CMEE Program](https://www.imperial.ac.uk/life-sciences/postgraduate/masters-courses/computational-methods-in-ecology-and-evolution/)