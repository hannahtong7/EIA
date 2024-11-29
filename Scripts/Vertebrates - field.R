install.packages(c("dplyr", "ggplot2", "vegan", "reshape2"))
library(dplyr)
library(ggplot2)
library(vegan)
library(reshape2)

#Load the dataset containing vertebrate data
data <- read.csv("vertebrates.csv")

#Filter only the relevant columns ("site" and "scientificName")
filtered_data <- data[, c("site", "scientificName")]
head(filtered_data)
tail(filtered_data)

#Calculate species richness for the "North" site
north_data <- subset(filtered_data, site == "North")
north_richness <- length(unique(north_data$scientificName))
north_richness
#20

#Calculate species richness for the "South" site
#Subset the data for "South" site
south_data <- subset(filtered_data, site == "South")
south_richness <- length(unique(south_data$scientificName))
south_richness
#15

#Identify unique and shared species between the North and South sites
north_species <- unique(north_data$scientificName)
south_species <- unique(south_data$scientificName)

#Calculate shared and unique species
shared_species <- intersect(north_species, south_species) 
unique_north <- setdiff(north_species, south_species) 
unique_south <- setdiff(south_species, north_species)  

#Calculate counts for A, B, and C
A <- length(shared_species)  
B <- length(unique_north) 
C <- length(unique_south)  

#Calculate Jaccard Index
jaccard_index <- A / (A + B + C)
cat("Jaccard Index:", jaccard_index, "\n")
#0.4
#Calculate Sørensen Index
sorensen_index <- (2 * A) / (2 * A + B + C)
cat("Sørensen Index:", sorensen_index, "\n")
#0.5714286 

#matrix to display species presence absence: 

#presence-absence matrix
species_matrix <- table(filtered_data$scientificName, filtered_data$site)
species_matrix <- as.matrix(species_matrix > 0)  # Convert counts to binary (1/0)

#Reshape the matrix into a long format for plotting
long_data <- melt(species_matrix)
colnames(long_data) <- c("Species", "Site", "Presence")

# Plot species presence/absence as a heatmap
ggplot(long_data, aes(x = Site, y = Species, fill = factor(Presence))) +
  geom_tile(color = "grey") +  # Create tiles with grey borders
  scale_fill_manual(
    values = c("white", "steelblue"),  # Set colors for absence (white) and presence (blue)
    labels = c("Absent", "Present")   # Legend labels
  ) +
  labs(
    title = "Species Presence Across Sites",  # Plot title
    x = "Site",                              # X-axis label
    y = "Species",                           # Y-axis label
    fill = "Status"                          # Legend title
  ) +
  theme_minimal() +                          # Apply minimal theme
  theme(
    axis.text.y = element_text(size = 8, family = "Times"),  # Customize Y-axis text
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1, family = "Times"),  # Customize X-axis text
    axis.title.y = element_text(size = 12, family = "Times"),  # Customize Y-axis title
    axis.title.x = element_text(size = 12, family = "Times"),  # Customize X-axis title
    plot.title = element_text(hjust = 0.5, size = 14, family = "Times"),  # Customize plot title
    legend.text = element_text(size = 10, family = "Times"),  # Customize legend text
    legend.title = element_text(size = 12, family = "Times"),  # Customize legend title
    panel.grid = element_blank()  # Remove grid lines for cleaner appearance
  )

