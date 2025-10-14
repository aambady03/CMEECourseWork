birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by
# species 

birds = [['Passerculus sandwichensis','Savannah sparrow',18.7],['Delichon urbica','House martin',19],['Junco phaeonotus','Yellow-eyed junco',19.5],['Junco hyemalis','Dark-eyed junco',19.6], ['Tachycineata bicolor','Tree swallow',20.2]]

categories= ["Latin Name", "Common name", "Weight(kg)"]

for bird in birds:
    for i in range(3):
        print(categories[i] + ": " + str(bird[i]) + " ")
    print() 