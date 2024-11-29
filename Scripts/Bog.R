#The bog is being analysed independently first to highlight its unique properties
#Calculating the biodiversity indicies as normal - without separating the two methods
#Bog was not initially combined with the invertrebrate sweepnetting and stream sampling due to slightly varying methods 
#So data looked at independently first
#Bog was suspected to be ecologically distinct so analysed seperately - combining the data may have  obscure important findings about the bog’s unique biodiversity.
#Knowing a habitats unique biodiversity in more detail can help further guide resotration decicions
library(vegan)
bog_data <- read.csv("bog.csv")

#Clean the dataset - removing missing rows etc
bog_data_clean <- bog_data[!is.na(bog_data$order) & bog_data$order != "" & !is.na(bog_data$individualCount), ]

#Aggregate data:Sum the individual counts by order
bog_aggregated <- aggregate(individualCount ~ order, data = bog_data_clean, sum)
#Convert the aggregated counts to a numeric vector for diversity calculations
bog_counts <- bog_aggregated$individualCount
#Calculate Species Richness (number of unique orders)
species_richness <- length(bog_counts)
species_richness
#Species richness = 4

#Calculate Shannon-Wiener Index (H')
shannon_index <- diversity(bog_counts, index = "shannon")
shannon_index
#0.7458657

# Calculate Simpson's Index 
simpson_index <- diversity(bog_counts, index = "simpson")
simpson_index
#0.4065306


#Now looking at the two methods 
#Stacked bar chart of order composition between kick-net sampling and sweep netting
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

#Combine datasets for kick and sweep netting
data <- data.frame(
  Method = c(rep("Kick Sampling", nrow(kick_orders)), 
             rep("Sweep Netting", nrow(sweep_orders))),
  Order = c(kick_orders$order, sweep_orders$order),
  Abundance = c(kick_orders$individualCount, sweep_orders$individualCount)
)

#Summarize data by method and order
data_summary <- aggregate(Abundance ~ Method + Order, data = data, sum)

library(ggplot2)

ggplot(data_summary, aes(x = Method, y = Abundance, fill = Order)) +
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
    x = "Sampling Method",
    y = "Total Abundance",
    fill = "Order"
  ) +
  scale_y_continuous(limits = c(0,30),expand = c(0, 0)) 

#Having to save the plot by itself as i am having issues with getting a good quality plot
ggsave("high_quality_plot.png", plot = last_plot(), dpi = 300, width = 8, height = 6, units = "in")




