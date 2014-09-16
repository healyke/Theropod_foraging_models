#10 June 2014
#T.rex energetics from individual based models
#Kevin Healy

rm(list=ls())
graphics.off()

ind_data <- read.csv("full_gut_full_comp_master.csv",sep=",", header = T)

#to get average
enr_day <- as.data.frame(matrix(0, nrow = length(levels(as.factor(ind_data$ind))) , ncol = c(3), dimnames = list(c(),c("mass","energy","prop"))))
daily.cost <-  as.data.frame(matrix(0, nrow = length(levels(as.factor(ind_data$mass))) , ncol = c(2),dimnames = list(c(),c("mass","energy"))))
daily.cost[,1] <- c(1.2,20,100,210,430,1000,1400,4000,6000,10000)
daily.cost[,2] <- c(333.7408,4408.2865,19296.3658,38112.4977,73552.3399,159529.3573,217217.0865, 569053.1521, 825456.5600, 1318902.0939) #remember these are in kilo joules


#to produce the average energy
for(i in 1:(length(levels(as.factor(ind_data$ind))))){
	
	enr_day[i,1] <- ind_data[ind_data$ind == i, "mass"][1]
	enr_day[i,2] <- sum(ind_data[ind_data$ind == i, "energy"]) - (length(ind_data[ind_data$ind == i, "energy"])*daily.cost[daily.cost$mass == ind_data[ind_data$ind == i, "mass"][1],"energy"])
	enr_day[i,3] <- sum(ind_data[ind_data$ind == i, "energy"])/(length(ind_data[ind_data$ind == i, "energy"])*daily.cost[daily.cost$mass == ind_data[ind_data$ind == i, "mass"][1],"energy"])
	
}

