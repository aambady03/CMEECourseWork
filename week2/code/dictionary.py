taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a python script to populate a dictionary called taxa_dic derived from
# taxa so that it maps order names to sets of taxa and prints it to screen.
# 
taxa = { ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
}
#create empty dictionary to story results
taxa_dict = {}
    
#for each member in tuple (by assigning species/order)
for species, order in taxa:
        #add order that isn't in our dictionary
        if order not in taxa_dict:
         taxa_dict[order] = set()
         #add the corresponding species to each order 
        taxa_dict[order].add(species)

#print the results (dictionary)
for order, species_set in taxa_dict.items(): 
        print(f"'{order}': {species_set}")
      

#### Your solution here #### 

# Now write a list comprehension that does the same (including the printing after the dictionary has been created)  
 
#### Your solution here #### 
