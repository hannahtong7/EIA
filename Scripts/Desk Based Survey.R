###Data input###

#INVASIVE SPECIES#
invasive <- c(North = 9, South = 5)

#RSPB PRIORITY SPECIES#
rspb_priority <- c(North = 2, South = 5)

#BIODIVERSITY ACTION PLAN SPECIES#
bap <- c(North = 4, South = 10)

#RED LIST SPECIES#
red_list <- c(North = 1, South = 8)

###Percentage Calculations###
percentage_invasive <- (invasive["North"] - invasive["South"]) / invasive["North"] * 100
percentage_rspb <- (rspb_priority["South"] - rspb_priority["North"]) / rspb_priority["North"] * 100
percentage_bap <- (bap["South"] - bap["North"]) / bap["North"] * 100
percentage_red_list <- (red_list["South"] - red_list["North"]) / red_list["North"] * 100

###Outputs###
cat("Invasive Species:", round(percentage_invasive, 1), "%\n")
cat("RSPB Priority Species:", round(percentage_rspb, 1), "%\n")
cat("BAP Species:", round(percentage_bap, 1), "%\n")
cat("Red List Species:", round(percentage_red_list, 1), "%\n")
