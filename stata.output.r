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
stata.output <- function(plusR, Vanilla="") {
  
  # --------------------------------------------------------------------------
  # CREATE FILE
  # ==========================================================================
  stata.output <- file.path(getwd(), "stata.output")
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
    
    
    # MATRIX
    # ------------------------------------
    matrix <- lst[sapply(lst,function(var) any(class(get(var))=='matrix'))]
    
    # ----------------------------------------------------------------------
    # PREPARE OUTPUT EXPORTATION
    # ======================================================================
    
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
      
      
      write(content, file=stata.output, append=TRUE)
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

