##Author: Anaga Ambady (aa6725@ic.ac.uk)
##Version: 1.0.0
##Date: Oct 2025
##Description: A script to illustrate the use of break in R loops

i <- 0 
    while (i < Inf) {
        if (i == 10) {
            break 
        } else { # Break out of the while loop!  
            cat("i equals " , i , " \n")
            i <- i + 1 
    }
}
