
stata.output <- function(plusR, Vanilla="") {

    # --------------------------------------------------------------------------
    # PREPARATION
    # ==========================================================================
    lst <- ls(globalenv())              #list global env

    # NUMERIC (numeric AND integer)
    # ------------------------------------
    numeric <- lst[sapply(lst,function(var) any(class(get(var))=='numeric'))]
    integer <- lst[sapply(lst,function(var) any(class(get(var))=='integer'))]
    numeric <- c(numeric, integer)

    # STRING (character AND logical AND complex)
    # ------------------------------------
    string <- lst[sapply(lst,function(var) any(class(get(var))=='character'))]
    logical <- lst[sapply(lst,function(var) any(class(get(var))=='logical'))]
    complex <- lst[sapply(lst,function(var) any(class(get(var))=='complex'))]
    RAW <- lst[sapply(lst,function(var) any(class(get(var))=='raw'))]
    #string <- c(string, logical, complex, RAW)



    # LOGICAL
    # ------------------------------------

    # change NA to .
    for (St.NA in logical) {
        iget <- get(St.NA)
        St.NA[is.na(St.NA)] <- "."
    }


    string <- c(string, logical)

    #string <- c(string, logical, complex, RAW)

    # NULL
    # ------------------------------------
    null <- lst[sapply(lst,function(var) any(class(get(var))=='NULL'))]

    # LIST
    # ------------------------------------
    LIST <- lst[sapply(lst,function(var) any(class(get(var))=='list'))]


    # MATRIX
    # ------------------------------------
    matrix <- lst[sapply(lst,function(var) any(class(get(var))=='matrix'))]


    # --------------------------------------------------------------------------
    # PREPARE OUTPUT EXPORTATION
    # ==========================================================================

    stata.output <- file.path(getwd(), "stata.output")
    file.create(stata.output)

    # NUMERIC (numeric AND integer)
    # ------------------------------------
    for (St.Scalar in numeric) {
        iget <- get(St.Scalar)

        if (length(iget) == 1) {
            content <- paste("//SCALAR", St.Scalar)
            write(content, file=stata.output, append=TRUE)
            write(iget, file=stata.output, append=TRUE)
        }
        if (length(iget) > 1) {
            content <- paste("//NUMERICLIST", St.Scalar)
            write(content, file=stata.output, append=TRUE)
            write(iget, file=stata.output, append=TRUE
                  , ncolumns = if(is.character(iget)) 1 else 21)
        }
    }

    # NULL
    # ------------------------------------
    for (i in null) {
        write(paste("//NULL", i), file=stata.output, append=TRUE)
        #write(iget, file=stata.output, append=TRUE)
    }


    # STRING
    # ------------------------------------
    for (i in string) {
        iget <- get(i)
        content <- paste("//STRING", i)
        write(content, file=stata.output, append=TRUE)

        #Watch out for Vector strings
        if (length(iget) == 1) {
            write(iget, file=stata.output, append=TRUE)
        }
        else {
            content <- paste('"',iget,'"', sep = "")
            write(paste(content, " "), file=stata.output, append=TRUE)
        }
    }

    # LIST
    # ------------------------------------
    for (i in LIST) {
        iget <- get(i)
        inames <- names(iget)

        #Create an object for the list name
        #write(paste("//LIST", i), file=stata.output, append=TRUE)
        #write(inames, file=stata.output, append=TRUE)

        for (j in inames) {
            name <- paste(i,"$",j, sep = "")

            if (class(iget[[j]]) == "character") {
                content <- paste("//CLIST", name)
                write(content, file=stata.output, append=TRUE)
                if (length(iget) == 1) {
                    write(iget[[j]], file=stata.output, append=TRUE
                          , ncolumns = if(is.character(iget[[j]])) 1 else 21)
                }
                else {
                    content <- paste('"',iget[[j]],'"', sep = "")
                    write(paste(content, " "), file=stata.output, append=TRUE)
                }


            }
            else {
                content <- paste("//LIST", name)
                write(content, file=stata.output, append=TRUE)

                #print(class(iget[[j]]))
                write(iget[[j]], file=stata.output, append=TRUE
                      , ncolumns = if(is.character(iget[[j]])) 1 else 21)
            }
        }
    }

    # MATRIX
    # ------------------------------------
    for (i in matrix) {
        iget <- get(i)
        rows <- dim(iget)
        content <- paste("//MATRIX", i)
        write(content, file=stata.output, append=TRUE)
        write(paste("rownumber:", rows[1]), file=stata.output, append=TRUE)

        #Add comma

        write(paste(as.vector(t(iget)), collapse=", "), file=stata.output, append=TRUE
              , ncolumns = if(is.character(iget)) 1 else 21)
    }

    # --------------------------------------------------------------------------
    # Save the loaded libraries in interactive modes
    # ==========================================================================
    if (Vanilla == "") {

        packageList <- unique(search())     #avoid duplicates
        packageList <- packageList[packageList != ".GlobalEnv" &
                                       packageList != "package:stats" &
                                       packageList != "package:graphics" &
                                       packageList != "package:grDevices" &
                                       packageList != "package:utils" &
                                       packageList != "package:datasets" &
                                       packageList != "package:methods" &
                                       packageList != "Autoloads" &
                                       packageList != "package:base" ]

        RProfile <- file.path(plusR, "RProfile.R")
        #Get RProfile from global
        file.create(RProfile)

        for (i in 1:length(packageList)) {

            # Attach packages
            if (substr(packageList[i], 1, 8) == "package:") {
                name <- substr(packageList[i], 9, nchar(packageList[i]))
                write(paste("library(", name, ")", sep = ""), file=RProfile, append=TRUE)
            }

            # Attach variables and data
            else {
                name <- packageList[i]
                write(paste("attach(", name, ")", sep = ""), file=RProfile, append=TRUE)
            }
        }

    }
}

