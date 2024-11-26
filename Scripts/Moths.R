###CALCULATE ALL THE ALPHA AND BETA DIVERSITY INDICIES###

moth_data <- read.csv("moths.csv")
head(moth_data)

moth_data_clean <- moth_data[!is.na(moth_data$order) & moth_data$order != "" & !is.na(moth_data$site) & moth_data$site != "", ]
moth_wide <- dcast(moth_data_clean, order ~ site, value.var = "individualCount", fun.aggregate = sum, fill = 0)
rownames(moth_wide) <- moth_wide$order
moth_matrix <- as.matrix(moth_wide[, -1])
moth_matrix_t <- t(moth_matrix)

#Calculate Alpha Diversity indices 
#Species Richness
species_richness <- rowSums(moth_matrix_t > 0)
print(species_richness)

#Shannon-Wiener Index (H')
shannon_index <- diversity(moth_matrix_t, index = "shannon")
print(shannon_index)

#Simpson's Index
simpson_index <- diversity(moth_matrix_t, index = "simpson")
print(simpson_index)

#Beta diversity
#Convert data to presence-absence matrix
moth_pa <- decostand(moth_matrix_t, method = "pa")
#Jaccard Index
jaccard_index <- vegdist(moth_pa, method = "jaccard")
print(jaccard_index)
# Sørensen Index
sorensen_index <- vegdist(moth_pa, method = "bray")
print(sorensen_index)


#Create a dataframe for species richness
species_richness_df <- data.frame(
  Site = names(species_richness),
  Richness = species_richness
)

#Plot the species richness
ggplot(species_richness_df, aes(x = Site, y = Richness, fill = Site)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Species Richness by Site", x = "Site", y = "Species Richness")



# Filter out rows where order is NA or empty
moth_data_clean <- moth_data %>%
  filter(!is.na(order) & order != "")

# Create a new column for the night of sampling
moth_data_clean$eventDate <- as.Date(moth_data_clean$eventDate, format = "%m/%d/%Y")
moth_data_clean$night <- ifelse(moth_data_clean$eventDate == as.Date("2024-09-11"), "Night 1", "Night 2")

# Aggregate data by site, night, and order
order_composition <- moth_data_clean %>%
  group_by(site, night, order) %>%
  summarise(total_count = sum(individualCount, na.rm = TRUE)) %>%
  ungroup()

# Define the color-blind-friendly palette
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

# Plot with the specified aesthetics
ggplot(order_composition, aes(x = night, y = total_count, fill = order)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = colourpalette) + # Apply custom color palette
  facet_wrap(~ site, ncol = 2) + # Separate plots for North and South hillsides
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
    title = "", # No title as the figure caption will be used
    x = "Night of Collection",
    y = "Total Abundance",
    fill = "Order"
  ) +
  scale_y_continuous(limits = c(0,20),expand = c(0, 0))


###Number of individuals per site recorded###
traps_individuals_per_site <- moth_data_clean %>%
  group_by(site) %>%
  summarise(total_individuals = sum(individualCount, na.rm = TRUE))
print(traps_individuals_per_site)
#North = 31
#South = 8 

