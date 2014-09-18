r01 <- function(x, inverse = FALSE, opts = NULL) {
  
  # r01 will do the following task:
  # test1: not accept non binary level variable
  # test2: zero-variance variable, call "unary"
  # change1: no/yes => 0/1 false/true=>0/1 
  
  x <- as.ordered(x)
  n <- length(x)
  typecase <- storage.mode(x)
  
  if (storage.mode(x) == "complex")
    stop("Numeric variables must not be complex numbers")
  
  # not accept non binary variable
  if (length(levels(x)) > 2)
    stop("Non binary level variable")
  # a special care of the unary variable.
  if (length(levels(x)) == 1)
    typecase <- "unary"
  
  # 2 mode of binary. because the order is following alphabetic
  # or numeric, we may want a inverse to fix question that researcher
  # are interested people not response.
  bin <- if (inverse) 1:0 else 0:1
  
  if (! is.null(opts)) {
    typecase <- "special" 
    if (length(as.character(opts)) != 2)
      stop("'opts' should be a character vector of length 2")
  }
  
  if (typecase == "unary") {
    levels(x) <- if (inverse) 0 else 1
    x <- suppressWarnings(as.numeric(as.character(x)))
  } else if (typecase == "special") {
    tmpf <- factor(x, levels = opts, labels = 0:1)
    x <- suppressWarnings(as.numeric(as.character(tmpf)))
  } else {
    levels(x) <- bin
    x <- suppressWarnings(as.numeric(as.character(x)))
  }
  x[is.na(x)] <- if (inverse) 1 else 0
  x
}


iNZightMR <- function(frm, data, Labels = NULL, inverse = FALSE,  ...) {
  # y ~ v1 + v2 + v3 length is 3, ~v1 + v2 + v3 is length of two.
  # Labels could input substrsplit to catch the tail of each colnames
  # or Labels can be a equal-length vector to replace the original name
  
  if (length(frm[[2]])) 
    classnames <- as.character(frm[[2]])
  
  display <- with(data, {
    # grab variable name from the formual (frm) in the data file (data))
    mro.mat <- model.frame(frm[-2], data, na.action = na.pass, ...)
    #Ind <- as.logical(rowSums(is.na(mro.mat)))
    #mro.mat <- mro.mat[! Ind, ]
    #data <- data[! Ind, ]
    #rownames(data) <- NULL
    details <- attributes(mro.mat)
    variables <- attr(details$terms, "variables")
    
    # test binary level
    if (all(unique(sapply(mro.mat, nlevels)) == 2)) {
      mro.mat <- sapply(mro.mat, r01, inverse)
      ### mro function treat NA response as absent response in the original data set
    } else if (sum(which(sapply(mro.mat, nlevels) == 2)) == 0) {
      stop("Hard to detect binary pattern")
    } else {
      # use the levels of the first variables that have 2 levels
      index <- which(sapply(mro.mat, nlevels) == 2)[[1]]
      Commonlevels <- levels(mro.mat[, index])
      mro.mat <- sapply(mro.mat, r01, opts = Commonlevels)
      
    }
    
    labelname <-
      if (is.null(Labels)) {
        attr(details$terms, "term.labels")
      } else if (mode(Labels) == "function") {
        Labels(attr(details$terms, "term.labels"))
      } else {
        Labels
      }
    
    colnames(mro.mat) <-
      if (is.list(labelname))
        labelname$Varname
    else
      labelname
    
#     if (!is.null(combi)) {
#       combination.index <- combn(ncol(mro.mat), combi)
#       com.mro.mat <- c()
#       com.lablename <- c()
#       for (j in 1:ncol(combination.index)) {
#         com.mro.mat <- cbind(com.mro.mat, 
#                              mro.mat[, combination.index[1, j]] * mro.mat[, combination.index[2, j]])
#         com.lablename <- append(com.lablename, 
#                                 paste(labelname[combination.index[1, j]], 
#                                       labelname[combination.index[2, j]], sep = ":"))
#       }
#       colnames(com.mro.mat) <- com.lablename
#       mro.mat <- com.mro.mat
#       labelname <- com.lablename
#     }
    
    Ix <- order(colSums(mro.mat), decreasing = TRUE)
    mro.mat <- mro.mat[, Ix]
    labelname <- labelname[Ix]
    
    out <- list(mro.mat = mro.mat, Labels = labelname, df = data)
    if (!is.null(classnames)) 
      names(out)[1] <- classnames
    
    class(out) <- "mro"
    out
  })
  display
}