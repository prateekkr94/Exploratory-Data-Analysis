
## End-to-end analysis

## 1. Data reading, management. Graphing the major trends.
##
## For the weather data set, looking at the snowfall across months of the year.
## Helping residents better understand the the snowfall
## patterns in Houghton, both within a year and historically.

## Creating two graphics that show basic snowfall trends, one giving some type of summary
## over the entire data set from 1890, and  one showing the trends across the 
## different months of the year.

library(gplots)
filter <- 1:128 ##ignoring the last year, can be updated on getting more data:
alldat <- read.csv("weather.csv")[filter,]

##snowfall and other data:
years <- alldat[,1]
weather <- alldat[,1:9]
elnino <- alldat[,12:23]
sunspots <- alldat[,25:36]
avgtemp <- alldat[,38:49]
ice <- alldat[,50:57]

matplot(t(ice),type="o",pch=16,col="black",lty=3,
        main="Ice cover")

icebymonth <- as.vector(unlist(t(ice[,-1])))
plot(icebymonth[550:900],type="l",main = 'Ice by month')


## A straight matplot is sort of hard to grasp:
matplot(weather[,2:9],type="l", main="Snowfall each month over past 120 years")

barplot(as.matrix(weather[,2:9]),main = "Snowfall")
cols <- rev(rich.colors(8,"blues"))
barplot(t(as.matrix(weather[,2:9])),col=cols,main = "Snowfall")

##how might a transform work?
barplot(t(log(1+as.matrix(weather[,2:9]))),col=cols)

## I'd like to make a stacked line plot.  To do this, I can apply the cumsum
##function to each row of the data frame:

bymonth <- apply(weather[,2:9],1,cumsum)

par(mfrow=c(1,2))
matplot(bymonth,type="l",col="black",lty=1,main="Cumulative snowfall")
matplot(t(bymonth),type="l",col="black",lty=1)


#I'd like to fill in the area, and use a color gradient 
#to color each month-region separately.  The following evolved over iterations

filled.line <- function(x,ymatrix,xlab="",ylab="",main="")
{
   matplot(x,ymatrix,lty=1,type="l",xlab=xlab,ylab=ylab,main=main)

   
   ##Figure out some vertical lines.
   xrange <- round(range(x),-1)
   abline(v=seq(xrange[1],xrange[2],10),lty=2,col="grey")

   
   cols <- rev(rich.colors((ncol(ymatrix)),"blues"))
  for(i in ncol(ymatrix):1)
  {
      polygon(c(min(x),x,max(x)), c(0,ymatrix[,i],0),col=cols[i],lty=0)      
  }
      polygon(c(min(x),x,max(x)), c(0,ymatrix[,ncol(ymatrix)],0),lty=1)      

#  fit <- lm(ymatrix[,ncol(ymatrix)]~poly(x,degree=10))
#  points(x,fit$fit,lty=1,lwd=3,type="l")
   #legend(min(x),355,rev(c("Oct","Nov","Dec","Jan","Feb","Mar","Apr","May")),bty="o",pt.cex=1.9,
    #      pch=15,col=rev(cols),y.intersp=.9,lty=0)
   #legend(min(x),355,rev(c("","","","","","","","")),bty="n",pt.cex=1.9,
    #      pch=0,y.intersp=.9)
 
}

years.num <- as.numeric(substr(years,1,4))

#pdf("houghton.pdf",width=8,height=5)
filled.line(years.num[filter],t(bymonth)[filter,],ylab="Inches of snow per Winter",xlab="Year",main="Houghton County Annual Snowfall")
#dev.off()


## Also, we'd like to be able to look at this by month
##

matplot(t(weather[,2:9]),type="o",pch=16,cex=.2,col="black",xaxt=  "n",lty=3,
        ylab="Monthly snowfall (in)",las=1)
axis(1,1:8,c("OCT","NOV","DEC","JAN","FEB","MAR","APR","MAY"))
for(i in seq(0,120,20))
abline(i,0,lty=2,lwd=.8,col="grey")

points(rowMeans(t(weather[filter,2:9])),type="l",col="navy",lwd=5)

##can we identify which month has the most snow?
weather$max <-   apply(weather[,2:9],1,which.max)
points(weather$max, weather[,2:9][cbind(1:nrow(weather),weather$max)],col="gold",pch=15)

## 2: There appears to be a shift in snowfall patterns
## over the past century, with an increase happening around 1920.
## Considering two time eras, one for the 30 years before 1920, and one 
## for the 93 years after 1920. Conducting
## statistical tests at p=.05 which will show if the snowfall increased in each 
## month of the year, or just some of the months.

library(BayesFactor)
early <- rep(c(T,F),c(30,length(years)-30))
late <- rep(c(F,T),c(30,length(years)-30))

t.test(weather$OCT[early],weather$OCT[late])
t.test(weather$NOV[early],weather$NOV[late])
t.test(weather$DEC[early],weather$DEC[late])
t.test(weather$JAN[early],weather$JAN[late])
t.test(weather$FEB[early],weather$FEB[late])
t.test(weather$MAR[early],weather$MAR[late])
t.test(weather$APR[early],weather$APR[late])

ttestBF(weather$OCT[early],weather$OCT[late])
ttestBF(weather$NOV[early],weather$NOV[late])
ttestBF(weather$DEC[early],weather$DEC[late])
ttestBF(weather$JAN[early],weather$JAN[late])
ttestBF(weather$FEB[early],weather$FEB[late])
ttestBF(weather$MAR[early],weather$MAR[late])
ttestBF(weather$APR[early],weather$APR[late])


plot(colMeans(weather[early,2:9]),type="o",ylim=c(0,80),
     ylab="Average monthly snowfall" ,xaxt="n",xlab="Month",
     las=1,main="Average snowfall by month",cex=2,pch=16)
points(colMeans(weather[late,2:9],na.rm=T),type="o",pch=15,cex=2)
axis(1,1:8,c("OCT","NOV","DEC","JAN","FEB","MAR","APR","MAY"))
for(i in c(0:8*10))
abline(i,0,col="grey",lty=2)

means <-rbind(colMeans(weather[early,2:9],na.rm=T),
              colMeans(weather[late,2:9],na.rm=T))
reliable <- c(F,F,T,T,T,T,F,F)

rect((1:8)[reliable]-.12,
     means[1,reliable]-5,
     (1:8)[reliable]+.12,
     means[2,reliable]+5,
     border="navy",lwd=3)
text(5,77,"Reliable differences")
segments(5,75,3:6,means[2,reliable]+6)
points(colMeans(weather[early,2:9]),type="o",ylim=c(0,80),col="red",pch=16,cex=1.9)
points(colMeans(weather[late,2:9],na.rm=T),type="o",col="blue",pch=15,cex=1.9)

#legend(1,80,c("1920-present","1890-1920"),lwd=2,lty=1,col=c("blue","red"),pt.cex=2,pch=c(15,16))

## 3:
## It appears that in the 'old' era, December tended to get more snow
## than January, but this has switched.  Conducting an appropriate statistical
## test determining whether each of these are reliable. 
## Are these differences reliable.  That is, for each era, was January larger 
## than December?


##Test for all years:
##This is the 'wrong' test
t.test(weather$DEC,weather$JAN)
##This is a better one to use:
t.test(weather$DEC,weather$JAN,paired=T)
ttestBF(weather$DEC,weather$JAN,paired=T)  


t.test(weather$DEC[early],weather$JAN[early],paired=T)
t.test(weather$DEC[late],weather$JAN[late],paired=T)

ttestBF(weather$DEC[early],weather$JAN[early],paired=T)
ttestBF(weather$DEC[late],weather$JAN[late],paired=T)

##these seem to suggest that the difference in the amount
##that fell dec-jan did differ in the early era,
## but may have in  the late era.


## 4:
## Finding out which month had the highest snowfall using code such as:

weather$max <- apply(weather[,2:9],1,which.max)


weather[1:5,]


## Creating a table showing how many times each month got the highest
## snowfall, for the early and late eras.

highmonth <- table(weather$max,early)
highmonth

chisq.test(highmonth)

## Question 5: 
## Build a model to predict snowfall in a given year.
## We can use:
## 1. some type of non-linear regression method that will permit fitting
##    long-term fluctuations
## 2. The previous years snowfall
## 3. sunspot records
## 4. el nino records
## 5. ??? other ideas (temperature)



##can we predict one month snowfall based on other months in the same year?

g1 <- lm(weather$MAR~weather$OCT+weather$NOV+weather$DEC+weather$JAN+weather$FEB)

summary(g1) ##the complete model with all months only predicts march with an R2 of .14
            ##and suggests only February helps predict March. This is maybe not too surprising


step(g1) ##only february

###############################################
###  What about annual snowfalL?

snowfall <- rowSums(weather[,2:9])
snowfall

#temperature <- read.csv("temperature.csv")
temperature <- alldat[,38:49]
# Let's look at some possible predictors

plot(as.vector(as.matrix(elnino)),type="b",main="El nino weather Cycle (monthly)")

plot(rowMeans(elnino),type="b", main="El nino weather cycle (annual)")

plot(rowMeans(elnino),snowfall,main=paste("El nino vs. snowfall\n",
                                           round(cor(rowMeans(elnino),snowfall),3)))
#small but positive correlation!

plot(as.vector(as.matrix(sunspots)),type="b")
plot(rowMeans(sunspots),type="b")

plot(rowMeans(sunspots),snowfall,
     main=paste("Sunspots vs. snowfall\n",
               round(cor(rowMeans(sunspots),snowfall,use="pairwise.complete"),3)))

##larger positive correlation!

plot(as.vector(as.matrix(temperature[,-1])))
plot(as.vector(t(as.matrix(temperature[,-1]))),type="o",main="Mean temperature by month")

plot(rowMeans(temperature[,-1]),main="Mean temperature by year",type="o")

plot(rowMeans(temperature[,-1]),snowfall,
     main=paste("Temperature vs. snowfall\n",
                round(cor(rowMeans(temperature[,-1]),snowfall,use="pairwise.complete"),3)))

###let's combine all of this.
##we have 126 seasons that are complete as of Oct 2016.

alldat[126,]

##let's try estimate snowfall by predicting based on data in the previous year
##only things we could know then. We will only have 125 data row then

prevSnow <- rowSums(weather[1:125,2:9])
snowfallbyyear <- rowSums(weather[2:126,2:9])
elninobyyear   <- rowMeans(elnino[1:125,])  ##average for the whole previous year
sunspotsbyyear <- rowMeans(sunspots[1:125,]) ##average for whole previous year

sunspotSF <- rowMeans(sunspots[1:125,9:12])  ##true predicting--by previous summer

##get a summer and a fall elnino separately:
elninoSF <- rowMeans(elnino[1:125,9:12])

#tempbyyear <- rowMeans(temperature[1:125,-1])
#tempSF <- rowMeans(temperature[1:125,10:13])

n <- 125

newdat <- data.frame(Year=years[1:n],
                     year=1:n,
                     snow=snowfallbyyear,
                     elnino=elninobyyear,
                     elninoSF,
                     sunspots=sunspotsbyyear,
                     ssSF=sunspotSF,
                     prev = prevSnow,
                    
                     logprev = log(prevSnow)
                    #temp = tempbyyear,
                    #tempSF=tempSF
                     )
newdat[1:5,]




##It would be nice to fit the annual trend as a polynomial, to
##hopefully factor the mean level out.
model1 <-  lm(snow ~ year + poly(year,10),dat=newdat)
anova(model1)
summary(model1)
##R^2 is .52 with just year-polynomial

matplot(cbind(snowfallbyyear,elninobyyear,sunspotsbyyear/12),type="l")
points(model1$fit)

qqnorm(model1$resid)##fairly reasonably normal
hist(model1$resid)

model2a <-  lm(snow ~  poly(year,10),dat=newdat) ##same as model1
model2b <-  lm(log(snow) ~  poly(year,10),dat=newdat)

summary(model2a) ##.528
summary(model2b)  ##improves R^2 to .573, but is it fair?

cor(newdat$snow,exp(model2b$fit))^2 ##.529  ##not really an improvement


hist(model2a$resid)


##look into residuals
cor(model2a$resid,newdat[,-(1:2)])
cor(model2b$resid,newdat[,-(1:2)])

##residuals are highly correlated with annual elnino, but not previous summer's


##maybe we can gain a little by by using the information
## have.  We will continue to make two separate models.


model3a <-  lm(snow ~ year +
                  poly(year,10)+
                  elnino +elninoSF+
                  sunspots + ssSF +
                  prev,
              dat=newdat)

model3b <-lm(log(snow) ~ year +
                  poly(year,10)+
                  elnino +elninoSF+
                  sunspots + ssSF + 
               logprev,
              dat=newdat)

summary(model3a)
summary(model3b)

par(mfrow=c(1,2))
plot((newdat$snow),type="l")
points(model2a$fit,type="o",col="red")
points(model3a$fit,type="o",col="blue")

plot(log(newdat$snow),type="l")
points(model2b$fit,type="o",col="red")
points(model3b$fit,type="o",col="blue")

anova(model3b)
summary(model3b)##r2 of .64


##there looks like there are normal periodic devations....
plot(model3a$resid,type="l")
spectrum(model3a$resid)

##noise is pretty flat.

## OK, now this master prediction shown three reliable predictors.
##

modelBICa <- step(model3a,direction="both",k=log(125))  ##just elnino sf
modelAICa <- step(model3a,direction="both")             ##ditto
summary(modelAICa)
summary(modelBICa)
anova(model3a,modelAICa,modelBICa)


modelBICb <- step(model3b,direction="both",k=log(125))
modelAICb <- step(model3b,direction="both")
summary(modelAICb)  #sssf; elninosf,logprev, etc.
summary(modelBICb)  ##small model as above
anova(model3b,modelAICb,modelBICb)



##Lets predict 2019
N <- 129

year1617 <- data.frame(Year="2018-19",
                       year=N-1,  ##let's not extrapolate for now
                       snow=0, ##not used
                       elnino=rowMeans(elnino[N,]),
                       elninoSF=rowMeans(elnino[N,9:12]),
                       sunspots=rowMeans(sunspots[N,]),
                       ssSF=rowMeans(sunspots[N,9:12]),
                       temp=rowMeans(temperature[N,-1]),
                       #tempSF=rowMeans(temperature[N,10:13]),
                       prev=rowSums(weather[N,2:9]),
                       logprev=log(rowSums(weather[N,2:9])))


newdat2 <- rbind(newdat,year1617)
newdat2[-(1:120),]

predict(model3a,year1617)
predict(modelBICa,year1617)
predict(modelAICa,year1617)


exp(predict(model3b,year1617))
exp(predict(modelAICb,year1617))
exp(predict(modelBICb,year1617))





##all the models predict between 214-220 inches

#pdf("winter-prediction.pdf",width=8,height=6)
par(mfrow=c(1,1))

filled.line(years.num,t(bymonth),ylab="Inches of snow per Winter",xlab="Year",main="Houghton County Annual Snowfall")

preda <- (predict(model3a,newdat2))
newyears <- 1891:2018
points(newyears,preda,lwd=3,type="o",pch=16,cex=.5)
predb <- (predict(modelAICa,newdat2))
points(newyears,predb,lwd=3,type="l",pch=16,cex=.5,col="grey20")
#dev.off()
