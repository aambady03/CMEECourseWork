##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
##Description: describing apply functions in matrices

SomeOperation <- function(v) { # if the sum of the vector is bigger than 0,
#return the vector multiplied by 100, otherwise just return the vector
  if (sum(v) > 0) { #note that sum(v) is a single (scalar) value
    return (v * 100)
  } else { 
  return (v)
    }
}

M <- matrix(rnorm(100), 10, 10)
print (apply(M, 1, SomeOperation))