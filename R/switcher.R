
# a generic function to switcher mrocalc/bymrocalc/between/b2 object to correct data frame form 
switcher <- function(obj,...) {
  
  UseMethod("switcher")
  
}

switcher.mrocalc <- function(obj, ...) {
  copy <- obj
  var <- copy$Mromoecalc$xlevels$Level
  target <- as.data.frame(copy$Mromoecalc[c("est","ErrBars","compL","compU","confL","confU")])
  rownames(target) <- NULL
  data.frame(var=var,target, bars=1)
}

switcher.bymrocalc <- function(obj, ...) {
  
  if (length(dimnames(obj))>1) {
    
    len = sapply(dimnames(obj),length)
    tot = len[1]*len[2]
    dn = dimnames(obj)
    idon.temp = obj[[which(!sapply(obj,is.null))[1]]]
    idon.temp.names = idon.temp$Mromoecalc$xlevels$Level
    temp3 = data.frame()
    for (k in 1:tot) {
      if (!is.null(obj[[k]])){
  
      temp = summary(obj[[k]]$Mromoecalc)$coef
      temp2 = rownames(temp)
      rownames(temp) <- NULL
      temp = data.frame(var=temp2, temp, bars=1)
      temp3 = rbind(temp3, temp)
      out = temp3
      }
      else{
        temp = matrix(NA, nrow = length(idon.temp.names), ncol= 6)
        temp2 = idon.temp.names
        colnames(temp) = c("Est", "ErrBar", "compL", "compU", "confL", "confU")
        temp = data.frame(var=temp2, temp, bars=1)
        temp3 = rbind(temp3, temp)
        out = temp3
      }
    }
    var2 = rep(dimnames(obj)[[2]],each=length(temp2)*len[1])
    var1 = rep(dimnames(obj)[[1]],each=length(temp2), times=len[2])
    vars = data.frame(var2=var2,var1=var1)
    names(vars) = names(dimnames(obj))[2:1]
    out = data.frame(vars,out)
    out$count <- rep(as.vector(sampleSize(obj)), each = length(temp$var))
  }
  else{
    tot = length(obj)
    temp3 = data.frame()
    idon.temp = obj[[which(!sapply(obj,is.null))[1]]]
    idon.temp.names = idon.temp$Mromoecalc$xlevels$Level
    for (k in 1:tot) {
      if (!is.null(obj[[k]])){
      temp = summary(obj[[k]]$Mromoecalc)$coef
      temp2 = rownames(temp)
      rownames(temp) <- NULL
      temp = data.frame(var=temp2, temp, bars=1)
      temp3 = rbind(temp3, temp)
      out = temp3
      }
      else{
        temp = matrix(NA, nrow = length(idon.temp.names), ncol= 6)
        temp2 = idon.temp.names
        colnames(temp) = c("Est", "ErrBar", "compL", "compU", "confL", "confU")
        temp = data.frame(var=temp2, temp, bars=1)
        temp3 = rbind(temp3, temp)
        out = temp3
      }
    }
    var1 = rep(dimnames(obj)[[1]],each=length(temp2))
    vars = data.frame(var1=var1)
    names(vars) = names(dimnames(obj))
    out = data.frame(vars,out)
    out$count <- rep(as.vector(sampleSize(obj)), each = length(idon.temp.names))
  }
  id = is.na(out$Est)
  out$Est[id] = 0
  out
}

switcher.between <- function(obj, ...) {
  
  index <- which((seq_along(obj) %% 2)>0)
  copy <- obj[index]
  tot = length(copy)
  target = data.frame()
  for (k in 1:tot) {
    temp = copy[[k]]
    name.temp = names(copy)[k]
    type.temp = rownames(temp)
    temp2 = data.frame(type=type.temp, var=name.temp, temp[,-2], bars=1)
    rownames(temp2) <- NULL
    target = rbind(target, temp2)
  }
  names(target)[1] <- attr(obj,"type1")
  id = is.na(target$est)
  target$est[id] = 0
  target
}

switcher.b2 <- function(obj, ...) {
  
  copy <- lapply(obj, switcher)
  tot = length(copy)
  target = data.frame()
  for (k in 1:tot) {
    temp = copy[[k]]
    type.temp = names(copy)[k]
    temp2 = data.frame(type=type.temp, temp)
    rownames(temp2) <- NULL
    target = rbind(target, temp2)
  }
  names(target)[1] <- attr(obj,"type2")
  id = is.na(target$est)
  target$est[id] = 0
  target
}