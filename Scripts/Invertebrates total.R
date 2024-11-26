# Load necessary libraries
install.packages("readxl")
install.packages("vegan")
install.packages("dplyr")
library(readxl)
library(vegan)
library(dplyr)

#Before data was loaded in South and North side invertebrates were pasted into one sheet and checked


###LOAD IN DATA###
arran <- "~/Documents/temp/EIA.git/Data/inverttransects.xlsx" 
data <- read_excel(arran, sheet = "Invert Transects")

#Preview data 
head(data)
tail(data)

#I will be looking a biodiversity indicies using order - however on the South hillside some data points do not have this information.
#Need to omit these species from the data set:
install.packages("tidyr")
library(tidyr)

###CLEAN THE DATA###
#Filter out rows ommiting Order - this is because some species do not have a classification beyond descriptive.
dataclean <- data %>%
  filter(!is.na(order) & order != "")

###CALCULATE SPECIES RICHNESS - the number of different species on each hillside###
#Calculate by order 
order_richness_by_site <- dataclean %>%
  group_by(site, order) %>%
  summarise(individualCount = sum(individualCount, na.rm = TRUE)) %>%
  summarise(order_richness = n_distinct(order))

print(order_richness_by_site)
#North hillside Species Richness = 6
#South hillside Species Richness = 9

#Visualisation
install.packages("ggplot2")
library(ggplot2)

#Basic plot
ggplot(order_richness_by_site, aes(x = site, y = order_richness, fill = site)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(
    title = "Order Richness by Site",
    x = "Site",
    y = "Order Richness"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Improve the aesthetic of the graph - use BBC package
install.packages("ggthemes") 
library(ggthemes)

ggplot(order_richness_by_site, aes(x = site, y = order_richness, fill = site)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) + # Adjust bar width 
  scale_fill_manual(values = c("North" = "#0072B2", "South" = "#D55E00")) + # Colour pallette - colour blind friendly
  theme_minimal(base_size = 14) + # Font
  theme(
    text = element_text(family = "Times New Roman", color = "black"), # Font to align with text in EIA
    plot.title = element_text(face = "plain", size = 15, hjust = 0.5), # Center align title
    axis.title = element_text(face = "plain"), # axis titles
    axis.text.x = element_text(angle = 0, hjust = 0.5), 
    panel.grid.major.x = element_blank(), # Remove vertical grid lines
    panel.grid.minor = element_blank(), # Remove minor grid lines
    legend.position = "none" # Remove legend
  ) +
  labs(
    title = "Order Richness by Site",
    x = "Site",
    y = "Order Richness"
  )  + scale_y_continuous(
    limits = c(0, 10), # Edit Y axis
    breaks = seq(0, 9, 1) 
  )


###CALCULATE SHANNON-WIENER INDEX (H')###
#Considers species richness and evenness to measure biodiversity
#Low value = poor biodiversity
#High value = high biodiversity 
#This is a suitable primary indices as hillsides with low Shannon diversity may have imbalances (overdominance by specific orders) - could indicate degradation
# Convert data to a wide format (sites as rows, orders as columns)
# Keep 'site' as a column and avoid using row names

#Transform data to wide format (sites as rows, orders as columns)
order_matrix <- order_counts %>%
  pivot_wider(names_from = order, values_from = individualCount, values_fill = 0)

#Numeric matrix for calculations
order_matrix_numeric <- as.matrix(order_matrix[,-1])  
rownames(order_matrix_numeric) <- order_matrix$site

#Calculate Shannon-Wiener Index
shannon_index <- diversity(order_matrix_numeric, index = "shannon")

#Print results
print(shannon_index)
#North = 1.283699 - lower biodiversity (less eveness in the distribution of orders)
#South = 1.524545 - high biodiversity 
#South hillside has more diverse and evenly distributed orders compared to the North hillside

#Visualise: 

#Prepare data for Shannon Index plot
shannon_df <- data.frame(
  site = rownames(order_matrix_numeric),
  shannon_index = shannon_index
)

#Bar plot using ggplot
ggplot(shannon_df, aes(x = site, y = shannon_index, fill = site)) +
  geom_bar(stat = "identity", width = 0.7) + # Create bar plot
  scale_fill_manual(values = c("North" = "#0072B2", "South" = "#D55E00")) + #Color-blind-friendly palette
  theme_minimal(base_size = 14) + 
  theme(
    text = element_text(family = "Times New Roman", color = "black"), 
    plot.title = element_text(face = "plain", size = 15, hjust = 0.5), 
    axis.title = element_text(face = "plain"), #
    axis.text.x = element_text(angle = 0, hjust = 0.5), 
    panel.grid.major.x = element_blank(), 
    panel.grid.minor = element_blank(), 
    legend.position = "none"
  ) +
  labs(
    title = "Shannon-Wiener Index by Site",
    x = "Site",
    y = "Shannon Index"
  ) +
  scale_y_continuous(
    limits = c(0, max(shannon_df$shannon_index) + 0.1), #Ensure the y-axis covers the maximum value
    expand = c(0, 0)
  )

###NOW LOOK AT DIFFERENT ELEVATIONS - MAY INDICATE WHICH PARTS OF THE HILLSIDE NEED TO BE PRIORITIED IN RESTORATION###
#Will have to use locationID for elevations as there is data missing for elevations in (m)
#Need to note in the discussions in the results that these are rough elevation estimates and are zone based on oppertunistic sampling and vegetation zonality as well as estimation of elevation being categorised into Top Middle and Bottom 
library(dplyr)
library(tidyr)
library(ggplot2)

#Custom classification of elevation based on locationID
dataclean <- dataclean %>%
  mutate(elevation = case_when(
    grepl("Top", locationID) ~ "High",
    grepl("Middle", locationID) ~ "Middle",
    grepl("Bottom", locationID) ~ "Low",
    TRUE ~ NA_character_ #Assign NA to any unexpected values
  ))

#Ensure elevation is a factor with specified order
dataclean$elevation <- factor(dataclean$elevation, levels = c("High", "Middle", "Low"))


#Group data by site and elevation
elevation_analysis <- dataclean %>%
  group_by(site, elevation) %>%
  summarise(order_richness = n_distinct(order), .groups = "drop")

#Plot richness by elevation
ggplot(elevation_analysis, aes(x = elevation, y = order_richness, fill = site)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  scale_fill_manual(values = c("North" = "#0072B2", "South" = "#D55E00")) +
  theme_minimal(base_size = 14) +
  theme(
    text = element_text(family = "Times New Roman", color = "black"),
    plot.title = element_text(face = "plain", size = 15, hjust = 0.5),
    axis.title = element_text(face = "plain"),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "Order Richness Across Elevations",
    x = "Elevation Zone",
    y = "Order Richness"
  ) +
  scale_y_continuous(
    limits = c(0, max(elevation_analysis$order_richness) + 1), #Extend y-axis
    expand = c(0, 0)
  )

###SIMPSONS INDEX### - LOOK AT ORDER DOMINANCE/EVENESS 
library(dplyr)
library(tidyr)
library(vegan)

#Ensure data is grouped and aggregated
order_counts <- dataclean %>%
  group_by(site, order) %>%
  summarise(individualCount = sum(individualCount, na.rm = TRUE), .groups = "drop")

#Transform data into wide format (sites as rows, orders as columns)
order_matrix <- order_counts %>%
  pivot_wider(names_from = order, values_from = individualCount, values_fill = 0)

#Convert to numeric matrix for calculations
order_matrix_numeric <- as.matrix(order_matrix[, -1])  #Remove site column for calculations
rownames(order_matrix_numeric) <- order_matrix$site  #Set rownames to site names

#Calculate Simpson's Diversity Index for each site
simpson_index <- diversity(order_matrix_numeric, index = "simpson")

#Print the results
print(simpson_index)
#North 0.63769
#South 0.72995

#Closer to 0 = Higher biodiversity with even distribution of individuals across orders (low dominance by a single order).
#Closer to 1 = Lower biodiversity, indicating that one or a few orders dominate the ecosystem.

#With regards to dominance and evenness the North has relatively higher biodiversity compared to the South hillside.
#orders are more evenly distributed with no single order dominating the community.

#South has lower biodiversity compared to the North hillside.
#suggests that the community in the South hillside is less evenly distributed, with a few orders likely dominating the ecosystem.

#Could indicate that the North actually may have better ecological health 

#Group data by site, elevation, and order
elevation_order_data <- dataclean %>%
  group_by(site, elevation, order) %>%
  summarise(individualCount = sum(individualCount, na.rm = TRUE), .groups = "drop")

#Ensure elevation is a factor with specified levels
elevation_order_data$elevation <- factor(elevation_order_data$elevation, levels = c("High", "Middle", "Low"))

#Preview the data
head(elevation_order_data)

#Colour blind friendly colours
colourpalette <- c(
  "#E69F00",  
  "#56B4E9",  
  "#009E73",  
  "#F0E442",  
  "#0072B2",  
  "#D55E00",  
  "#CC79A7",  
  "#999999", 
  "#F28",  
  "#4E79A7",
  "#76B7B2"
  
)

#Stacked bar plot showing relative abundance of orders across different elevations
ggplot(elevation_order_data, aes(x = elevation, y = individualCount, fill = order)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = colourpalette) + #Allows custom colours
  facet_wrap(~ site, ncol = 2) + #Separate North and South hillsides
  theme_minimal(base_size = 14) +
  theme(
    text = element_text(family = "Times New Roman", colour = "black"),
    plot.title = element_text(face = "plain", size = 15, hjust = 0.5),
    axis.title = element_text(face = "plain"),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "", # No title as figure caption will be used
    x = "Elevation Zone",
    y = "Total Abundance",
    fill = "Order"
  ) +
  scale_y_continuous(expand = c(0, 0))


###Due to deciding that there are issues with considering elevation due to subjectivity and it not being easily comparable between the two hillsides I am taking out the elevation aspect of this graph: 
#Aggregate data to compare North and South hillsides overall
hill_order_data <- dataclean %>%
  group_by(site, order) %>%
  summarise(individualCount = sum(individualCount, na.rm = TRUE), .groups = "drop")

#Plotting the relative abundance of different orders for North and South
ggplot(hill_order_data, aes(x = site, y = individualCount, fill = order)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = colourpalette) + 
  theme_minimal(base_size = 14) +
  theme(
    text = element_text(family = "Times New Roman", colour = "black"),
    plot.title = element_text(face = "plain", size = 15, hjust = 0.5),
    axis.title = element_text(face = "plain"),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  labs(
    title = "", 
    x = "Hillside",
    y = "Total Abundance",
    fill = "Order"
  ) +
  scale_y_continuous(limits = c(0,250),expand = c(0, 0))

###Number of individuals per site recorded###
vertebrate_individuals_per_site <- data %>%
  group_by(site) %>%
  summarise(total_individuals = sum(individualCount, na.rm = TRUE))
print(vertebrate_individuals_per_site)
#North = 99
#South = 219 

###BETA DIVERSITY INDICES###
#Sørensen index
sorensen_index <- vegdist(order_matrix_numeric, method = "bray") # Bray-Curtis is essentially the Sørensen index for presence-absence data
print(sorensen_index)
#0.7025316

#Jaccard index
jaccard_index <- vegdist(order_matrix_numeric, method = "jaccard")
print(jaccard_index)
#0.8252788


