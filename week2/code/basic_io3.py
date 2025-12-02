##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
#############################
# STORING OBJECTS
#############################
# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

import pickle

f = open('../data/testp.p','wb') ## note the b: accept binary files
pickle.dump(my_dictionary, f)
f.close()

## Load the data again
f = open('../data/testp.p','rb')
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)
