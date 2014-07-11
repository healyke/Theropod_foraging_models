####--------------------T.rex scavanging paper-----------------------------###
#25 jun 2013
#Kevin Healy

rm(list=ls())
graphics.off()


####-----------------------------------------------------------------------###
####--------------------Energetics of t.rex seraching----------------------###
####-----------------------------------------------------------------------###

#percentage of time searching assumed to be half the day
search.time <- 0.5

#adult dinosaurs mass in kg
M <- 6000

#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W)
R <- 0.38*(M^0.83)

#relationship between M and max speed (v.max) meters/second from Alexander (1977)
v.max <- 8.5*(M^(-0.08))

#Assuming it can maintain 10% of this speed from Bennett & Ruben (1979)
v.s <- 0.1*v.max

#Energy cost of searching behaviour in Watts (W)
S <- 10.3*v.s*(M^0.64)

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
d <- 200
V <- 2*d*v.s

s.dens <- 4.38

#total energy expended in watts and joules per day
T.en.out <- R+search.time*S #in Watts
En.day <-  T.en.out*60*60*24 #joules per day


#to calulate the amount of fat reserves available to a t.rex using mamma fat reserves in Lindstedt and Boyce 1985, scaling of ---- using Schmidt-Nielsen 1979 energy content of fat as 39.3kJ/day/g.

kfat.e <- 39.3*1000*1000 # this is j/kg

Energy.res <- kfat.e*0.075*(kM^1.19)

days.fasting <- Energy.res/En.day




#Since the rate of energy gathering (E.met) must be positve with E energy extracted from a uniform distribution f with a search rate of V
#i.e energy in E.in = search.time(VfE-S)  must be > E.out = R
#  search.time*V*f*E - search.time*S > R
#  search.time*V*f*E > search.time*S + R
#  E*f > (search.time*S + R)/search.time*V
#  E.min*f = (search.time*S + R)/search.time*V

E.min.f = (search.time*S + R)/search.time*V #in J/meter^2


####-----------------------------------------------------------------------###
####-------------------------Carcass development---------------------------###
####-----------------------------------------------------------------------###

dino.data <- read.csv("Carbone.dino.size.csv")

#the size bins used  by Carbone et al
siz.gt <- c(20.6,58.3,1123,5347)
siz.gh <- c(75,216,700,2500,5000,8500,25000)


#the density of caracasses in the Serengeti in kg/km2/day
s.dens <- 4.38

#the percentage each group gives to this carcas production
#percent.carc <- c(0.493,0.368,0.06,0.067,0.006,0.004,0.002) including suropds
percent.carc <- c(0.493,0.368,0.06,0.067,0.006,0.004,0.002)

#if each herbivour bin sized group attributes an equal amount of "carcass" to the above density
mass.car <- s.dens/7

#we can calculate the amount of that production is bone from Prange et al 1979
#bon.m.h <-  0.061*(siz.gh^1.09) #scaling for bone allometry for mammals
bon.m.h <-  0.065*(siz.gh^1.071) 

#with flesh making up the differnce
flesh.m.h <- siz.gh-bon.m.h

#and the proportion of bone fro each bin size
prop.bone <- bon.m.h/siz.gh


#We can then calculate the amount of bone and flesh per km2 per day
#assumming that the mass coming from each group size is from an animal of that size
#we can use proportion of bone as calculated above the bone/km2/day

bone.den <- mass.car*prop.bone

#then ther enrgy available from bone per km/day is
E.b <- 6.7*1000*1000 #j/kg #from 6.7kJ/g based on the average from vultures food

bon.en <- (sum(bone.den))*E.b # in J/km2/day

bom.e.m <- bon.en/(1000000)

#Same with flesh using 7*10 j/kg 
E.f <- 7*1000*1000 #j/kg

prop.flesh <- 1-prop.bone

flesh.den <- mass.car*prop.flesh

flesh.en <- (sum(flesh.den))*E.f  # in J/km2/day
flesh.e.m <- flesh.en/(1000000) #in j/m2/day

#If we want to include the fact that the bones are only accessable to t-rex based on Graemes model which needs 31 j/m2/day of energy for a t-rex with ~ 80 meter scavanging range then it would take 10 days (as bone produces = 3.254336 j/m2/day) of bone build up to reach this level of sustainability. 





########---------------------Rate of carcass development approach--------------#####
#approach carcass development as the amount of time t-rex must walk before eating and then calulating the associated rate of carcass development required
########-----------------------------------------------------------------------#####
#the size bins used  by Carbone et al
siz.gt <- c(20.6,58.3,1123,5347)
siz.gh <- c(75,216,700,2500,5000,8500,25000)

#we can calculate the amount of that production is bone from Prange et al 1979
#bon.m.h <-  0.061*(siz.gh^1.09) #scaling for bone allometry for mammals
bon.m.h <-  0.065*(siz.gh^1.071) 

#with flesh making up the differnce
flesh.m.h <- siz.gh-bon.m.h


#to calculate the energy content of each individual
#bone content
#Check that the energy conversion is ok
indivdual.bone.en <-  bon.m.h*6.7*(10^6) #j #from 6.7(10^6)/kg
indivdual.flesh.en <-  flesh.m.h*7*(10^6) #j #from 7(10^6)J/kg

tot <- indivdual.bone.en + indivdual.flesh.en #joules
#total energy expended in watts and joules per day
T.en.out <- R+search.time*S #in Watts
En.day <-  T.en.out*60*60*24 #joules per day

# No of days a full individual will sustain
#day.sust.t <- tot/En.day
#day.sust.b <- indivdual.bone.en/En.day


#for body size classes
e <- 1.97 #constant for theropods
c <- 100 #constant for herbivors
D <- -0.75#allometric scaling for herbivours
f <- -0.88#allometric scaling for theropods

#this gives the density no/km for both the theropods and herbivors
#Nt <- e*(dino.data[dino.data$guild == "t","mass.categories"]^f)
#Nh <- c*(dino.data[dino.data$guild == "h","mass.categories"]^D)
Nt <- e*(siz.gt^f)
Nh <- c*(siz.gh^D)

sum.m <- (Nh*(dino.data[dino.data$guild == "h" ,"mass.categories"]))/sum(Nh*(dino.data[dino.data$guild == "h","mass.categories"]))



#no of individual of each size class it would have crossed in that a day
d <- c(80,200,500,1000)
V <- 2*d*v.s
area.s <- ((V*search.time*60*60*24)/(1000^2))
ka <- 0.75 #assimilation effeciancy
# to get the average no pf days between each carcass

days.to.car <- matrix(0, ncol = length(siz.gh), nrow = length(area.s), dimnames = list(area.s,siz.gh))

for (i in 1:(length(area.s))){

days.to.car[i, ] <- ((siz.gh[]/(s.dens))/area.s[i])

}


# the energy balance over time with bones and Carbone 
n.d <- seq(0,1000,1)
days.bone <- matrix(0,nrow = (length(n.d)), ncol = (length(area.s)), dimnames = list(n.d,area.s))
for(i in 1:(length(area.s))){
days.bone[,i] <-  ((indivdual.bone.en[1]*ka)*(floor(n.d/((siz.gh[1]/(s.dens))/area.s[i]))) 
+ (indivdual.bone.en[2]*ka)*(floor(n.d/((siz.gh[2]/(s.dens))/area.s[i]))) 
+ (indivdual.bone.en[3]*ka)*(floor(n.d/((siz.gh[3]/(s.dens))/area.s[i])))
+ (indivdual.bone.en[4]*ka)*(floor(n.d/((siz.gh[4]/(s.dens))/area.s[i]))) 
+ (indivdual.bone.en[5]*ka)*(floor(n.d/((siz.gh[5]/(s.dens))/area.s[i]))) 
+ (indivdual.bone.en[6]*ka)*(floor(n.d/((siz.gh[6]/(s.dens))/area.s[i]))) 
+ (indivdual.bone.en[7]*ka)*(floor(n.d/((siz.gh[7]/(s.dens))/area.s[i]))) 
- (En.day*n.d))
}


# this is if they ate whole idividuals or a kp percentage of them
kp <- 0.5
n.d <- seq(0,1000,1)
days.tot <- matrix(0,nrow = (length(n.d)), ncol = (length(area.s)), dimnames = list(n.d,area.s))
for (i in 1:(length(area.s))){
days.tot[,i] <-  ((tot[1]*kp*ka)*(floor(n.d/((siz.gh[1]/(s.dens))/area.s[i]))) 
+ (tot[2]*kp*ka)*(floor(n.d/((siz.gh[2]/(s.dens))/area.s[i]))) 
+ (tot[3]*kp*ka)*(floor(n.d/((siz.gh[3]/(s.dens))/area.s[i])))
+ (tot[4]*kp*ka)*(floor(n.d/((siz.gh[4]/(s.dens))/area.s[i]))) 
+ (tot[5]*kp*ka)*(floor(n.d/((siz.gh[5]/(s.dens))/area.s[i]))) 
+ (tot[6]*kp*ka)*(floor(n.d/((siz.gh[6]/(s.dens))/area.s[i]))) 
+ (tot[7]*kp*ka)*(floor(n.d/((siz.gh[7]/(s.dens))/area.s[i]))) 
- (En.day*n.d))
}


# this gives the lowest energy budget in terms of t.rex body wiegth loss
pp.t.rex.body <- c(0,0,0,0)
for (i in 1:(length(area.s))){
pp.t.rex.body[i] <- min(days.tot[,i])/((7*(10^6))*(M))
}


########### PLOTS ###################

dev.new()
plot(days.bone[1:365,1]~n.d[1:365], ylim = c(min(days.bone[1:365,]),max(days.bone[1:365,])), ylab = "Energy Balance (joules)", xlab = "days", pch = 1,col = "white" , main = "Energy budget of bone scavanging T.rex", bty = "l")
lines(days.bone[1:365,1]~n.d[1:365], col = "red")
lines(days.bone[1:365,2]~n.d[1:365], col = "blue")
lines(days.bone[1:365,3]~n.d[1:365], col = "orange")
lines(days.bone[1:365,4]~n.d[1:365], col = "green")

abline(0,1,lty = 2, col = "grey15")
abline(-((7*(10^6))*(6000*0.2)),1,lty = 6, col = "grey25" )
legend("topleft", c("36km","18km","7km","3km", "20% body weight"), col = c("green","orange","blue","red","grey25"), lty = c(1,1,1,1,6), bty="n", cex=0.75, title="Search rates")



dev.new()
plot(days.tot[1:365,1]~n.d[1:365], ylim = c(min(days.tot[1:365,]),max(days.tot[1:100,])), ylab = "Energy Balance (joules)", xlab = "days", pch = 1,col = "white" , main = "Energy budget of carcass scavanging T.rex", bty = "l")
lines(days.tot[1:365,1]~n.d[1:365], col = "red")
lines(days.tot[1:365,2]~n.d[1:365], col = "blue")
lines(days.tot[1:365,3]~n.d[1:365], col = "orange")
lines(days.tot[1:365,4]~n.d[1:365], col = "green")

abline(0,1,lty = 2, col = "grey15")
abline(-((7*(10^6))*(6000*0.2)),1,lty = 6, col = "grey25" )
legend("topleft", c("36km","18km","7km","3km", "20% body weight"), col = c("green","orange","blue","red","grey25"), lty = c(1,1,1,1,6), bty="n", cex=0.75, title="Search rates")




#########same as above ony with different body size densities

siz.Car.p <- c(0.493,0.368,0.06,0.067,0.006,0.004,0.002)
siz.dino.p <- c(0.01459854,0.1751825,0,0.2627737,0.01459854,0.5328467,0)
Size.d <- data.frame(siz.Car.p,siz.dino.p)
juv.size <- c(50,144,0.001,1667,3333,5667,0.001)


# the energy balance over time with bones and Carbone 
n.d <- seq(0,1000,1)
days.bone.p <- matrix(0,nrow = (length(n.d)), ncol = (length(area.s)), dimnames = list(n.d,area.s))
for(i in 1:(length(area.s))){
days.bone.p[,i] <-  ((indivdual.bone.en[1]*ka)*(floor(n.d/((siz.gh[1]/(s.dens*7*Size.d[1,1]))/area.s[i]))) 
+ (indivdual.bone.en[2]*ka)*(floor(n.d/((siz.gh[2]/(s.dens*7*Size.d[2,1]))/area.s[i]))) 
+ (indivdual.bone.en[3]*ka)*(floor(n.d/((siz.gh[3]/(s.dens*7*Size.d[3,1]))/area.s[i])))
+ (indivdual.bone.en[4]*ka)*(floor(n.d/((siz.gh[4]/(s.dens*7*Size.d[4,1]))/area.s[i]))) 
+ (indivdual.bone.en[5]*ka)*(floor(n.d/((siz.gh[5]/(s.dens*7*Size.d[5,1]))/area.s[i]))) 
+ (indivdual.bone.en[6]*ka)*(floor(n.d/((siz.gh[6]/(s.dens*7*Size.d[6,1]))/area.s[i]))) 
+ (indivdual.bone.en[7]*ka)*(floor(n.d/((siz.gh[7]/(s.dens*7*Size.d[7,1]))/area.s[i]))) 
- (En.day*n.d))
}


# this is if they ate whole idividuals or a kp percentage of them
kp <- 0.5
n.d <- seq(0,1000,1)
days.tot.p <- matrix(0,nrow = (length(n.d)), ncol = (length(area.s)), dimnames = list(n.d,area.s))
for (i in 1:(length(area.s))){
days.tot.p[,i] <-  ((tot[1]*kp*ka)*(floor(n.d/((siz.gh[1]/(s.dens*7*Size.d[1,1]))/area.s[i]))) 
+ (tot[2]*kp*ka)*(floor(n.d/((siz.gh[2]/(s.dens*7*Size.d[2,1]))/area.s[i]))) 
+ (tot[3]*kp*ka)*(floor(n.d/((siz.gh[3]/(s.dens*7*Size.d[3,1]))/area.s[i])))
+ (tot[4]*kp*ka)*(floor(n.d/((siz.gh[4]/(s.dens*7*Size.d[4,1]))/area.s[i]))) 
+ (tot[5]*kp*ka)*(floor(n.d/((siz.gh[5]/(s.dens*7*Size.d[5,1]))/area.s[i]))) 
+ (tot[6]*kp*ka)*(floor(n.d/((siz.gh[6]/(s.dens*7*Size.d[6,1]))/area.s[i]))) 
+ (tot[7]*kp*ka)*(floor(n.d/((siz.gh[7]/(s.dens*7*Size.d[7,1]))/area.s[i]))) 
- (En.day*n.d))
}


# this gives the lowest energy budget in terms of t.rex body wiegth loss
pp.t.rex.body.p <- c(0,0,0,0)
for (i in 1:(length(area.s))){
pp.t.rex.body.p[i] <- min(days.tot.p[,i])/((7*(10^6))*(M))
}




########### PLOTS ###################

dev.new()
plot(days.bone.p[1:365,1]~n.d[1:365], ylim = c(min(days.bone.p[1:365,]),max(days.bone.p[1:365,])), ylab = "Energy Balance (joules)", xlab = "days", pch = 1,col = "white" , main = "Energy budget of bone scavanging T.rex in Dino Park formation", bty = "l")
lines(days.bone.p[1:365,1]~n.d[1:365], col = "red")
lines(days.bone.p[1:365,2]~n.d[1:365], col = "blue")
lines(days.bone.p[1:365,3]~n.d[1:365], col = "orange")
lines(days.bone.p[1:365,4]~n.d[1:365], col = "green")

abline(0,1,lty = 2, col = "grey15")
abline(-((7*(10^6))*(6000*0.2)),1,lty = 6, col = "grey25" )
legend("topleft", c("36km","18km","7km","3km", "20% body weight"), col = c("green","orange","blue","red","grey25"), lty = c(1,1,1,1,6), bty="n", cex=0.75, title="Search rates")

######for carcass
dev.new()
plot(days.tot.p[1:365,1]~n.d[1:365], ylim = c(min(days.tot.p[1:365,]),max(days.tot.p[1:365,])), ylab = "Energy Balance (joules)", xlab = "days", pch = 1,col = "white" , main = "Energy budget of bone scavanging T.rex", bty = "l")
lines(days.tot.p[1:365,1]~n.d[1:365], col = "red")
lines(days.tot.p[1:365,2]~n.d[1:365], col = "blue")
lines(days.tot.p[1:365,3]~n.d[1:365], col = "orange")
lines(days.tot.p[1:365,4]~n.d[1:365], col = "green")

abline(0,1,lty = 2, col = "grey15")
abline(-((7*(10^6))*(6000*0.2)),1,lty = 6, col = "grey25" )
legend("topleft", c("36km","18km","7km","3km", "20% body weight"), col = c("green","orange","blue","red","grey25"), lty = c(1,1,1,1,6), bty="n", cex=0.75, title="Search rates")







###########################################################################
#################### Try to include competition ###########################
###########################################################################

siz.gt <- c(20.6,58.3,1123,5347) #in this we assume that the 1123 bin represents a sub adult t.rex


#for body size classes
e <- 1.97 #constant for theropods
c <- 100 #constant for herbivors
D <- -0.75#allometric scaling for herbivours
f <- -0.88#allometric scaling for theropods

#this gives the density no/km for both the theropods and herbivors
#Nt <- e*(dino.data[dino.data$guild == "t","mass.categories"]^f)
#Nh <- c*(dino.data[dino.data$guild == "h","mass.categories"]^D)
Nt <- e*(siz.gt^f)
Nh <- c*(siz.gh^D)

#percentage of time searching assumed to be half the day for all carnivors
search.time <- 0.5

#adult dinosaurs mass in kg
M.comp <- siz.gt

#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W)
R <- 0.38*((M.comp)^0.83)

#relationship between M and max speed (v.max) meters/second from Alexander (1977)
v.max <- 8.5*(M.comp^(-0.08))

#Assuming it can maintain 10% of this speed from Bennett & Ruben (1979)
v.s.comp <- 0.1*v.max

#Energy cost of searching behaviour in Watts (W)
S <- 10.3*v.s*(M.comp^0.64)

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
d.comp <- 200
V.comp <- 2*d.comp*v.s.comp

area.comp <- ((V.comp*search.time)*60*60*24)/(1000^2)



s.dens <- 4.38

#Since the rate of energy gathering (E.met) must be positve with E energy extracted from a uniform distribution f with a search rate of V
#i.e energy in E.in = search.time(VfE-S)  must be > E.out = R
#  search.time*V*f*E - search.time*S > R
#  search.time*V*f*E > search.time*S + R
#  E*f > (search.time*S + R)/search.time*V
#  E.min*f = (search.time*S + R)/search.time*V

E.min.f = (search.time*S + R)/search.time*V #in J/meter^2


