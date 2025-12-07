##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
##Description: A script to demonstrate the use of 'next' statement in R

for (i in 1:10) {
  if ((i %% 2) == 0) # check if the number is odd
    next # pass to next iteration of loop (if no. is off, it skips to next iteration)
  print(i) #only odd no. are printed
}