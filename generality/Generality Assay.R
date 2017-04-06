################################################################################
#                                                                              #
#	RPF Generality Assay Code                                                    #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: V. Kuo                                                           #
#   Based on growthcurve_code.R Written by: M. Larsen (2013/07/18)             #
#                                           M. Muscarella (2015/11/24)         #
#	Last update: 12/18/2016                                                      #
#                                                                              #
################################################################################
# Set Working Directory #
rm(list=ls())
setwd("C:/Users/Venus/Github/GeneralityAssay/Data/")
require("vegan")
require("coin")
require("gplots")

################################################################################
## Run Raw Plate Reader Data through Mario's Growthcurve_code ##################
# Load Dependencies #
source("../Analyses and Code//modified_Gomp.r")
# Create Directory For Output
dir.create("../output", showWarnings = FALSE)

# Run Example #
growth.modGomp("3.8.16_2ndRun_GeneralityAssay.txt", "test", skip=31)
growth.modGomp("3.3.16_1stRun_GeneralityAssay.txt")

# Having Issues recreating the data file from ModGompEqn, will fix later #######
################################################################################

# Output of my raw data run saved as "ModifiedGompEquationOutput.csv" #
data <- read.csv("GrowthCurveData.csv")

# I manually seperated out the maximum growth rate (umax), biomass (A), and lag time (L) into seperate csv #
umax <- read.csv("MaxGrowthRate.csv")
biomass <- read.csv("CarryingCapacity.csv")
lag <- read.csv("LagTime.csv")

# Omitting NA from data matrix #
umax <- na.omit(umax)
data <- na.omit(data)
biomass <- na.omit(biomass)
lag <- na.omit(lag)

# Turning KBS Strain number into Factors #
umax$Strain <- factor(umax$Strain)
biomass$Strain <-as.factor(biomass$Strain)
data$Strain <- factor(data$Strain)
data$Rep <- factor(data$Rep)
lag$Strain <- factor(lag$Strain)

################################
## umaxDelta umax growth rate ##
## Genus v %umaxchange ##
par(mar=c(7,3.85,0.5,0.5))
boxplot(umaxDelta~Genus , las=3 , 
        col=c("Green","Dark Green","Dark Red", "Orange","Yellow","Purple","Light Blue","Red","Grey","Black","White"),
        data=umax, ylab=" ", cex.lab=0.85 , cex.axis=0.75)
mtext("% change in maximum growth rate", side = 2, line = 2.25, cex = 1)
abline(a=0, b=0, col="Black", lty=2)
anova(lm(umax~Treatment*Genus, data=data))   
#Rpf treatment significantly increases umax within and across each strain #

## Phylum v %umaxchange ## 
par(mar=c(5.1,3.85,0.5,0.5))
boxplot(umaxDelta~Phylum , las=1 , 
        col=c("Orange","Grey","Dark Red","Purple"),
        data=umax, xlab="Phylum", ylab=" ", cex.lab=0.85 , cex.axis=0.75)
mtext("% change in maximum growth rate", side = 2, line = 2.25, cex = 1)
abline(a=0, b=0, col="Black", lty=2)
anova(lm(umax~Phylum*Treatment, data=data))
# No significant difference within Phylum with Rpf treatment 

## Gram status v %umaxchange ##
par(mar=c(5.1,4.1,4.1,2.1))
boxplot(umaxDelta~Gram, data=umax, col=c("Dark Green","Orange"),
        xlab="Gram Status", ylab="Change in Maximum Growth Rate (???umax)")
abline(a=0, b=0, col="Black", lty=2)
anova(lm(umax~Gram*Treatment, data=data)) 
# Treatment effect is not seen within gram status #

#Student T-test of umax to treatment
var.test(umax~Treatment, data=data)
#variance is equal becuase p is greater than 0.05
t.test(umax~Treatment, data=data, var.equal=T)
#not significant 

## Correlation of umax, lag, and A ## 
my_num_data <- data[, sapply(data, is.numeric)]
cor(my_num_data, use="complete.obs", method="pearson")
#Biomass (A) is positively correlated with umax and L #
#Lag time (L) is negative correlated with umax and positively correlated with A #

################################################
## Biomass (A) and Strain #
par(mar=c(7,3.85,0.5,0.5))
boxplot(ADelta~Genus , las=3 , 
        col=c("Green","Dark Green","Dark Red", "Orange","Yellow","Purple","Light Blue","Red","Grey","Black","White"),
        data=biomass, ylab=" ", cex.lab=0.85 , cex.axis=0.75)
mtext("% change in biomass carrying capacity", side = 2, line = 2.25, cex = 1)
abline(a=0, b=0, col="Black", lty=2)
anova(lm(A~Treatment*Genus, data=data))   
#Rpf treatment significantly increases umax within and across each genus #

## Phylum v %biomasschange ## 
par(mar=c(5.1,3.85,0.5,0.5))
boxplot(ADelta~Phylum , las=1 , 
        col=c("Orange","Grey","Dark Red","Purple"),
        data=biomass, xlab="Phylum", ylab=" ", cex.lab=0.85 , cex.axis=0.75)
mtext("% change in biomass carrying capacity", side = 2, line = 2.25, cex = 1)
abline(a=0, b=0, col="Black", lty=2)
anova(lm(A~Phylum*Treatment, data=data))
# No significant difference within Phylum with Rpf treatment, but significant between treatment # 

## Gram status v %biomasschange ##
par(mar=c(5.1,4.1,4.1,2.1))
boxplot(ADelta~Gram, data=biomass, col=c("Dark Green","Orange"),
        xlab="Gram Status", ylab="% change in biomass carry capacity change")
abline(a=0, b=0, col="Black", lty=2)
anova(lm(umax~Gram*Treatment, data=data)) 
# Treatment effect is not seen within gram status #

## Student T-test of umax to treatment ##
var.test(A~Treatment, data=data)
#variance is equal becuase p is greater than 0.05
t.test(A~Treatment, data=data, var.equal=T)
# Treatment not significant within strain for biomass change

##################################################
## Lag Time  
## Genus v %lagtimechange ##
par(mar=c(7,3.85,0.5,0.5))
boxplot(LagDelta~Genus , las=3 , 
        col=c("Green","Dark Green","Dark Red", "Orange","Yellow","Purple","Light Blue","Red","Grey","Black","White"),
        data=lag, ylab=" ", cex.lab=0.85 , cex.axis=0.75)
mtext("% change in lag time", side = 2, line = 2.25, cex = 1)
abline(a=0, b=0, col="Black", lty=2)
anova(lm(L~Treatment*Genus, data=data))   
#Rpf treatment significantly changes lag time within and across each strain with treatment #

## Phylum v %lagtimechange ## 
par(mar=c(5.1,3.85,0.5,0.5))
boxplot(LagDelta~Phylum , las=1 , 
        col=c("Orange","Grey","Dark Red","Purple"),
        data=lag, xlab="Phylum", ylab=" ", cex.lab=0.85 , cex.axis=0.75)
mtext("% change in lag time", side = 2, line = 2.25, cex = 1)
abline(a=0, b=0, col="Black", lty=2)
anova(lm(L~Phylum*Treatment, data=data))
# Treatment did not affect lag time within phylum 

## Lag time and Gram status ## 
par(mar=c(5.1,4.1,4.1,2.1))
boxplot(LagDelta~Gram, data=lag, col=c("Dark Green","Orange"),
        xlab="Gram Status", ylab="% change in biomass carry capacity change")
abline(a=0, b=0, col="Black", lty=2)
anova(lm(L~Treatment*Gram, data=data)) # Not significant
# No difference among gram negative and positive with treatment

#is Total biomass different between sterile and live soil?
var.test(L~Treatment, data=data)
#variance is equal becuase p is less than 0.05
t.test(L~Treatment, data=data, var.equal=T)
#no the groups aren't different


KBS0711 <- data[49:55, ]

var.test(umax~Treatment, data=KBS0711)
t.test(umax~Treatment, data=KBS0711)
wilcoxsign_test(umax~Treatment, data=KBS0711)
wilcoxsign_test(A~Treatment, data=KBS0711)

KBS0702 <- data[9:16, ]
var.test(umax~Treatment, data=KBS0702)
t.test(umax~Treatment, data=KBS0702)
wilcoxsign_test(L~Treatment, data=KBS0702)

