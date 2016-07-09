#rm(list=ls())
#source('~/Dropbox/STATA/MY PROGRAMS/rdo/stata.output.R')
#setwd("~/Dropbox/STATA/MY PROGRAMS/rdo")

double <- as.double(23.434)
log <- as.logical(FALSE)
correct <- as.logical(T)

raw.object <- as.raw(0)

null.object <- NULL

complex.obj <- as.complex(-1)

listobject <- list(x = cars[,1], y = cars[,2], s="this is some lovely string
                   to add to the function which can also say a lot of 
                   amazing stuff")

numericScalar <- 10
NumericVecror <- c(1,2,3,4,5)
integerObject <- c(5:100)

matrixObject = matrix( 
    c(2, 4, 3, 1, 5, 7), # the data elements 
    nrow=2,              # number of rows 
    ncol=3,              # number of columns 
    byrow = TRUE)

matrixObject = matrix(c(2, 4, 3, 1, 5, 7), nrow=3,byrow = TRUE)

mystr <- 'this is a string'

char <- "LINE 1 just another string text that by chance can also be very long 
LINE 2 dakljd aksdj alskdj lkgje rg
 LINE 3 disj p 
LINE 4"

print(ls())










