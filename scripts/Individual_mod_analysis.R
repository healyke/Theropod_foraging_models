#10 June 2014
#T.rex energetics from individual based models
#Kevin Healy

rm(list=ls())
graphics.off()

ind_data <- read.csv("full_gut_full_comp_master.csv",sep=",", header = T)

#to get average
enr_day <- as.data.frame(matrix(0, nrow = length(levels(as.factor(ind_data$ind))) , ncol = c(2), dimnames = list(c(),c("mass","energy"))))
daily.cost <-  as.data.frame(matrix(0, nrow = length(levels(as.factor(ind_data$mass))) , ncol = c(2),dimnames = list(c(),c("mass","energy"))))
daily.cost[,1] <- c(100,500,1000,2000,4000,6000,10000)
daily.cost[,2] <- c(19243.828,84039.563,158562.583,299170.140,564464.120,818316.553,1306521.754) #remember these are in kilo joules


#to produce the average energy
for(i in 1:(length(levels(as.factor(ind_data$ind))))){
	
	enr_day[i,1] <- sum(ind_data[ind_data$ind == i, "energy"]) - (length(ind_data[ind_data$ind == i, "energy"])*daily.cost[daily.cost$mass == ind_data[ind_data$ind == i, "mass"][1],"energy"])
    enr_day[i,2] <- ind_data[ind_data$ind == i, "mass"][1]
	
}

