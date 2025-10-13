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

birds = [['Passerculus sandwichensis','Savannah sparrow',18.7],['Delichon urbica','House martin',19],['Junco phaeonotus','Yellow-eyed junco',19.5],['Junco hyemalis','Dark-eyed junco',19.6], ['Tachycineata bicolor','Tree swallow',20.2]]
latin_names = [row[0] for row in birds]

ln = ', '.join(map(str, latin_names))
     
print(("The latin names of the species are:"), ln)

#1B. common names

birds = [['Passerculus sandwichensis','Savannah sparrow',18.7],['Delichon urbica','House martin',19],['Junco phaeonotus','Yellow-eyed junco',19.5],['Junco hyemalis','Dark-eyed junco',19.6], ['Tachycineata bicolor','Tree swallow',20.2]]
common_names_names = [row[1] for row in birds]

cn = ', '.join(map(str, common_names))
     
print(("The common names of the species are:"), cn)

#1C. mean body mass



#(2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

#2A. latin names-conventional loops 

birds = [['Passerculus sandwichensis','Savannah sparrow',18.7],['Delichon urbica','House martin',19],['Junco phaeonotus','Yellow-eyed junco',19.5],['Junco hyemalis','Dark-eyed junco',19.6], ['Tachycineata bicolor','Tree swallow',20.2]]
latin_names = []
for row in birds:
    latin_names.append(row[0])

ln = ', '.join(map(str, latin_names))
     
print(("The latin names of the species are:"), ln)

#2B. common names

birds = [['Passerculus sandwichensis','Savannah sparrow',18.7],['Delichon urbica','House martin',19],['Junco phaeonotus','Yellow-eyed junco',19.5],['Junco hyemalis','Dark-eyed junco',19.6], ['Tachycineata bicolor','Tree swallow',20.2]]
common_names = []
for row in birds:
    common_names.append(row[1])

cn = ', '.join(map(str, common_names))
     
print(("The common names of the species are:"), cn)

#2C. mean body mass

birds = [['Passerculus sandwichensis','Savannah sparrow',18.7],['Delichon urbica','House martin',19],['Junco phaeonotus','Yellow-eyed junco',19.5],['Junco hyemalis','Dark-eyed junco',19.6], ['Tachycineata bicolor','Tree swallow',20.2]]
mbody_mass = []
for row in birds:
    mbody_mass.append(row[2])

mm = ', '.join(map(str, mbody_mass))
     
print(("The mean body masses of the species in kg are:"), mm)

