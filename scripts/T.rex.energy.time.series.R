#13 Jan 2014
#T.rex energetics
#Kevin Healy

rm(list=ls())
graphics.off()

source("t.rex.energy.req.r")


#These are all the inputs to the model. must are put in as default but still no harm in directly expressing
est.type <- c("COT.hip") # from one of c("graeme","COT.hip", "COT.muscle.vol"). these are the different approaches to calulating the t.rex metabolic rate. the two COT are cost of transport types used by Pontzer et al 2009 and are probably better. I have hip here but the muscl one (which is higher) is as good an estimate really.

metabolic.type <- c("endo") # from one of c("endo","ecto") unless doing Graemes apporach leave this on endo
#walking.speed <- c(2.5) # meters per second. This is now calulated in the function based on mass and the scaling in Pontzer

hip.hight <- c(264) # in cm. this is for 

mass <- c(6000) # in kg

detection.distance <- c(1000) # in meters

search.time <- c(0.5) #amount of time searching

bone.energy.content <- c(6700000) # in joules/kg

flesh.energy.content <- c(7000000)#in joules/kg 

carcass.mass.density <- c(4.38) # kg/km

theropod.size.bin <- c(20.6,58.3,1123,5347) #theropod size bins from carbone can include other dino distributions such as dino park
#for dino park
#for

herbivor.size.bin <- c(75,216,700,2500,5000,8500,25000) #herbivour size bins from carbone can include other dino distributions such as dino park





assimilation.effeciency <- c(0.75) # amount of energy through assimilation

competition <- c("absent") #whether to include compition or not. currenty very crudly coded as linear increase from 0% at lowest body size to 100% at max body size. "absent" if compitition is not to be included "present" if it is

percent.flesh.available <- c(0.5) #how much flesh should be available, 0 if just a bone scavanger.

#this is over one body size

t.rex.output <- t.rex.energy.req(est.type = est.type, metabolic.type = metabolic.type, hip.hight = hip.hight, mass = mass, detection.distance = detection.distance, search.time = search.time, bone.energy.content = bone.energy.content, flesh.energy.content = flesh.energy.content, carcass.mass.density = carcass.mass.density, theropod.size.bin = theropod.size.bin, herbivor.size.bin = herbivor.size.bin, assimilation.effeciency = assimilation.effeciency, competition = competition, percent.flesh.available = percent.flesh.available)


#to test the energy budgets over a range of body sizes
#set up the mass range
mass.range <- seq(10,10000,10)

#calulate for each size
energy.mass.series <- lapply(mass.range,function(mass.range) t.rex.energy.req(est.type = est.type, metabolic.type = metabolic.type, hip.hight = hip.hight, mass = mass.range, detection.distance = detection.distance, search.time = search.time, bone.energy.content = bone.energy.content, flesh.energy.content = flesh.energy.content, carcass.mass.density = carcass.mass.density, theropod.size.bin = theropod.size.bin, herbivor.size.bin = herbivor.size.bin, assimilation.effeciency = assimilation.effeciency, competition = competition))

#clean up the output to put it into vector form
energy.mass.vect <- matrix(0, nrow = length(energy.mass.series) , ncol = length(energy.mass.series[[1]][]))
for(i in 1:length(energy.mass.series)){
	for(j in 1:length(energy.mass.series[[1]][])){
	energy.mass.vect[i,j] <- as.numeric(energy.mass.series[[i]][j])
}	
}

#plot the energy balance in j per day against body size
plot(energy.mass.vect[,5]~mass.range, xlab = "mass (kg)", ylab = "energy.balance (j)")




