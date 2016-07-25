
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
    for (i in numeric) {
        iget <- get(i)
        if (length(iget) == 1) {
            content <- paste("//SCALAR", i)
            write(content, file=stata.output, append=TRUE)
            write(iget, file=stata.output, append=TRUE)
        }
        if (length(iget) > 1) {
            content <- paste("//NUMERICLIST", i)
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
    # Save the loaded libraries 
    # ==========================================================================
    
    # when you execute R from batch mdoe, the libraries are detached with every 
    # command. Here is a fix for that, creating another Rscript which is 
    # sourced before executing the `"`macval(0)'"' in Rcall.ado
    # create a script file named "RProfile.R" 
    # this file should not be in the working directory. it's a long-term 
    # memory file. 
    
    packageList <- search()
    packageList <- packageList[packageList != ".GlobalEnv" & 
                                   packageList != "package:stats" & 
                                   packageList != "package:graphics" & 
                                   packageList != "package:grDevices" & 
                                   packageList != "package:utils" &
                                   packageList != "package:datasets" & 
                                   packageList != "package:methods" & 
                                   packageList != "Autoloads" & 
                                   packageList != "package:base" ]
    
    # Avoid saving RProfile for Vanilla Mode
    # --------------------------------------------------------------------------
    if (Vanilla == "") {
        RProfile <- file.path(plusR, "RProfile.R")
        #Get RProfile from global
        file.create(RProfile)
        
        #Make sure the elemment begins with "package:". Moreover, substring the 
        #package: from each element and write the file. 
        for (i in 1:length(packageList)) {
            if (substr(packageList[i], 1, 8) == "package:") {
                name <- substr(packageList[i], 9, nchar(packageList[i]))
                write(paste("library(", name, ")", sep = ""), file=RProfile, append=TRUE)
            }
        }
    }
}

