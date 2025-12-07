##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
##Description: A script to illustrate preallocation in R

NoPreallocFun <- function(x) {
    a1 <- vector() # empty vector
    for (i in 1:x) {
        a1 <- c(a1, i) # concatenate
        print(object.size(a1))
    }
}

system.time(NoPreallocFun(100))


PreallocFun <- function(x) {
    a2 <- rep(NA, x) # pre-allocated vector
    for (i in 1:x) {
        a2[i] <- i # assign
        print(object.size(a2))
    }
}

system.time(PreallocFun(100))

print(a1)
print(a2)