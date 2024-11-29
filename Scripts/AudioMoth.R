library(vegan)


data <- read.csv("audiomoths.csv")
data

filtered_data <- data[, c("site", "scientificName")]
head(filtered_data)
tail(filtered_data)

north_data <- subset(filtered_data, site == "North")
north_richness <- length(unique(north_data$scientificName))
north_richness
#5

# Subset the data for "South" site
south_data <- subset(filtered_data, site == "South")
south_richness <- length(unique(south_data$scientificName))
south_richness
#3

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
# 0.6 
#Calculate Sørensen Index
sorensen_index <- (2 * A) / (2 * A + B + C)
cat("Sørensen Index:", sorensen_index, "\n")
#0.75

#matrix to display species presence absence: 

#presence-absence matrix
# Filter relevant columns and remove empty rows
filtered_data <- data[, c("site", "scientificName")]
filtered_data <- filtered_data[filtered_data$site != "" & filtered_data$scientificName != "", ]

# Check unique site values and clean the data
filtered_data$site <- trimws(filtered_data$site) 
filtered_data$site <- tolower(filtered_data$site) 
filtered_data$site <- ifelse(filtered_data$site == "north", "North", filtered_data$site)
filtered_data$site <- ifelse(filtered_data$site == "south", "South", filtered_data$site)

# Create presence-absence matrix
species_matrix <- table(filtered_data$scientificName, filtered_data$site)
species_matrix <- as.matrix(species_matrix > 0)  

# Melt data for ggplot
long_data <- melt(species_matrix)
colnames(long_data) <- c("Species", "Site", "Presence")

# Verify unique site values
print(unique(long_data$Site))

# Plotting the species presence/absence heatmap
ggplot(long_data, aes(x = Site, y = Species, fill = factor(Presence))) +
  geom_tile(color = "grey") +  
  scale_fill_manual(
    values = c("white", "steelblue"),  
    labels = c("Absent", "Present")
  ) +
  labs(
    title = "",
    x = "Site",
    y = "Species",
    fill = "Status"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 8, family = "Times"),  
    axis.text.x = element_text(size = 10, angle = 45, hjust = 1, family = "Times"),  
    axis.title.y = element_text(size = 12, family = "Times"),  
    axis.title.x = element_text(size = 12, family = "Times"),  
    plot.title = element_text(hjust = 0.5, size = 14, family = "Times"), 
    legend.text = element_text(size = 10, family = "Times"), 
    legend.title = element_text(size = 12, family = "Times"),  
    panel.grid = element_blank()  
  )

