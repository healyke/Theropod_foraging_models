#13 Jan 2014
#T.rex energetics
#Kevin Healy

rm(list=ls())
graphics.off()

source("t.rex.function.R")


#These are all the inputs to the model. must are put in as default but still no harm in directly expressing
est.type <- c("hip") # from one of c("graeme","hip", "muscle"). these are the different approaches to calulating the t.rex metabolic rate. the two COT are cost of transport types used by Pontzer et al 2009 and are probably better. I have hip here but the muscl one (which is higher) is as good an estimate really.

metabolic.type <- c("endo") # from one of c("endo","ecto") unless doing Graemes apporach leave this on endo
#walking.speed <- c(2.5) # meters per second. This is now calulated in the function based on mass and the scaling in Pontzer

hip.hight <- c(42,100,116,149,264) # in cm.

V.musc = c(44.1) 

#set up the mass range
mass <- seq(10,10000,10) # in kg

detection.distance <- c(500) # in meters

search.time <- c(0.5) #amount of time searching

bone.energy.content <- c(6700000) # in joules/kg

flesh.energy.content <- c(7000000)#in joules/kg 

carcass.mass.density <- c(4.38) # kg/km

froude.no = c(0.25) #0.25 is a slow walk 0.5 is the transition into running gait 1 is running.

theropod.size.bin <- c(20.6,58.3,1123,5347) #theropod size bins from carbone can include other dino distributions such as dino park
#for dino park
#for

herbivor.size.bin <- c(75,216,700,2500,5000,8500,25000) #herbivour size bins from carbone can include other dino distributions such as dino park

assimilation.effeciency <- c(0.80*0.23) # amount of energy through assimilation

competition <- c("absent") #whether to include compition or not. currenty very crudly coded as linear increase from 0% at lowest body size to 100% at max body size. "absent" if compitition is not to be included "present" if it is

percent.flesh.available <- c(0.5) #how much flesh should be available, 0 if just a bone scavanger.
competativly.available <- c(1) #how much flesh should be available due to competition.


#create vectors of area searched
searched <- area.searched(mass = mass, detection.distance = detection.distance, search.time =c(0.5), hip.hight <- c(42,100,116,149,264),froude.no = c(0.25), theropod.body.sizes = c(20,210,430,1400,6000))

daily.km2.search <- searched$daily.km2.search
walking.speed <- searched$walking.speed

#create vectors of energy used
pontz.energy <- pontz.energy.exp(mass = mass, walking.speed = walking.speed, est.type = "hip", hip.hight = hip.hight, V.musc = c(44.1), search.time = c(0.5))

Tot.daily.energy.consumption.j <- pontz.energy$Tot.daily.energy.consumption.j


avail.energy <- energy.available(bone.energy.content = c(6700000), flesh.energy.content = c(7000000), herbivor.size.bin = c(75,216,700,2500,5000,8500,25000), percent.flesh.available = percent.flesh.available, assimilation.effeciency = assimilation.effeciency , competativly.available = competativly.available, carcass.mass.density = carcass.mass.density, number.day.carcass.available = c(7))

energy.dens.km.j <- avail.energy$energy.dens.km.j

#quick energy balance with set parameters above
Energy.balance <-  daily.km2.search*energy.dens.km.j - Tot.daily.energy.consumption.j



############----------------------------------##########################
############Free parameter models using lapply##########################
############----------------------------------##########################

############---------------Scaling between max.size and carcass.density------------##########################


###Set up the terpod dependent varibles

searched <- area.searched(mass = mass, detection.distance = c(500), search.time =c(0.5), hip.hight <- c(42,100,116,149,264),froude.no = c(0.25), theropod.body.sizes = c(20,210,430,1400,6000))
daily.km2.search <- searched$daily.km2.search
walking.speed <- searched$walking.speed

#create vectors of energy used
pontz.energy <- pontz.energy.exp(mass = mass, walking.speed = walking.speed, est.type = est.type, hip.hight = hip.hight, V.musc = c(44.1), search.time = c(0.5))

Tot.daily.energy.consumption.j <- pontz.energy$Tot.daily.energy.consumption.j


#Set up lapply across a series if envirnmental densities to give availble energy.

carcass.mass.density <- c(seq(0,50,0.5))

avail.energy <- lapply(carcass.mass.density, function(carcass.mass.density) energy.available(bone.energy.content = c(6700000), flesh.energy.content = c(7000000), herbivor.size.bin = c(75,216,700,2500,5000,8500,25000), percent.flesh.available = c(10), assimilation.effeciency = c(0.75), competativly.available = c(1), carcass.mass.density = carcass.mass.density, number.day.carcass.available = c(7)) )

energy.dens.km.j <- avail.energy[]

Energy.balance <- matrix(0, nrow = c(length(daily.km2.search)), ncol = c(length(carcass.mass.density)))
for(i in 1:(length(carcass.mass.density))){
Energy.balance[,i] <-  daily.km2.search*(as.numeric(energy.dens.km.j[[i]][])) - Tot.daily.energy.consumption.j
}

#to calulate the maximum inflection 
energy.output <- data.frame(Energy.balance,mass)

opt.size <- matrix(0, nrow = c(length(energy.output[1,])-1))
for(i in 1:(length(energy.output[1,])-1)){
opt.size[i] <- energy.output[(max(energy.output[,i]) == energy.output[,i]),"mass"]
}

#plot these out
plot(opt.size~carcass.mass.density, col = "white", xlab= "Density of carcasses (kg/km2)", ylab = "Optimum body size (kg)")

lines(opt.size~carcass.mass.density, col = "red", lwd = "2")



############---------------Scaling between max.size and detection distance------------##########################



#Set up lapply across detection distances
detection.distance <- c(seq(0,2000,100))
carcass.mass.density <- c(4.38) # kg/km


searched <- lapply(detection.distance, function(detection.distance) area.searched(mass = mass, detection.distance = detection.distance, search.time =c(0.5), hip.hight <- c(42,100,116,149,264),froude.no = c(0.25), theropod.body.sizes = c(20,210,430,1400,6000)))

walking.speed <-  data.frame(searched[[1]]["walking.speed"])

daily.km2.search <- matrix(0, nrow = c(length(mass)), ncol = c(length(detection.distance)))
for(i in 1:(length(detection.distance))){
daily.km2.search[i] <-  searched[[i]]["daily.km2.search"]
}

###Set up the terpod dependent varibles

#create vectors of energy used
pontz.energy <- pontz.energy.exp(mass = mass, walking.speed = walking.speed, est.type = est.type, hip.hight = hip.hight, V.musc = c(44.1), search.time = c(0.5))

#the output.is very annoying here as the names are not changing
Tot.daily.energy.consumption.j <- pontz.energy$walking.speed.1

avail.energy <- energy.available(bone.energy.content = c(6700000), flesh.energy.content = c(7000000), herbivor.size.bin = c(75,216,700,2500,5000,8500,25000), percent.flesh.available = percent.flesh.available, assimilation.effeciency = assimilation.effeciency, competativly.available = competativly.available, carcass.mass.density = carcass.mass.density, number.day.carcass.available = c(7))

energy.dens.km.j <- avail.energy$energy.dens.km.j




Energy.balance <- matrix(0, nrow = c(length(mass)), ncol = c(length(detection.distance)))
for(i in 1:(length(detection.distance))){
Energy.balance[,i] <-  daily.km2.search[[i]][]*energy.dens.km.j - Tot.daily.energy.consumption.j
}


#to calulate the maximum inflection 
energy.output <- data.frame(Energy.balance,mass)

opt.size <- matrix(0, nrow = c(length(energy.output[1,])-1))
for(i in 1:(length(energy.output[1,])-1)){
opt.size[i] <- energy.output[(max(energy.output[,i]) == energy.output[,i]),"mass"]
}

#plot these out
plot(opt.size~ detection.distance, col = "white", xlab= "Detection distance (m)", ylab = "Optimum body size (kg)")

lines(opt.size~ detection.distance, col = "red", lwd = "2")







