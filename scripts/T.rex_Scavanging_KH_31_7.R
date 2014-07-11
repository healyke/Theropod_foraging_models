####--------------------T.rex scavanging paper-----------------------------###
####------------------------analytical models-----------------------------###

#29 july 2013
#Kevin Healy

rm(list=ls())
graphics.off()


####-----------------------------------------------------------------------###
####--------------------Energetics of t.rex seraching----------------------###
####-----------------------------------------------------------------------###

#########----------------------basic coeficents-----------------#############


search.time <- 0.5 #percentage of time searching assumed to be half the day
s.dens.neo <- 1.6 #the density of caracasses in the Serengeti in kg/km2/day
s.dens <- 4.38 #the density of caracasses in the Serengeti in kg/km2/day
kM.a <- 6000 #adult dinosaurs mass in kg
k.En.bone <- 6.7*1000*1000 #j/kg #from 6.7kJ/g based on the average from vultures food
k.En.bone.l <- 2*1000*1000 #j/kg #from 6.7kJ/g based on the average from vultures food

#the size bins used  by Carbone et al
#dino.data <- read.csv("Carbone.dino.size.csv")
siz.gt <- c(20.6,58.3,1123,5347)
siz.gh <- c(75,216,700,2500,5000,8500,25000)

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


#to calculate the energy content of each individual
#bone content
#Check that the energy conversion is ok
indivdual.bone.en <-  bon.m.h*6.7*(10^6) #j #from 6.7(10^6)/kg
indivdual.bone.en.l <-  bon.m.h*2*(10^6) #j #from 6.7(10^6)/kg
indivdual.flesh.en <-  flesh.m.h*7*(10^6) #j #from 7(10^6)J/kg
#then ther enrgy available from bone per km/day is



#for body size classes based on scaling
e <- 1.97 #constant for theropods
c <- 100 #constant for herbivors
D <- -0.75#allometric scaling for herbivours
f <- -0.88#allometric scaling for theropods

#this gives the density no/km for both the theropods and herbivors
#Nt <- e*(dino.data[dino.data$guild == "t","mass.categories"]^f)
#Nh <- c*(dino.data[dino.data$guild == "h","mass.categories"]^D)
Nt <- e*(siz.gt^f)
Nh <- c*(siz.gh^D)



######Next reach rates and the cost of a t.rex needs to be calulated#######



##############------------------Ectoterm model------------------##############
##############--------------------------------------------------##############
#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W)
#see White 2011 for all 
R.r <- 0.11*(kM.a^0.76) #Reptiles form White et al 2006, OLS
#R.r <- 0.38*(kM.a^0.83) #Reptiles used by Graeme

#relationship between M and max speed (v.max) meters/second from Alexander (1977)
v.max <- 8.5*(kM.a^(-0.08))
#v.max <- 20 #this is a crazy assertion from (Bakker 1986, paul 1988,1998)
#v.max <- 11 #this is the max speed given in Hutchinson 2002 nature paper.

#Assuming it can maintain 10% of this speed from Bennett & Ruben (1979)
v.s.r <- 0.1*v.max

#Energy cost of searching behaviour in Watts (W) for ectoderms
S.r <- 10.3*v.s.r*(kM.a^0.64)

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
d <- 200
V.r <- 2*d*v.s.r

#total energy expended in watts and joules per day for mammalia based met
T.en.out.r <- R.r+search.time*S.r #in Watts
En.day.r <-  T.en.out.r*60*60*24 #joules per day


#Since the rate of energy gathering (E.met) must be positve with E energy extracted from a uniform distribution f with a search rate of V
#i.e energy in E.in = search.time(VfE-S)  must be > E.out = R
#  search.time*V*f*E - search.time*S > R
#  search.time*V*f*E > search.time*S + R
#  E*f > (search.time*S + R)/search.time*V
#  E.min*f = (search.time*S + R)/search.time*V
E.min.r <- (search.time*S.r + R.r)/search.time*V.r #in J/meter^2

##############----------------------end--------------------------##############


##############------------------Endoterm model------------------##############
##############----------------------Mammal----------------------##############
#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W)
#see White 2011 for all 
R.m <- 4.12*(kM.a^0.69) #Mammals from White et al 2009 (uses PGLS)

#relationship between M and max speed (v.max) meters/second from Alexander (1977)
v.max <- 8.5*(kM.a^(-0.08))
#v.max <- 20 #this is a crazy assertion from (Bakker 1986, paul 1988,1998)
#v.max <- 11 #this is the max speed given in Hutchinson 2002 nature paper.

#Assuming a mammal can maintain 50% of this speed from Bennett & Ruben (1979)
v.s.m <- 0.5*v.max

#Energy cost of searching behaviour in Watts (W) for mammals
S.m <- 10.7*v.s.m*(kM.a^0.68)

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
d <- 200
V <- 2*d*v.s.m


#total energy expended in watts and joules per day for mammalia based met
T.en.out.m <- R.m+search.time*S.m #in Watts
En.day.m <-  T.en.out.m*60*60*24 #joules per day

##############----------------------end--------------------------##############


##############------------------Endoterm model------------------##############
##############----------------------Avian----------------------##############
#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W)
#see White 2011 for all
R.a <- 3.83*(kM.a^0.744) #Aves from McKechnie et al 2006 (wild birds PGLS) #see White 2011/.
#R.a <- 6.97*(kM.a^0.66) #Aves from Makarieva et al 2008 #see White 2011/.
#R.a <- 5.67*(kM.a^0.67) #Aves from McKechnie et al 2006 (captive birds PGLS) #see White 2011/.

#relationship between M and max speed (v.max) meters/second from Alexander (1977)
v.max <- 8.5*(kM.a^(-0.08))#Assuming it can maintain 50% of this speed like a mammal from Bennett & Ruben (1979)
#v.max <- 20 #this is a crazy assertion from (Bakker 1986, paul 1988,1998)
#v.max <- 11 #this is the max speed given in Hutchinson 2002 nature paper.

v.s.a <- 0.5*v.max

#Energy cost of searching behaviour in Watts (W) for ectoderms
S.a <- 10.3*v.s.r*(kM.a^0.64)

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
d <- 200
V <- 2*d*v.s.a

#total energy expended in watts and joules per day for mammalia based met
T.en.out.a <- R.m+search.time*S.a #in Watts
En.day.a <-  T.en.out.a*60*60*24 #joules per day
##############----------------------end--------------------------##############



##############------------------Endoterm model------------------##############
##############----------------P/mammal----------------##############

#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W)
#see White 2011 for all 
R.m <- 4.12*(kM.a^0.69) #Mammals from White et al 2009 (uses PGLS)

#based on the walking speed used by P
v.s.p <- 2.5 #meters/second

khip <- 264 #hip hight in cm taken from ---

#cost of transport in J for a kg of mass over 1 meter.
Cot <- 90.284*(khip^(-0.77)) #khip in cm
S.p <- (Cot*kM.a)*v.s.p #cost of whole animal to search in Watts

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
d <- 200
V.p <- 2*d*v.s.p #search rate in meters^squared per second
area.s.p <- ((V.p*search.time*60*60*24)/(1000^2)) #area (km^2) searched in a day


#total energy expended in watts and joules per day for mammalia based met
T.en.out.p <- R.m+search.time*S.p #in Watts
En.day.p <-  T.en.out.p*60*60*24 #joules per day



##############----------------------end--------------------------##############

##############------------------Endoterm model------------------##############
##############----------------V/mammal----------------##############

#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W)
#see White 2011 for all 
R.m <- 4.12*(kM.a^0.69) #Mammals from White et al 2009 (uses PGLS)

#based on the walking speed used by P
v.s.v <- 2.5 #meters/second

khip <- 264 #hip hight in cm taken from Pontzer et al 2009.

#cost of transport in J for a kg of mass over 1 meter.
V.musc <- 44.1 # V.musc cm3 kg-1m-1
Cot.v <- (0.0029*(V.musc) + 0.0598)*20.1 #khip in cm
S.v <- (Cot.v*kM.a)*v.s.v #cost of whole animal to search in Watts

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
d <- 200
V.v <- 2*d*v.s.v #search rate in meters^squared per second
area.s.v <- ((V.v*search.time*60*60*24)/(1000^2)) #area (km^2) searched in a day


#total energy expended in watts and joules per day for mammalia based met
T.en.out.v <- R.m+search.time*S.v #in Watts
En.day.v <-  T.en.out.v*60*60*24 #joules per day



##############--------------------------------------------------##############
##############-----------------------end------------------------##############
##############--------------------------------------------------##############



####--To calculate the length of time fasting without food based on fat reserves--####



#to calulate the amount of fat reserves available to a t.rex using mamma fat reserves in Lindstedt and Boyce 1985, scaling of ---- using Schmidt-Nielsen 1979 energy content of fat as 39.3kJ/day/g.

En.day <- c(En.day.r,En.day.m,En.day.a,En.day.p,En.day.v)

kfat.e <- 39.3*1000*1000 # this is j/kg

Energy.res <- kfat.e*0.075*(kM.a^1.19)

days.fasting <- Energy.res/En.day

##############----------------------end--------------------------##############
##############--------------------------------------------------##############






##############--------------Putting both energy content---------------##############
##############----------------and cost models together----------------##############


##############------------------Endoterm model------------------##############
##############---------------------P/mammal---------------------##############


#no of individual of each size class it would have crossed in that a day
d <- seq(50,2000,10)

V.p <- 2*d*v.s.p

area.s.p <- ((V.p*search.time*60*60*24)/(1000^2)) #area searched in a day
ka <- 0.75 #assimilation effeciancy
# to get the average no pf days between each carcass

#days.to.car.p <- matrix(0, ncol = length(siz.gh), nrow = length(area.s.p), dimnames = list(area.s.p,siz.gh))
#for (i in 1:(length(area.s.p))){
#days.to.car.p[i, ] <- ((siz.gh[]/(s.dens))/area.s.p[i])
#}


# the energy balance over time with bones and Carbone in a stochastic manner.
#n.d <- seq(0,1000,1)
#En.bal.s_p <- matrix(0,nrow = (length(n.d)), ncol = (length(area.s.p)), dimnames = list(n.d,area.s.p))
#for(i in 1:(length(area.s.p))){
#days.bone.p[,i] <-  ((indivdual.bone.en[1]*ka)*(floor(n.d/((siz.gh[1]/(s.dens))/area.s.p[i]))) 
#+ (indivdual.bone.en[2]*ka)*(floor(n.d/((siz.gh[2]/(s.dens))/area.s.p[i]))) 
#+ (indivdual.bone.en[3]*ka)*(floor(n.d/((siz.gh[3]/(s.dens))/area.s.p[i])))
#+ (indivdual.bone.en[4]*ka)*(floor(n.d/((siz.gh[4]/(s.dens))/area.s.p[i]))) 
#+ (indivdual.bone.en[5]*ka)*(floor(n.d/((siz.gh[5]/(s.dens))/area.s.p[i]))) 
#+ (indivdual.bone.en[6]*ka)*(floor(n.d/((siz.gh[6]/(s.dens))/area.s.p[i]))) 
#+ (indivdual.bone.en[7]*ka)*(floor(n.d/((siz.gh[7]/(s.dens))/area.s.p[i]))) 
#- (En.day.p*n.d))
#}


##############------------------Endoterm model------------------##############
##############---------------------Analytical-------------------##############




#no of individual of each size class it would have crossed in that a day
d <- seq(50,2000,10)

V.p <- 2*d*v.s.p

area.s.p <- ((V.p*search.time*60*60*24)/(1000^2)) #area searched in a day
ka <- 0.75 #assimilation effeciancy
# to get the average no pf days between each carcass




##############-----------------high bone energy-----------------##############

##############-----------------Pontzer hip energy-----------------##############
# the energy balance over time with bones and Carbone in a analytical manner. (This is the average enregy balance over a single day)
En.bal.an_ph <- matrix(0,nrow = c(1), ncol = (length(area.s.p)), dimnames = list(c(1),d))
for(i in 1:(length(area.s.p[]))){
En.bal.an_ph[,i] <- sum((indivdual.bone.en[]*ka)*(area.s.p[i]/(siz.gh[]/s.dens)))- En.day.p
}


##############-----------------Pontzer muscle energy-----------------##############
# the energy balance over time with bones and Carbone in a analytical manner. (This is the average enregy balance overa single day)
En.bal.an_vh <- matrix(0,nrow = c(1), ncol = (length(area.s.p)), dimnames = list(c(1),d))
for(i in 1:(length(area.s.p[]))){
En.bal.an_vh[,i] <- sum((indivdual.bone.en[]*ka)*(area.s.p[i]/(siz.gh[]/s.dens)))- En.day.v
}


##############-----------------low bone energy-----------------##############

##############-----------------Pontzer hip energy-----------------##############
# the energy balance over time with bones and Carbone in a analytical manner. (This is the average enregy balance overa single day)
En.bal.an_pl <- matrix(0,nrow = c(1), ncol = (length(area.s.p)), dimnames = list(c(1),d))
for(i in 1:(length(area.s.p[]))){
En.bal.an_pl[,i] <- sum((indivdual.bone.en.l[]*ka)*(area.s.p[i]/(siz.gh[]/s.dens)))- En.day.p
}

##############-----------------Pontzer muscle energy-----------------##############
# the energy balance over time with bones and Carbone in a analytical manner. (This is the average enregy balance overa single day)
En.bal.an_vl <- matrix(0,nrow = c(1), ncol = (length(area.s.p)), dimnames = list(c(1),d))
for(i in 1:(length(area.s.p[]))){
En.bal.an_vl[,i] <- sum((indivdual.bone.en.l[]*ka)*(area.s.p[i]/(siz.gh[]/s.dens)))- En.day.v
}



###the detection distance nessacary for positive enregy balance

##############-----------------high bone energy-----------------##############
dect_boneh_cot_l <- (En.day.p/(sum(indivdual.bone.en[]*ka*(s.dens/siz.gh[]))))/(2*2.5*0.5*60*60*24/(1000^2)) # the last section devison (i.e. (/(2*2.5*0.5*60*60*24/(1000^2)))) is to convert it into a funcvtion of distance as opposed to area searched.

##############-----------------high bone energy-----------------##############
dect_bonel_cot_l <- (En.day.p/(sum(indivdual.bone.en.l[]*ka*(s.dens/siz.gh[]))))/(2*2.5*0.5*60*60*24/(1000^2))

##############-----------------high bone energy-----------------##############
dect_boneh_cot_h <- (En.day.v/(sum(indivdual.bone.en[]*ka*(s.dens/siz.gh[]))))/(2*2.5*0.5*60*60*24/(1000^2))

##############-----------------high bone energy-----------------##############
dect_bonel_cot_h <- (En.day.v/(sum(indivdual.bone.en.l[]*ka*(s.dens/siz.gh[]))))/(2*2.5*0.5*60*60*24/(1000^2))





##############--------------------------------------------------#####
##############------------------Ectoterm model------------------##############
##############--------------------------------------------------##############

##############--------------------------------------------------##############
##############---------------------Analytical-------------------##############
##############--------------------------------------------------##############



#no of individual of each size class it would have crossed in that a day
d <- seq(50,2000,10)

V.r <- 2*d*v.s.r

area.s.r <- ((V.r*search.time*60*60*24)/(1000^2)) #area searched in a day
ka <- 0.75 #assimilation effeciancy
# to get the average no pf days between each carcass

##############-----------------high bone energy-----------------##############

##############-----------------Reptile---------------------------##############
# the energy balance over time with bones and Carbone in a analytical manner. (This is the average enregy balance over a single day)
En.bal.an_rh <- matrix(0,nrow = c(1), ncol = (length(area.s.r)), dimnames = list(c(1),d))
for(i in 1:(length(area.s.r[]))){
En.bal.an_rh[,i] <- sum((indivdual.bone.en[]*ka)*(area.s.r[i]/(siz.gh[]/s.dens)))- En.day.r
}



##############------------------Ectoterm model------------------##############
##############--------------------------------------------------##############


###the detection distance nessacary for positive enregy balance

##############-----------------high bone energy-----------------##############
dect_bone_r_h <- (En.day.r/(sum(indivdual.bone.en[]*ka*(s.dens/siz.gh[]))))/(2*2.5*0.5*60*60*24/(1000^2)) # the last section devison (i.e. (/(2*2.5*0.5*60*60*24/(1000^2)))) is to convert it into a funcvtion of distance as opposed to area searched.

##############-----------------high bone energy-----------------##############
dect_bone_r_l <- (En.day.r/(sum(indivdual.bone.en.l[]*ka*(s.dens/siz.gh[]))))/(2*2.5*0.5*60*60*24/(1000^2))


##############--------------------------------------------------##############
##############--------------------End---------------------------##############
##############--------------------------------------------------##############







##############-------------------Under construction-------------##############

##############--------------------------------------------------##############
##############-----------Including competition------------------#################
##############--------------------------------------------------##############
#Calulate the number of competors bigger then a body size then caculate the probability that it arrive first####


#for body size classes based on scaling
e <- 1.97 #constant for theropods
c <- 100 #constant for herbivors
D <- -0.75#allometric scaling for herbivours
f <- -0.88#allometric scaling for theropods

#this gives the density no/km for both the theropods and herbivors
#Nt <- e*(dino.data[dino.data$guild == "t","mass.categories"]^f)
#Nh <- c*(dino.data[dino.data$guild == "h","mass.categories"]^D)
mass.range <- seq(10,6000,10)
Nt <- e*(siz.gt^f)
Nh <- c*(siz.gh^D)

#to get the number of predators in a area we get the integral of equation above
#Nt(x) = 1.97size.gt^-0.88
#Nt(d)dx = 16.41666666666667x^0.12 
#using the bounds of 20.1 and 6000 for x on the above Nt(d)dx = 16.41666666666667x^0.12  = 23.02774155784116
No.ther <- 23 #number of theropds of the size range above per km^2

#to get the number of predators in a area we get the integral of equation above
ther.den <- function(size.gt){
	1.97*size.gt^-0.88
}
lower.size <- siz.gt
no.ther <- matrix(0,ncol=1,nrow=(length(lower.size)))
for(i in 1:(length(lower.size))){
no.ther[i] <- integrate(ther.den,lower.size[i],6000)[1]
}
no.ther <- as.matrix(no.ther)

#####calculating the scaling search rate. (how does carbone change the detection rate)
#### to calulate the search speed

#figure out how to calulate these properly
search.speed.Fr <- c(1,1.6,1.7,1.9,2.5)
body.sizes <- c(20,210,430,1400,6000) #these are form Pontzer paper
speed.scal <- glm(log(search.speed.Fr)~log(body.sizes))
s.slop <- speed.scal$coefficients["log(body.sizes)"]
s.int <-  exp(speed.scal$coefficients["(Intercept)"]) #the exponential is as its from the log-log plot

#so scaling of speed is s.int*Mass^s.slope
speed.th <- s.int*(siz.gt^s.slop) #meters per second



#assuming that the scaling of bulb size and actual acuity scale near isometry (1 to 1 in relative terms)
#we put the t.rex detection distance and scale down.
d.a <- 200 #detection distance of adult t.rex

dect.slop <- 0.1237 #from Zelenitsky et al 2009 paper
dect.int <- d.a/(kM.a^dect.slop) #from dect.int*(kM.a^dect.slop) = adult detection distance
dect.dist <- dect.int*(siz.gt^dect.slop) #in meters

#putting these together then gives the search rate for each group.
search.area <- ((dect.dist)*(speed.th*((search.time*2)*60*60*24)))/(1000^2)


#how long it takes each group takes to get to each carcass.
days.to.car <- matrix(0, ncol = length(siz.gh), nrow = length(search.area), dimnames = list(search.area,siz.gh))
for (i in 1:(length(search.area))){
days.to.car[i, ] <- ((siz.gh[]/(s.dens))/search.area[i])
}

#average time it takes for an adult t.rex to find each size of carcass.
average.time.t.rex <- days.to.car[4,]

no.days <- seq(0.1,7,0.1)
#the average amount of consumers at a carcass after 3.5 days (the avrage time the carcass would be there before being found)
   aver.amount.con <- matrix(0,ncol= (length(Nt)), nrow =length(no.days))
 for(i in 1:(length(Nt))){
 	for(j in 1:(length(no.days))){
 aver.amount.con[j,i] <- ((Nt[i])*search.area[i])*no.days[j]
}
}

#need to calulate the percentage of time a bigger individual turns up beforehand for a given mass.
#for smallest it the percentage of time something else turns up first.




######juvinil t.rex of say half a tonn#####

Mj <- seq(20,10000,1)

##############------------------Endoterm model------------------##############
##############----------------P/mammal----------------##############

#Basal metabolic rate based on mammals
#see White 2011 for all 
R.mj <- 4.12*(Mj^0.69) #Mammals from White et al 2009 (uses PGLS)

#based on the walking speed used by P
speed.j <- s.int*(Mj^s.slop) #meters per second

#for now I am assuming that the hip hight of all theropods scales the same ie a velocirator can be used for juvinle t.rex
khip <- c(42,100,116,149,264) #hip hight in cm taken from ---
khip.mass <-c(20,210,430,1400,6000)

hip.scal <- glm(log(khip)~log(khip.mass))
hip.slop <- hip.scal$coefficients["log(khip.mass)"]
hip.int <-  exp(hip.scal$coefficients["(Intercept)"]) #the exponential is as its from the log-log plot

#so scaling of hip is hip.int*Mass^hip.slope
hip.th <- hip.int*(Mj^hip.slop)


#cost of transport in J for a kg of mass over 1 meter.
Cot.j <- 90.284*(hip.th^(-0.77)) #khip in cm
S.pj <- matrix(0,nrow = length(Mj),ncol = 1)
for(i in 1:(length(Mj))){
S.pj[i] <- (Cot.j[i]*Mj[i])*speed.j[i] #cost of whole animal to search in Watts
}

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
dj <- c(80,200,500,1000)
V.j <- matrix(0, nrow=length(speed.j), ncol=length(dj))
area.s.j <- matrix(0, nrow=length(speed.j), ncol=length(dj))
for(i in 1:(length(dj))){
V.j[,i] <- 2*dj[i]*speed.j #search rate in meters^squared per second
area.s.j[,i] <- ((V.j[,i]*search.time*60*60*24)/(1000^2)) #area (km^2) searched in a day
}

#total energy expended in watts and joules per day for mammalia based met
T.en.out.j <- R.mj+search.time*S.pj #in Watts
En.day.j <-  T.en.out.j*60*60*24 #joules per day



##############----------------------end--------------------------##############

area.s.p <- ((V.p*search.time*60*60*24)/(1000^2)) #area searched in a day
ka <- 0.75 #assimilation effeciancy
# to get the average no pf days between each carcass




##############-----------------high bone energy-----------------##############

##############-----------------Pontzer hip energy-----------------##############
# the energy balance with bones and Carbone in a analytical manner. (This is the average enregy balance over a single day)
En.bal.bones_jh <- matrix(0,ncol = c(length(area.s.j[1,])), nrow = (length(En.day.j)), dimnames=list(c(seq(1:(length(area.s.j[,1])))),print(dj)))
for(i in 1:(length(En.day.j[]))){
	for(j in 1:(length(area.s.j[1,]))){
En.bal.bones_jh[i,j] <- sum((indivdual.bone.en[]*ka)*(area.s.j[i,j]/(siz.gh[]/s.dens)))- En.day.j[i]
}}
#convert it to Watts i.e joules per second
En.bal.bones_jh <-  En.bal.bones_jh/(24*60*60)

###plot this out as the energy balance for non competative scavanging of just bones
plot(En.bal.bones_jh[,1]~Mj, xlab = "Body Mass (kg)", ylab = "Energy budget (W)", main = "Energy balance for non-competative scavanging of carcass bones", bty = "L" , col="black", type="l", lty=1, lwd=2, ylim=c(min(En.bal.bones_jh[]),max(En.bal.bones_jh[])))
lines(En.bal.bones_jh[,2]~Mj, col="grey10", type="l", lty=1, lwd=2)
lines(En.bal.bones_jh[,3]~Mj, col="grey30", type="l", lty=1, lwd=2)
lines(En.bal.bones_jh[,4]~Mj, col="grey60", type="l", lty=1, lwd=2)
abline(0,0,lty=2,lwd=2,col="lightgrey")


#need to calulate the percentage of time a bigger individual turns up beforehand for a given mass.
#for smallest it the percentage of time something else turns up first.

#to get the number of predators in a area we get the integral of equation above
ther.at.car.per.day <- function(size.gt){
	2.4568*size.gt^-0.9874
}
lower.size <- siz.gt
no.bigger.each.day <- matrix(0,ncol=1,nrow=(length(lower.size)))

for(i in 1:(length(lower.size))){
no.bigger.each.day[i] <- integrate(ther.at.car.per.day,lower.size[i],10000)[1]
}
no.bigger.each.day <- as.numeric(no.bigger.each.day) #numbers bigger then you at the end of one day
percent.time.bigger <- (24/no.bigger.each.day)/(24*7) #as the carcasses are asummed to last 7 days.



#from the percentage of time and fitting with a spline for now the amount available 
#avail <- spline(((24/no.bigger.each.day)/(24*7)~(siz.gt)),n=(length(Mj)))$y

present.8.days <- c(7,1,0,0)
present.80.days <- c(75,10,0,0)
present.500.days <- c(500,100,9,0)
present.1100.days <- c(1000,500,50,1)

#per day
present.8.days.d <- present.8.days/8
present.80.days.d <- present.80.days/80
present.500.days.d <- present.500.days/500
present.1100.days.d <- present.1100.days/1100

#this needs to change to the amount of time another bigger group is there
pres.bigger <- c(sum(present.1100.days.d[1:4]),sum(present.1100.days.d[2:4]),sum(present.1100.days.d[3:4]),sum(present.1100.days.d[4]))


#On average each dino is outcompeted one in x many days below
how.many.days.average.avail/24 <- 1/pres.bigger
#what percent of 7 days is this
percent.avail <- pres.bigger/7

avail <- glm((percent.avail)~log(siz.gt))
avail.slop <- avail$coefficients["log(siz.gt)"]
avail.int <-  exp(avail$coefficients["(Intercept)"]) #the exponential is as its from the log-log plot

YY.log <- log(Mj)*avail.slop + avail.int #this is crap enough the spline isnt working!
YY.lin <- seq(0,1,1/length(Mj))
YY.exp <- exp(seq(-1,0,1/length(Mj[1:9980])))


#i did this manually I know its right but go over it again
percent.avail <- c(0.1013171,0.2851957,(1-0.0463636364),(1-0.0009090909)) 
avail <- spline(percent.avail~siz.gt,n=(length(Mj)))$y
#I manualy found when it went over 100 percent available as its a spline

#the energy balance over time with bones and Carbone in a analytical manner. (This is the average enregy balance over a single day)
En.bal.an_jh_avail <- matrix(0,ncol = c(1), nrow = (length(En.day.j)))
for(i in 1:(length(En.day.j[]))){
En.bal.an_jh_avail[i,] <- sum((avail[i]*(indivdual.bone.en[]+indivdual.flesh.en[])*ka)*(area.s.j[i]/(siz.gh[]/s.dens)))- En.day.j[i]
}

#convert it to Watts i.e joules per second
En.bal.avil.sec <-  En.bal.an_jh_avail/(24*60*60)
En.bal.an_sec <- En.bal.an_jh/(24*60*60)
#plot competition on full carcasses
plot(En.bal.avil.sec~Mj, xlab = "Body Mass (kg)", ylab = "Energy budget (W)", main = "Energy balance with mass with carcass competition for theropods", bty = "L", ylim = c(-10000,25000) , col="royalblue2", type="l", lty=1, lwd=2)
lines(En.bal.an_jh~Mj, col="darkred", type="l", lty=1, lwd=2)

plot(En.bal.an_sec~Mj, xlab = "Body Mass (kg)", ylab = "Energy budget (W)", main = "Energy balance with mass with no carcass competition for theropods", bty = "L", ylim = c(-10000,25000) , col="darkred", type="l", lty=1, lwd=2)
lines(En.bal.an_jh~Mj, col="darkred", type="l", lty=1, lwd=2)

