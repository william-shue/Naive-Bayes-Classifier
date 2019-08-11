setwd("/Users/williamshue/Downloads/naive-bayes-classifier-master")
#read the data from the text file in as a matrix, data frame
subSet <- read.table("dataSubset.txt")

bins <- data.frame(matrix(ncol = 6, nrow = 0))
x <- c("# of rooms", "dist. from highway", "prop. tax", "stu. teach. ratio", "med. val. of homes", "buy or not")
colnames(bins) <- x

#rules for making bins for highway
counter <- 1
for (i in subSet[,2]){ 
  if(i > 7){
    bins[counter,2] <- "far aray" 
  } else if(i > 3 && i < 7){    
    bins[counter,2] <- "moderate"
  } else {
    bins[counter,2] <- "nearby"
  }
  counter <- counter + 1
}

#rules for making bins for rooom sizes
counter <- 1
for (i in subSet[,1]){ 
  if(i > 7.2){
    bins[counter,1] <- "large" 
  } else if(i > 5.2 && i < 7.2){
    bins[counter,1] <- "medium"
  } else {
    bins[counter,1] <- "small"
  }
  counter <- counter + 1
}

#rules for making bins for stu. teach. ratio
counter <- 1
for (i in subSet[,4]){ 
  if(i < 18.9){
    bins[counter,4] <- "small class" 
  } else {
    bins[counter,4]<- "large class"
  }
  counter <- counter + 1
}

#rules for making bins for property tax
counter <- 1
for (i in subSet[,3]){ 
  if(i <= 400){
    bins[counter,3] <- "high tax" 
  } else {
    bins[counter,3]<- "low tax"
  }
  counter <- counter + 1
}

#rules for making bins for property value
counter <- 1
for (i in subSet[,5]){ 
  if(i < 37.30){
    bins[counter,5] <- "high val." 
  } else {
    bins[counter,5]<- "low val."
  }
  counter <- counter + 1
}

#enter the first ten yes and no (buy or not buy) into the matrix (hardcoded), as the values were determined in the excel spreadsheet
bins[1,6] <- "yes"
bins[2,6] <- "yes"
bins[3,6] <- "yes"
bins[4,6] <- "yes"
bins[5,6] <- "no"
bins[6,6] <- "yes"
bins[7,6] <- "no"
bins[8,6] <- "no"
bins[9,6] <- "no"
bins[10,6] <- "no"

#create probability table for highway data
highway_PT <- data.frame(matrix(0, ncol = 5, nrow = 4))
x <- c("distance-description", "# of yes'", "# of nos", "P(Y)", "P(N)")
colnames(highway_PT) <- x
x <- c("far", "moderate", "nearby", "results")
rownames(highway_PT) <- x

#create probability table for rooms data
rooms_PT <- data.frame(matrix(0, ncol = 5, nrow = 4))
x <- c("size-description", "# of yes'", "# of nos", "P(Y)", "P(N)")
colnames(rooms_PT) <- x
x <- c("small", "medium", "large", "results")
rownames(rooms_PT) <- x

#create probability table for class size
classSz_PT <- data.frame(matrix(0, ncol = 5, nrow = 3))
x <- c("size-description", "# of yes'", "# of nos", "P(Y)", "P(N)")
colnames(classSz_PT) <- x
x <- c("large", "small", "results")
rownames(classSz_PT) <- x

#create probability table for prop val
value_PT <- data.frame(matrix(0, ncol = 5, nrow = 3))
x <- c("price-description", "# of yes'", "# of nos", "P(Y)", "P(N)")
colnames(value_PT) <- x
x <- c("high", "low", "results")
rownames(value_PT) <- x

#create probability table for tax
tax_PT <- data.frame(matrix(0, ncol = 5, nrow = 3))
x <- c("tax-description", "# of yes'", "# of nos", "P(Y)", "P(N)")
colnames(tax_PT) <- x
x <- c("high", "low", "results")
rownames(tax_PT) <- x

#populate frequency tables for given factors
for(i in 1:10){
  
  #rules for when a yes (buy) is encountered
  if(bins[i,6] == "yes"){
    
    #rules for rooms
    if(bins[i,1] == "small"){
      rooms_PT[1,2] <- rooms_PT[1,2] + 1
    }
    if(bins[i,1] == "medium"){
      rooms_PT[2,2] <- rooms_PT[2,2] + 1
    }
    if(bins[i,1] == "large"){
      rooms_PT[3,2] <- rooms_PT[3,2] + 1
    }
    
    #rules for highway
    if(bins[i,2] == "far"){
      highway_PT[1,2] <- highway_PT[1,2] + 1
    }
    if(bins[i,2] == "moderate"){
      highway_PT[2,2] <- highway_PT[2,2] + 1
    }
    if(bins[i,2] == "nearby"){
      highway_PT[3,2] <- highway_PT[3,2] + 1
    }
    
    #rules for prop tax.
    if(bins[i,3] == "high tax"){
      tax_PT[1,2] <- tax_PT[1,2] + 1
    }
    if(bins[i,2] == "low tax"){
      tax_PT[2,2] <- tax_PT[2,2] + 1
    }
    
    #rules for student teacher ratio
    if(bins[i,4] == "large class"){
      classSz_PT[1,2] <- classSz_PT[1,2] + 1
    }
    if(bins[i,4] == "small class"){
      classSz_PT[2,2] <- classSz_PT[2,2] + 1
    }
    
    #rules for med home value
    if(bins[i,5] == "high val."){
      value_PT[1,2] <- value_PT[1,2] + 1
    }
    if(bins[i,5] == "low val."){
      value_PT[2,2] <- value_PT[2,2] + 1
    }
  }
  
  #rules for when a no (do not buy) is encountered
  if(bins[i,6] == "no"){
    
    #rules for rooms
    if(bins[i,1] == "small"){
      rooms_PT[1,3] <- rooms_PT[1,3] + 1
    }
    if(bins[i,1] == "medium"){
      rooms_PT[2,3] <- rooms_PT[2,3] + 1
    }
    if(bins[i,1] == "large"){
      rooms_PT[3,3] <- rooms_PT[3,3] + 1
    }
    
    #rules for highway
    if(bins[i,2] == "far"){
      highway_PT[1,3] <- highway_PT[1,3] + 1
    }
    if(bins[i,2] == "moderate"){
      highway_PT[2,3] <- highway_PT[2,3] + 1
    }
    if(bins[i,2] == "nearby"){
      highway_PT[3,3] <- highway_PT[3,3] + 1
    }
    
    #rules for prop tax.
    if(bins[i,3] == "high tax"){
      tax_PT[1,3] <- tax_PT[1,3] + 1
    }
    if(bins[i,2] == "low tax"){
      tax_PT[2,3] <- tax_PT[2,3] + 1
    }
    
    #rules for student teacher ratio
    if(bins[i,4] == "large class"){
      classSz_PT[1,3] <- classSz_PT[1,3] + 1
    }
    if(bins[i,4] == "small class"){
      classSz_PT[2,3] <- classSz_PT[2,3] + 1
    }
    
    #rules for med home value
    if(bins[i,5] == "high val."){
      value_PT[1,3] <- value_PT[1,3] + 1
    }
    if(bins[i,5] == "low val."){
      value_PT[2,3] <- value_PT[2,3] + 1
    }
  }
}

populate_matrix <- function(your_matrix){
  for(i in 1:nrow(your_matrix)-1){
    your_matrix[i,1] <- rowSums(your_matrix[i,])
  }
  for(i in 1:nrow(your_matrix)-1){
    your_matrix[i,4] <- your_matrix[i,2]/10
    your_matrix[i,5] <- your_matrix[i,3]/10
  }
  for(i in 1:5){
    your_matrix[nrow(your_matrix),i] <- colSums(your_matrix[i])
  }
  #print("pop max done")
  return(your_matrix)
}

highway_PT <- populate_matrix(highway_PT[])
rooms_PT <- populate_matrix(rooms_PT[])
tax_PT <- populate_matrix(tax_PT[])
classSz_PT <- populate_matrix(classSz_PT[])
value_PT <- populate_matrix(value_PT[])




print("done")


