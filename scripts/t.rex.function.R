#functions for t.rex scavanging model
#Kevin Healy 11 March 2014



fasting.ability <- function(mass,En.cost.per.day,kfat.energy = c(39.3*1000*1000))
	{

		#kfat.energy <- 39.3*1000*1000 # this is j/kg of fat reserves
		Energy.in.reserves <- kfat.energy*0.075*(body.mass^1.19) #I'm not sure were this scaling equation comes from find it and include reference.
		fasting.abilty.days <- Energy.in.reserves/En.cost.per.day
		
		return(data.frame(Energy.in.reserves,fasting.abilty.days))
	}



#To scale area serched. This scaling is one of the talking points with john.

area.searched <- function(mass, detection.distance, search.time =c(0.5), theropod.body.sizes = c(0.25,1.2,3,20,20,210,430,1400,6000),hip.hight = c(13,24,15,44,42,100,116,149,264),froude.no = c(0.25))
	{

							speed.fr <- sqrt(froude.no*(hip.hight/100)*9.81) #hip.hiegth in meters
							speed.scal <- glm(log(speed.fr)~log(theropod.body.sizes))
							s.slop <- speed.scal$coefficients["log(theropod.body.sizes)"]
							s.int <-  exp(speed.scal$coefficients["(Intercept)"])

							walking.speed <- (s.int*((mass)^s.slop))

							#To get a search rate its given by detaction distance d by v.s in meters^2/second searched
							meter.scanned.per.sec <- 2*detection.distance*walking.speed #search rate in meters^squared per second
							daily.km2.search <- ((meter.scanned.per.sec*search.time*60*60*24)/(1000^2)) #area (km^2) searched in a day

return(data.frame(walking.speed, meter.scanned.per.sec,daily.km2.search))
	}
	


#Using Graems model to calulate energy expenditor
gram.energy.exp <- function(mass, walking.speed, metabolic.type = c("ecto","endo","meso"), search.time = c(0.5))
{
	if(metabolic.type == "ecto")
		{
		resting.metabolic.rate <- 0.11*(mass^0.76) #baesed on reptiles


		Searching.energy.cost.W <- 10.3*walking.speed*(mass^0.64)

		Tot.energy.consumption.watts <- resting.metabolic.rate + search.time*Searching.energy.cost.W
		Tot.daily.energy.consumption.j <-  Tot.energy.consumption.watts*60*60*24 #joules per day
		}


		else {
			if(metabolic.type == "endo")
				{
					resting.metabolic.rate <- 4.12*(mass^0.69) #Mammals from White et al 2009 (uses PGLS)

					Searching.energy.cost.W <- 10.7*walking.speed*(mass^0.68)

					Tot.energy.consumption.watts <- resting.metabolic.rate + search.time*Searching.energy.cost.W
					Tot.daily.energy.consumption.j <-  Tot.energy.consumption.watts*60*60*24 #joules per day
				}
				else {
					if(metabolic.type == "meso")
				{
					
					resting.metabolic.rate <- 0.0020*(mass^0.82) #baesed on new science paper
					Searching.energy.cost.W <- 10.7*walking.speed*(mass^0.68)

					Tot.energy.consumption.watts <- resting.metabolic.rate + search.time*Searching.energy.cost.W
					Tot.daily.energy.consumption.j <-  Tot.energy.consumption.watts*60*60*24 #joules per day
				}
				

				}
			}
return(data.frame(resting.metabolic.rate, Searching.energy.cost.W, Tot.daily.energy.consumption.j))
}




#Using pontzers model to calulate energy expenditure

pontz.energy.exp <- function(mass, walking.speed, est.type = c("hip","muscle"), hip.hight = c(42,100,116,149,264), V.musc = c(44.1), search.time = c(0.5), theropod.body.sizes = c(20,210,430,1400,6000))
{
	if(est.type == "hip")
		{
		resting.metabolic.rate <-0.0020*(mass^ 0.82) #baesed on OLS in science paper for all dinos
		#need an equation of mass hip higth scaling.
		
		cot.hip.scal <- glm(log(hip.hight)~log(theropod.body.sizes))
							hip.slop <- cot.hip.scal$coefficients["log(theropod.body.sizes)"]
							hip.int <-  exp(cot.hip.scal$coefficients["(Intercept)"])

							cost.hip <- (hip.int*((mass)^hip.slop))
							
		cost.of.transport <-  90.284*(cost.hip^(-0.77)) 
		Searching.energy.cost.W <-  (cost.of.transport*mass)*walking.speed

		Tot.energy.consumption.watts <- resting.metabolic.rate + search.time*Searching.energy.cost.W
		Tot.daily.energy.consumption.j <-  Tot.energy.consumption.watts*60*60*24 #joules per day
		}


		else {
			if(est.type == "muscle")
				{
					resting.metabolic.rate <- 0.0020**(mass^0.82) #Mammals from White et al 2009 (uses PGLS)
					
					
					cost.of.transport <- (0.0029*(V.musc) + 0.0598)*20.1
					Searching.energy.cost.W <- (cost.of.transport*mass)*walking.speed #cost of whole animal to search in Watts
					
					Tot.energy.consumption.watts <- resting.metabolic.rate + search.time*Searching.energy.cost.W
					Tot.daily.energy.consumption.j <-  Tot.energy.consumption.watts*60*60*24 #joules per day
				}
			}
return(data.frame(resting.metabolic.rate, Searching.energy.cost.W, Tot.daily.energy.consumption.j))
}


#function to calulate the enrgy available in the envirnment.

energy.available <- function(bone.energy.content = c(6700000), flesh.energy.content = c(7000000), herbivor.size.bin = c(75,216,700,2500,5000,8500,25000), percent.flesh.available = c(0), assimilation.effeciency = c(0.75), competativly.available = c(1), carcass.mass.density = c(4.38), number.day.carcass.available = c(7))
		{
	
		bone.mass.herbivors <-  0.065*(herbivor.size.bin^1.09)# from mammal scaling 
		flesh.mass.herbivours <- herbivor.size.bin - bone.mass.herbivors
		
		bone.energy.herb <-  bone.mass.herbivors*bone.energy.content #energy in each size bim from bones
		flesh.energy.herb <-  flesh.mass.herbivours*flesh.energy.content #energy in each size bim from flesh
		carcass.energy.avail <- bone.energy.herb + flesh.energy.herb*percent.flesh.available #energy in each size bim from complet carcass
		per.individual.carcass.energy.avail <- carcass.energy.avail*assimilation.effeciency*competativly.available
		carcass.energy.avail.kg <- per.individual.carcass.energy.avail/herbivor.size.bin #energy per kg 

		energy.dens.km.j <- sum((carcass.mass.density*number.day.carcass.available)*(carcass.energy.avail.kg/length(herbivor.size.bin))) #density of energy avalable to t.rex uniformly spread.
		return(data.frame(energy.dens.km.j))
	
		}
