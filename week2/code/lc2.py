#!/usr/bin/env python3

"""Average Rainfall data in conventional loops

and list comprehensions.

Author: Anaga Ambady (aa6725@ic.ac.uk)
Version: 1.0.0
Date: Oct 2025
"""

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
# define rainfall data
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

print("List Comprehension:")

print("\nMonths and rainfall values when the amount of rain was greater than 100mm:")
high_rainfall = [row for row in rainfall if row[1] > 100]
print(high_rainfall)

    
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

print("\nMonths when the amount of rain was less than 50mm:")
low_rainfall = [row[0] for row in rainfall if row[1] < 50]
print(low_rainfall)

# (3) Now do (1) and (2) using conventional loops  
#3A

print("\nConventional Loops:")
print("\nMonths and rainfall values when the amount of rain was greater than 100mm:")
for row in rainfall:
    if row[1] > 100:
        print(row)

#3B

print("\nMonths when the amount of rain was less than 50mm:")
for row in rainfall:
    if row[1] < 50 :
        print(row)
