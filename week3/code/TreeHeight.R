# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

#load csv file
input_file = read.csv("../data/trees.csv")


#Calculate
calculate_height <- function (degrees, distance) {
    radians <- degrees * pi /180
    height <-  distance * tan(radians)
    print(paste("Tree height is:", height))
  
    return (height)
}

# Calculate height for each row (vectorized)
input_file$Height <- calculate_height(input_file$Angle.degrees, input_file$Distance.m)

#save output
write.csv(input_file, "../results/TreesHts.cvs", row.names = FALSE)

# Optional: print a message
cat("File saved to ../results/TreesHts.csv\n")
