t.rex.energy.req <- function(est.type = c("graeme","COT.hip", "COT.muscle.vol"), metabolic.type = c("endo","ecto"), hip.hight = c(264), mass = c(6000), detection.distance = c(200), search.time = c(0.5), bone.energy.content = c(6700000), flesh.energy.content = c(7000000) , carcass.mass.density = c(4.38), theropod.size.bin = c(20.6,58.3,1123,5347), herbivor.size.bin = c(75,216,700,2500,5000,8500,25000), assimilation.effeciency = c(0.75), percent.flesh.available = c(0), competition = c("present", "absent"))
{

	#To scale search area
search.speed.Fr <- c(1,1.6,1.7,1.9,2.5) #these are form Pontzer paper
body.sizes <- c(20,210,430,1400,6000) #these are form Pontzer paper
speed.scal <- glm(log(search.speed.Fr)~log(body.sizes))
s.slop <- speed.scal$coefficients["log(body.sizes)"]
s.int <-  exp(speed.scal$coefficients["(Intercept)"]) #the exponential is as its from the log-log plot

	#to set the amount of resorces available after competition
	if(competition == "present") {
	slope.comp <- 1/10000 #made up
 competativly.available <- mass*slope.comp
	}
	else { competativly.available = c(1)}


try(if(est.type == "graeme" & metabolic.type == "ecto"){
	
#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W). see White 2011 for all 
R.r <- 0.11*(mass^0.76) #Reptiles form White et al 2006, OLS
#R.r <- 0.38*(kM.a^0.83) #Reptiles used by Graeme
#relationship between M and max speed (v.max) meters/second from Alexander (1977)
v.max <- 8.5*(mass^(-0.08))
#v.max <- 20 #this is a crazy assertion from (Bakker 1986, paul 1988,1998)
#v.max <- 11 #this is the max speed given in Hutchinson 2002 nature paper.
#Assuming it can maintain 10% of this speed from Bennett & Ruben (1979)
v.s.r <- 0.1*v.max
#Energy cost of searching behaviour in Watts (W) for ectoderms
S.r <- 10.3*v.s.r*(mass^0.64)
#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
V.r <- 2*detection.distance*v.s.r
daily.area.search <- ((V.r*search.time*60*60*24)/(1000^2))

#total energy expended in watts and joules per day for mammalia based met
energy.consumption.watts <- R.r+search.time*S.r #in Watts
daily.energy.consumption.j <-  energy.consumption.watts*60*60*24 #joules per day
}


else {
	if(est.type == "graeme" & metabolic.type == "endo"){

#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W)
#see White 2011 for all 
R.m <- 4.12*(mass^0.69) #Mammals from White et al 2009 (uses PGLS)

#relationship between M and max speed (v.max) meters/second from Alexander (1977)
v.max <- 8.5*(mass^(-0.08))
#v.max <- 20 #this is a crazy assertion from (Bakker 1986, paul 1988,1998)
#v.max <- 11 #this is the max speed given in Hutchinson 2002 nature paper.
#Assuming a mammal can maintain 50% of this speed from Bennett & Ruben (1979)
v.s.m <- 0.5*v.max
#Energy cost of searching behaviour in Watts (W) for mammals
S.m <- 10.7*v.s.m*(mass^0.68)
#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
V <- 2*detection.distance*v.s.m
daily.area.search <- ((V*search.time*60*60*24)/(1000^2))

#total energy expended in watts and joules per day for mammalia based met
energy.consumption.watts <- R.m+search.time*S.m #in Watts
daily.energy.consumption.j <-  energy.consumption.watts*60*60*24 #joules per day
}

else {
	if(est.type == "COT.hip"){
		#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W) #see White 2011 for all 

R.m <- 4.12*(mass^0.69) #Mammals from White et al 2009 (uses PGLS)
#based on the walking speed used by P
#walking.speed <- 2.5 #meters/second
#hip.hight <- 264 #hip hight in cm taken from ---

#cost of transport in J for a kg of mass over 1 meter.
walking.speed <- (s.int*((mass)^s.slop))
Cot <- 90.284*(hip.hight^(-0.77)) #khip in cm
S.p <- (Cot*mass)*walking.speed #cost of whole animal to search in Watts

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
V.p <- 2*detection.distance*walking.speed #search rate in meters^squared per second
daily.area.search <- ((V.p*search.time*60*60*24)/(1000^2)) #area (km^2) searched in a day


#total energy expended in watts and joules per day for mammalia based met
energy.consumption.watts <- R.m+search.time*S.p #in Watts
daily.energy.consumption.j <-  energy.consumption.watts*60*60*24 #joules per day	
}	


else{
	if(est.type == "COT.muscle.vol"){
		
#Basal metabolic rate based on reptiles scaling from Schmidt-Nielson(1984) in Watts (W)
#see White 2011 for all 
R.m <- 4.12*(mass^0.69) #Mammals from White et al 2009 (uses PGLS)

#based on the walking speed used by P
#v.s.v <- 2.5 #meters/second
#khip <- 264 #hip hight in cm taken from Pontzer et al 2009.

walking.speed <- (s.int*((mass)^s.slop))
#cost of transport in J for a kg of mass over 1 meter.
V.musc <- 44.1 # V.musc cm3 kg-1m-1
Cot.v <- (0.0029*(V.musc) + 0.0598)*20.1
S.v <- (Cot.v*mass)*walking.speed #cost of whole animal to search in Watts

#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
V.v <- 2*detection.distance*walking.speed #search rate in meters^squared per second
daily.area.search <- ((V.v*search.time*60*60*24)/(1000^2)) #area (km^2) searched in a day


#total energy expended in watts and joules per day for mammalia based met
energy.consumption.watts <- R.m+search.time*S.v #in Watts
daily.energy.consumption.j <-  energy.consumption.watts*60*60*24 #joules per day
}
}}}, silent = TRUE)




#calculate the amount of that production is bone from Prange et al 1979
#bon.m.h <-  0.061*(siz.gh^1.071) #scaling for bone allometry for birds
bone.mass.herbivors <-  0.065*(herbivor.size.bin^1.09)# from mammal scaling 
#with flesh making up the differnce
flesh.mass.herbivours <- herbivor.size.bin - bone.mass.herbivors
bone.energy.herbivours <-  bone.mass.herbivors*bone.energy.content
flesh.energy.herbivours <-  flesh.mass.herbivours*flesh.energy.content

energy.balance.day.j <- sum((((bone.energy.herbivours + (flesh.energy.herbivours*percent.flesh.available))*competativly.available)*assimilation.effeciency)*(daily.area.search/(herbivor.size.bin/carcass.mass.density))) - daily.energy.consumption.j

dect.dist.for.positive.eng <- (daily.energy.consumption.j/(sum(((bone.energy.herbivours + (flesh.energy.herbivours*percent.flesh.available))*competativly.available)*assimilation.effeciency*(carcass.mass.density/herbivor.size.bin))))/(2*2.5*0.5*60*60*24/(1000^2)) # the last section devison (i.e. (/(2*2.5*0.5*60*60*24/(1000^2)))) is to convert it into a funcvtion of distance as opposed to area searched.



return(data.frame(daily.area.search, energy.consumption.watts, dect.dist.for.positive.eng, daily.energy.consumption.j, energy.balance.day.j))
}

##############----------------------end--------------------------##############