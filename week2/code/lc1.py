#!/usr/bin/env python3

"""Using Converntional Loops and List comprehensions for 
bird species' mean body masses.

Author: Anaga Ambady (aa6725@ic.ac.uk)
Version: 1.0.0
Date: Oct 2025
"""
birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

#1A. latin names-comprehensions
#1B. common names
#1C. mean body mass

latin_names = [row[0] for row in birds]
common_names = [row[1] for row in birds]
mbody_mass = [row[2] for row in birds]

ln = ', '.join(map(str, latin_names))
cn = ', '.join(map(str, common_names)) 
mm = ', '.join(map(str, mbody_mass))

print("List Comprehensions:")
print(("The latin names of the species are:"), ln)     
print(("The common names of the species are:"), cn)
print(("The mean body masses of the species are:"), mm)

#(2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

#2A. latin names-conventional loops 
#2B. common names
#2C. mean body mass

latin_names = []
common_names = []
mbody_mass = []

for row in birds:
    latin_names.append(row[0])
    common_names.append(row[1])
    mbody_mass.append(row[2])

ln = ', '.join(map(str, latin_names))
cn = ', '.join(map(str, common_names))
mm = ', '.join(map(str, mbody_mass))
     
print("\nConventional Loops:")
print(("The latin names of the species are:"), ln)
print(("The common names of the species are:"), cn)
print(("The mean body masses of the species in kg are:"), mm)
