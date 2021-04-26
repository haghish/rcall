
# clear the warnings
assign("last.warning", NULL, envir = baseenv())
last.warning <- NULL

cor( c( 1 , 1 ), c( 2 , 3 ) )
cor( c( 3 , 3 ), c( 2 , 3 ) )

warnings()
last.warning



## NB this example is intended to be pasted in,
##    rather than run by example()
ow <- options("warn")
for(w in -1:1) {
  options(warn = w); cat("\n warn =", w, "\n")
  for(i in 1:3) { cat(i,"..\n"); m <- matrix(1:7, 3,4) }
  cat("--=--=--\n")
}

warnings()
last.warning

## at the end prints all three warnings, from the 'option(warn = 0)' above
options(ow) # reset to previous, typically 'warn = 0'
tail(warnings(), 2) # see the last two warnings only (via '[' method)

## Often the most useful way to look at many warnings:
summary(warnings())

op <- options(nwarnings = 10000) ## <- get "full statistics"
x <- 1:36; for(n in 1:13) for(m in 1:12) A <- matrix(x, n,m) # There were 105 warnings ...
summary(warnings())
options(op) # revert to previous (keeping 50 messages by default)


# Writing the command for handling R warnings
op <- options(warn=1) #warn=2 would return warnings as errors
tt <- try(cor( c( 3 , 3 ), c( 2 , 3 ) ))
ifelse(is(tt,"try-error"),"There was a warning or an error","OK")
options(op)

suppressWarnings(rm(WARNINGS))
if (!is.null(warnings())) {
  WARNINGS <- summary(warnings())
} 
labels(WARNINGS[1])

matrixWarnings = NULL
summaryWarnings <- unlist(summary(warnings()))
for (i in 1:length(summaryWarnings)) {
  matrixWarnings[i] <- paste("In", summaryWarnings[i][[1]], labels(summaryWarnings[i]))
}


labels(warnings())
summary(warnings())
labels(summary(warnings()))
summary(warnings())[[1]]
a = unlist(warnings())
b = labels(a)

assign("last.warning", NULL, envir = baseenv())
last.warning <- NULL
x <- 1:36; for(n in 1:13) for(m in 1:12) A <- matrix(x, n,m) # There were 105 warnings ...
warnings()

WARNINGS = NULL
summaryWarnings <- unlist(summary(warnings()))
for (i in 1:length(summaryWarnings)) {
  WARNINGS[i] <- paste("In", toString(summaryWarnings[i]), ":", names(summaryWarnings[i]))
}
WARNINGS
suppressWarnings(rm(summaryWarnings))


warning = paste("In", toString(summary(warnings())), ":", names(summary(warnings())))
warning

summary(warnings())
names(summary(warnings()))
toString(last.warning)
toString(summary(warnings()))
names(last.warning)
