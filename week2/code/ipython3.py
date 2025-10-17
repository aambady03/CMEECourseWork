ipython3
a = (1, 2, []) 
a[2].append(1000)
a[2].append(1000)
a[2].append((100,10))
a = (1, 2, 3)
b = a + (4, 5, 6)
c = b[1:]
b = b[1:]
a = ("1", 2, True)

#sets
a = [5,6,7,7,7,8,9,9]
b = set(a)
b
c = set([3,4,5,6])
b & c # intersection
b | c # union

# Define a tuple
my_tuple = (1, 2, 3, 4, 5)

# Convert tuple to set
my_set = set(my_tuple)

# Print the set
print(my_set)

#dictionaries
GenomeSize = {'Homo sapiens': 3200.0, 'Escherichia coli': 4.6, 'Arabidopsis thaliana': 157.0}
GenomeSize
GenomeSize['Arabidopsis thaliana']
GenomeSize['Saccharomyces cerevisiae']= 12.1
GenomeSize
GenomeSize['Escherichia coli'] = 4.6 

# Define a dictionary with duplicate keys
my_dict = {'a': 1, 'b': 2, 'a': 3}

# Print the dictionary
print(my_dict)

#copying mutable objects
a = [1, 2, 3]
b = a
a.append(4)
print(a)
print(b)
a = [1, 2, 3]
b = a[:]  # This is a "shallow" copy; one level deep
a.append(4)
print(a)
print(b)
a = [[1, 2], [3, 4]]
b = a[:]
print(a)
print(b)
a[0][1] = 22 # Note how I accessed this 2D list xgo throughx
print(a)
print(b)
import copy

a = [[1, 2], [3, 4]]
b = copy.deepcopy(a)
a[0][1] = 22
print(a)
print(b)

