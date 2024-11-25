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





