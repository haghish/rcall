# ------------------------------------------------------------------------------
# Prepare the WARNINGS
# ==============================================================================
# 1. if WARNINGS matrix (single column) is not specified by the developer, the warnings are 
#    captured from the 'warnings()' function. Next, the warnings are summarized 
#    and a matrix with a single column is created. this matrix is called WARNINGS.
#    the maximum length of this matrix is 50 rows i.e. no more than 50 warnings 
#    are returned to Stata
# 2. the WARNINGS matrix is used to generate scalars, named 'warning[1-50]', 
#    based on the number of rows of WARNINGS matrix
# 3. rcall automatically returns scalars to Stata. however, a specific command 
#    is written (rcall warnings) to print the warnings in the Stata results windows
#    properly
# 4. If the developer creates a matrix named WARNINGS, the first column is 
#    returned as warnings instead, providing some flexibility for Stata developers

# ------------------------------------------------------------------------------
# Prepare the GLOBAL
# ==============================================================================
# 1. You can store variables directly to Stata global environment
# 2. Create a matrix with two columns and name it GLOBAL. 
# 3. The first column is a single word or number, which will be attached to 
#    rcallglobal$ (instead of the dollar sign) to create the global variable
# 4. the value of the second column is the value of the defined global
# 5. rcall takes care of the rest
# 6. if you wish to remove the global variables, use 'rcall clear' command


# --------------------------------------------------------------------------
# REMOVE TEMPORARY MATRICES (rcall 3.0)
# ==========================================================================
rm(list = apropos("send.matrix."))


# ------------------------------------------------------------------------------
# a function to adjust the returned column names, since Stata doesn't accept
# multi-words names
# ==============================================================================
adj.names = function(x) {
  if (!is.null(x)) {
    for (i in 1:length(x)) {
      word = unlist(strsplit(x[i], " "))
      if (length(word) >= 2) {
        newWord = NULL
        for (j in 1:(length(word)-1)) {
          last = substr(word[j], nchar(word[j]), nchar(word[j]))
          Next = substr(word[j+1], 1, 1)

          # if there is a sign in between, combine the words. otherwise add
          # a dash
          if (last == "." | last == ":" | last == ";" | last == "~"
              | last == "+" | last == "-" | last == "*"
              | last == "$" | last == "|" | last == "["
              | last == "(" | last == "%" | last == "!"
              | last == "@" | last == "#" | last == "{"
              | last == "&" | last == "=" | last == "?") {
            word[j+1] = paste0(word[j], word[j+1])
          }
          else if (Next == "." | Next == ":" | Next == ";" | Next == "~"
                   | Next == "+" | Next == "-" | Next == "*" | Next == "_"
                   | Next == "$" | Next == "|" | Next == "["
                   | Next == "(" | Next == "%" | Next == "!"
                   | Next == "@" | Next == "#" | Next == "{"
                   | Next == "&" | Next == "=" | Next == "?") {
            word[j+1] = paste0(word[j], word[j+1])
          }
          else {
            word[j+1] = paste0(word[j], "-", word[j+1])
          }

          newWord = word[j+1]

          # Avoid these characters in the names! yet another limit...
          #       - dot
          newWord = gsub(".", "-", newWord, fixed = T)
        }

        if (!is.null(newWord)) {
          x[i] = newWord
        }
      }
    }
    return(x)
  } else {
    return(NULL)
  }
}


# ------------------------------------------------------------------------------
# a function to return values from R to Stata
# ==============================================================================
stata.output <- function(plusR, Vanilla="", stata.output="stata.output", load_mat_prefix="") {
  
  # --------------------------------------------------------------------------
  # CREATE FILE
  # ==========================================================================
  if(stata.output=="stata.output") stata.output <- file.path(getwd(), stata.output)
  file.create(stata.output)

  # --------------------------------------------------------------------------
  # IF NO ERROR HAS OCCURED, PREPARE COMMUNICATION
  # ==========================================================================
  if (rc == 0) {

    # erase the error marker
    suppressWarnings(rm(rc))

    if (exists("st.return") == TRUE)  {
      lst <- st.return
    }
    else {
      lst <- ls(globalenv())              #list global env
      
      # exclude "GLOBAL" and "WARNINGS"
      lst <- lst[lst != "GLOBAL" & lst != "WARNINGS"]
    }

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

    # Export the warnings as GLOBAL variables and remove the WARNINGS matrix
    # ----------------------------------------------------------------------
    if (exists("GLOBAL")) {
      if (ncol(GLOBAL) == 2) {
        for (i in 1:nrow(GLOBAL)) {
          if (i <= 50) {
            write(paste("//GLOBAL", paste0("rcallglobal", GLOBAL[i,1])), file=stata.output, append=TRUE)
            write(paste(GLOBAL[i,2]), file=stata.output, append=TRUE)
          }
        }
        suppressWarnings(rm(GLOBAL,  envir = globalenv()))
      }
    }


    # MATRIX
    # ------------------------------------
    matrix <- lst[sapply(lst,function(var) any(class(get(var))=='matrix'))]

    # ----------------------------------------------------------------------
    # PREPARE OUTPUT EXPORTATION
    # ======================================================================
    
    
    
    
    

    # NUMERIC (numeric AND integer)
    # ------------------------------------
    numeric = numeric[numeric!= "rcall_synchronize_ACTIVE"]  #remove rcall_synchronize_ACTIVE from the list
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
    string = string[string!= "stata.output"]  #remove stata.output from the list

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
      dims <- dim(iget)
      content <- paste("//MATRIX", i)
      write(content, file=stata.output, append=TRUE)

      if (!exists("rcall.synchronize.ACTIVE")) {
        # in rcall 3.0 the matrix is exported via a stata data set
        # check the colnames and rownames and make them like "Stata"
        if (is.null(colnames(iget))) {
          colnames(iget) <- paste0("c", 1:ncol(iget))
        }
        if (is.null(rownames(iget))) {
          rownames(iget) <- paste0("r", 1:nrow(iget))
        }

        ## adjust the names for Stata
        colnames(iget) <- adj.names(colnames(iget))
        rownames(iget) <- adj.names(rownames(iget))

        # convert the matrix to a data set and save it, but avoid converting string to factors
        iget = as.data.frame(iget)  #stringsAsFactors=FALSE but Stata cannot get the string matrices
        readstata13::save.dta13(iget, file=paste0(load_mat_prefix, "_load.matrix.", i, ".dta"), add.rownames = TRUE)
        
      }
      else {

        # adjust the names for Stata
        colnames = adj.names(colnames(iget))
        rownames = adj.names(rownames(iget))

        # GENERATE rownames and column names, if not defined.
        # this was a bug, while syncing matrices between
        # Stata and R...

        if (is.null(rownames)) {
          rownames = paste0("r", 1:dims[1])
        }

        if (is.null(colnames)) {
          colnames = paste0("c", 1:dims[2])
        }

        #write(content, file=stata.output, append=TRUE)
        write(paste("rownumber:", dims[1]), file=stata.output, append=TRUE)

        if (!is.null(colnames)) {
          write(paste("colnames:", paste(as.vector(t(colnames)), collapse=" "), collapse=" "),
                file=stata.output, append=TRUE)
        }
        if (!is.null(rownames)) {
          write(paste("rownames:", paste(as.vector(t(rownames)), collapse=" "), collapse=" "),
                file=stata.output, append=TRUE)
        }
        #Add comma

        write(paste(as.vector(t(iget)), collapse=", "), file=stata.output, append=TRUE
              , ncolumns = if(is.character(iget)) 1 else 21)
      }

      ## adjust the names for Stata
      #colnames = adj.names(colnames(iget))
      #rownames = adj.names(rownames(iget))
      #
      ## GENERATE rownames and column names, if not defined.
      ## this was a bug, while syncing matrices between
      ## Stata and R...
      #
      #if (is.null(rownames)) {
      #  rownames = paste0("r", 1:dims[1])
      #}
      #
      #if (is.null(colnames)) {
      #  colnames = paste0("c", 1:dims[2])
      #}
      #
      #
      #write(paste("rownumber:", dims[1]), file=stata.output, append=TRUE)
      #
      #if (!is.null(colnames)) {
      #  write(paste("colnames:", paste(as.vector(t(colnames)), collapse=" "), collapse=" "),
      #        file=stata.output, append=TRUE)
      #}
      #if (!is.null(rownames)) {
      #  write(paste("rownames:", paste(as.vector(t(rownames)), collapse=" "), collapse=" "),
      #        file=stata.output, append=TRUE)
      #}
      ##Add comma
      #
      #write(paste(as.vector(t(iget)), collapse=", "), file=stata.output, append=TRUE
      #      , ncolumns = if(is.character(iget)) 1 else 21)
    }

  }
  # --------------------------------------------------------------------------
  # IF ERROR HAS OCCURED, STOP STATA
  # ==========================================================================
  else {
    content <- paste("//SCALAR", "rc")
    write(content, file=stata.output, append=TRUE)
    write(1, file=stata.output, append=TRUE)

    content <- paste("//STRING", "error")
    write(content, file=stata.output, append=TRUE)
    write(error, file=stata.output, append=TRUE)

    suppressWarnings(rm(rc, error))
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
                                 packageList != "tools:rstudio" &
                                 packageList != "package:base" ]

    RProfile <- file.path(plusR, "RProfile.R")
    #Get RProfile from global
    file.create(RProfile)

    if (length(packageList) > 0) {
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
}




## EXAMPELS
#cor( c( 1 , 1 ), c( 2 , 3 ) )
#x <- 1:36; for(n in 1:13) for(m in 1:12) A <- matrix(x, n,m) # There were 105 warnings ...
#x <- 1:36; for(n in 1:6) for(m in 1:6) A <- matrix(x, n,m) # There were 105 warnings ...
#x <- 1:36; for(n in 1:13) for(m in 1:12) A <- matrix(x, n,m); rm(x);rm(n);rm(m);rm(A);
#GLOBAL = matrix(data=c("1","this is a text","2", "another thing"), ncol = 2, byrow = TRUE)
#class(GLOBAL) <- "GLOBAL"
#suppressWarnings(rm(list=paste0("warning",seq(1,50,1))))

# If warnings() is not NULL and WARNINGS does not exist, capture the warnings 
# ------------------------------------------------------------------------------
if (!is.null(warnings())) {
  if (!exists("WARNINGS")) {
    WARNINGS = NULL
    summaryWarnings <- unlist(summary(warnings()))
    for (loopItem in 1:length(summaryWarnings)) {
      WARNINGS[loopItem] <- paste("In", toString(summaryWarnings[loopItem]), ":", names(summaryWarnings[loopItem]))
    }
    if (length(WARNINGS) > 0) {
      if (length(WARNINGS) == 1) {
        cat(paste("Warning message:\n", WARNINGS[1], "\n"))
      } else {
        cat(paste("\nThere were", length(WARNINGS), "unique warnings (type 'rcall warnings' to see them)\n"))
      }
    }
    
    # clean up
    suppressWarnings(rm(summaryWarnings))
    WARNINGS = as.matrix(WARNINGS)
  }
  
  # generate the warnings, but first make sure WARNINGS has a single column!
  if (exists("WARNINGS")) {
    if (ncol(WARNINGS) == 1) {
      for (loopItem in 1:length(WARNINGS)) {
        assign(paste0("warning",loopItem), value = WARNINGS[loopItem])
      }
      rm(loopItem)
      rm(WARNINGS)
    }
  }
} 



