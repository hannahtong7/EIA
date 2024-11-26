library (vegan)

#Load data
freshwater<- read.csv("freshwater.csv")
head(freshwater)

###CALCULATE ORDER RICHNESS###

#Calculate species richness (number of unique orders) for each site
species_richness <- aggregate(order ~ site, data = freshwater, function(x) length(unique(x)))
#Rename the columns
colnames(species_richness) <- c("site", "species_richness")
#Print
print(species_richness)

#There is an issue with this:
#I have not taken out the empty rows which means the order richness is wrong

#Clean data:
freshwater_clean <- freshwater[!is.na(freshwater$order) & freshwater$order != "", ]
freshwater_clean

#Calculate order richness 
order_richness <- aggregate(order ~ site, data = freshwater_clean, function(x) length(unique(x)))
print(order_richness)

#Species Richness
#North = 13
#South = 9 

###CALCULATE SHANNON###
install.packages("reshape2")
library(reshape2)

#This makes rows orders, columns sites and values the total counts to allow to calculate the shannon diversity indicies
freshwater_wide <- dcast(freshwater_clean, order ~ site, value.var = "individualCount", fun.aggregate = sum, fill = 0)
#This sets row names as order and remove 'order' column to create a matrix suitable for vegan functions
rownames(freshwater_wide) <- freshwater_wide$order
freshwater_matrix <- as.matrix(freshwater_wide[, -1])
#transposing - rows represent sites and columns represent orders
freshwater_matrix_t <- t(freshwater_matrix)

#Calculate Shannon diversity from the vegan package:
shannon_index <- diversity(freshwater_matrix_t, index = "shannon")
print(shannon_index)
#North = 2.029148
#South = 1.795414

###CALCULATE SIMPSONS###
simpson_index <- diversity(freshwater_matrix_t, index = "simpson")
print(simpson_index)
#North = 0.8244444
#South = 0.7964876 

###BETA DIVERSITY INDICES###
#Calculate Jaccard index for pairwise dissimilarity
jaccard_index <- vegdist(freshwater_matrix_t, method = "jaccard")
print(jaccard_index)
#0.4242424

#Calculate Sørensen index for pairwise dissimilarity (Bray-Curtis for presence-absence data)
sorensen_index <- vegdist(freshwater_matrix_t, method = "bray")
print(sorensen_index)
#0.2692308








