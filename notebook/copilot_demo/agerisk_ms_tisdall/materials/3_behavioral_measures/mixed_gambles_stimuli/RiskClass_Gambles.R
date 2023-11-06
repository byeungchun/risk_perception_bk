# set working directory and folder to save the images into
setwd("...")

xr <- sample(5:80,30)
xs <- xr*runif(30,0.7,0.9)
xs <- round(xs)

length(unique(xr))

out1 <- cbind(xs,rep(0,30),-xs,xr,rep(0,30),-xr)
out2 <- cbind(xs,rep(0,30),-xs,xr,rep(0,30),-xr)
out3 <- cbind(xs,rep(0,30),-xs,xr,rep(0,30),-xr)

p1 <- c(0.5,0,0.5)
p2 <- c(1/3,1/3,1/3)
p3 <- c(0.1,0.8,0.1)

zp <-  round(xs*sample(c(0.4,0.5,0.6),30,replace=TRUE))
zn <- -round(xs*sample(c(0.4,0.5,0.6),30,replace=TRUE))

out2[,2] <- zp
out2[,5] <- zp
out3[,2] <- zn
out3[,5] <- zn

#210 (420 pics)

out.p1 <- cbind(out1[,c(1,3,4,6)],rep(.5,30),rep(.5,30))
out1.p2 <- cbind(out1,matrix(rep(p2,30),ncol=3,byrow=TRUE))
out1.p3 <- cbind(out1,matrix(rep(p3,30),ncol=3,byrow=TRUE))
out2.p2 <- cbind(out2,matrix(rep(p2,30),ncol=3,byrow=TRUE))
out2.p3 <- cbind(out2,matrix(rep(p3,30),ncol=3,byrow=TRUE))
out3.p2 <- cbind(out3,matrix(rep(p2,30),ncol=3,byrow=TRUE))
out3.p3 <- cbind(out3,matrix(rep(p3,30),ncol=3,byrow=TRUE))

write.csv(out.p1,file="outp1.csv")
write.csv(out1.p2,file="out1p2.csv")
write.csv(out1.p3,file="out1p3.csv")
write.csv(out2.p2,file="out2p2.csv")
write.csv(out2.p3,file="out2p3.csv")
write.csv(out3.p2,file="out3p2.csv")
write.csv(out3.p3,file="out3p3.csv")

# Print images
library(scales) # to get the percent signs
#and define the colors first
gaincol = 'green'
losscol = 'red'
zerocol = 'gray 96'
minOp = .2 #this is the minimum value for the opacity
# for the out.p1:
outp = out.p1
for (i in 1:length(outp[,1])) {
  money <- outp[i,1:2] # selects the outcomes for this pie
  pieprob <- outp[i,5:6] # selects the probabilities for this pie
  pieprobperc <- percent(pieprob)
  # draw the pie chart
  opadd <- outp[i,1:4]
  opa<- if(max(abs(opadd))>0)100/max(abs(opadd))/100 else 0
  opacity<- opa*abs(money)
  for (xxx in 1:length(opacity)){
    if (opacity[xxx]<minOp)opacity[xxx]=minOp else if (opacity[xxx]>1)opacity[xxx]=1
  }
  #to get the colors:
  color <- c(if(money[1]>0) rgb(0,.55,0,opacity[1]), if(money[1]==0) zerocol, if(money[1]<0) rgb(.7,.1,.1,opacity[1]),if(money[2]>0) rgb(0,.55,0,opacity[2]), if(money[2]==0) zerocol, if(money[2]<0) rgb(.7,.1,.1,opacity[2]))
  # if the number is smaller than 10 write a 0 in front and then open the png
  if(i<10)png(paste("outp.p10", i, "S.png", sep="")) else png(paste('outp.p1', i, "S.png", sep=""))
  par(bg="white")
  #draw the pie
  pie(pieprob, labels = pieprobperc,radius =1, col= color,font=2, cex = 2)
  # some parameters to shift and position the outcomes
  pp <- pieprob
  qq <- cumsum(pp) - pp/2
  shift <- 0.7
  # now draw the outcomes 
  text(cos(qq*2*pi)*shift,sin(qq*2*pi)*shift, paste(money,"Fr.",sep=" "),font=2,cex=2)
  # and off you go...
  dev.off()
  
}

for (i in 1:length(outp[,1])) {
  money <- outp[i,3:4] # selects the outcomes for this pie
  pieprob <- outp[i,5:6] # selects the probabilities for this pie
  pieprobperc <- percent(pieprob)
  # draw the pie chart
  opadd <- outp[i,1:4]
  opa<- if(max(abs(opadd))>0)100/max(abs(opadd))/100 else 0
  opacity<- opa*abs(money)
  for (xxx in 1:length(opacity)){
    if (opacity[xxx]<minOp)opacity[xxx]=minOp else if (opacity[xxx]>1)opacity[xxx]=1
  }
  #to get the colors:
  color <- c(if(money[1]>0) rgb(0,.55,0,opacity[1]), if(money[1]==0) zerocol, if(money[1]<0) rgb(.7,.1,.1,opacity[1]),if(money[2]>0) rgb(0,.55,0,opacity[2]), if(money[2]==0) zerocol, if(money[2]<0) rgb(.7,.1,.1,opacity[2]))
  # if the number is smaller than 10 write a 0 in front and then open the png
  if(i<10)png(paste("outp.p10", i, "R.png", sep="")) else png(paste("outp.p1", i, "R.png", sep=""))
  par(bg="white")
  #draw the pie
  pie(pieprob, labels = pieprobperc,radius =1, col= color,font=2, cex = 2)
  # some parameters to shift and position the outcomes
  pp <- pieprob
  qq <- cumsum(pp) - pp/2
  shift <- 0.7
  # now draw the outcomes 
  text(cos(qq*2*pi)*shift,sin(qq*2*pi)*shift, paste(money,"Fr.",sep=" "),font=2,cex=2)
  # and off you go...
  dev.off()
  
}

# and for the rest
namelist = c('out1.p2', 'out1.p3', 'out2.p2', 'out2.p3', 'out3.p2', 'out3.p3')

for (zz in 1:6){
  if (zz==1)outp = out1.p2 else if(zz==2)outp = out1.p3 else if(zz==3)outp = out2.p2 else if(zz==4) outp = out2.p3 else if (zz==5)outp = out3.p2 else if(zz==6)outp = out3.p3
  
  for (i in 1:length(outp[,1])) {
    money <- outp[i,1:3] # selects the outcomes for this pie
    pieprob <- outp[i,7:9] # selects the probabilities for this pie
    pieprobperc <- percent(pieprob)
    # draw the pie chart
    opadd <- outp[i,1:6]
    opa<- if(max(abs(opadd))>0)100/max(abs(opadd))/100 else 0
    opacity<- opa*abs(money)
    for (xxx in 1:length(opacity)){
      if (opacity[xxx]<minOp)opacity[xxx]=minOp else if (opacity[xxx]>1)opacity[xxx]=1
    }
    #to get the colors:
    color <- c(if(money[1]>0) rgb(0,.55,0,opacity[1]), if(money[1]==0) zerocol, if(money[1]<0) rgb(.7,.1,.1,opacity[1]),if(money[2]>0) rgb(0,.55,0,opacity[2]), if(money[2]==0) zerocol, if(money[2]<0) rgb(.7,.1,.1,opacity[2]),if(money[3]>0)  rgb(0,.55,0,opacity[3]), if(money[3]==0) zerocol, if(money[3]<0)  rgb(.7,.1,.1,opacity[3]))
    # if the number is smaller than 10 write a 0 in front and then open the png
    if(i<10)png(paste(namelist[zz],"0", i, "S.png", sep="")) else png(paste(namelist[zz], i, "S.png", sep=""))
    par(bg="white")
    #draw the pie
    pie(pieprob, labels = pieprobperc,radius =1, col= color,font=2, cex = 2)
    # some parameters to shift and position the outcomes
    pp <- pieprob
    qq <- cumsum(pp) - pp/2
    shift <- 0.7
    # now draw the outcomes 
    text(cos(qq*2*pi)*shift,sin(qq*2*pi)*shift, paste(money,"Fr.",sep=" "),font=2,cex=2)
    # and off you go...
    dev.off()
    
  }
  
  for (i in 1:length(outp[,1])) {
    money <- outp[i,4:6] # selects the outcomes for this pie
    pieprob <- outp[i,7:9] # selects the probabilities for this pie
    pieprobperc <- percent(pieprob)
    # draw the pie chart
    opadd <- outp[i,1:6]
    opa<- if(max(abs(opadd))>0)100/max(abs(opadd))/100 else 0
    opacity<- opa*abs(money)
    for (xxx in 1:length(opacity)){
      if (opacity[xxx]<minOp)opacity[xxx]=minOp else if (opacity[xxx]>1)opacity[xxx]=1
    }
    #to get the colors:
    color <- c(if(money[1]>0) rgb(0,.55,0,opacity[1]), if(money[1]==0) zerocol, if(money[1]<0) rgb(.7,.1,.1,opacity[1]),if(money[2]>0) rgb(0,.55,0,opacity[2]), if(money[2]==0) zerocol, if(money[2]<0) rgb(.7,.1,.1,opacity[2]),if(money[3]>0)  rgb(0,.55,0,opacity[3]), if(money[3]==0) zerocol, if(money[3]<0)  rgb(.7,.1,.1,opacity[3]))
    # if the number is smaller than 10 write a 0 in front and then open the png
    if(i<10)png(paste(namelist[zz],"0", i, "R.png", sep="")) else png(paste(namelist[zz], i, "R.png", sep=""))
    par(bg="white")
    #draw the pie
    pie(pieprob, labels = pieprobperc,radius =1, col= color,font=2, cex = 2)
    # some parameters to shift and position the outcomes
    pp <- pieprob
    qq <- cumsum(pp) - pp/2
    shift <- 0.7
    # now draw the outcomes 
    text(cos(qq*2*pi)*shift,sin(qq*2*pi)*shift, paste(money,"Fr.",sep=" "),font=2,cex=2)
    # and off you go...
    dev.off()
    
  }
}

# and now for something completely different, the example trials
money <- c(2,0,-3) # selects the outcomes for this pie
pieprob <- c(.5,.3,.2) # selects the probabilities for this pie
pieprobperc <- percent(pieprob)
# draw the pie chart
opadd <- c(2,0,-3,10,0,-15)
opa<- if(max(abs(opadd))>0)100/max(abs(opadd))/100 else 0
opacity<- opa*abs(money)
for (xxx in 1:length(opacity)){
  if (opacity[xxx]<minOp)opacity[xxx]=minOp else if (opacity[xxx]>1)opacity[xxx]=1
}
#to get the colors:
color <- c(if(money[1]>0) rgb(0,.55,0,opacity[1]), if(money[1]==0) zerocol, if(money[1]<0) rgb(.7,.1,.1,opacity[1]),if(money[2]>0) rgb(0,.55,0,opacity[2]), if(money[2]==0) zerocol, if(money[2]<0) rgb(.7,.1,.1,opacity[2]),if(money[3]>0)  rgb(0,.55,0,opacity[3]), if(money[3]==0) zerocol, if(money[3]<0)  rgb(.7,.1,.1,opacity[3]))
# if the number is smaller than 10 write a 0 in front and then open the png
png(paste("ExampleS.png", sep="")) 
par(bg="white")
#draw the pie
pie(pieprob, labels = pieprobperc,radius =1, col= color,font=2, cex = 2)
# some parameters to shift and position the outcomes
pp <- pieprob
qq <- cumsum(pp) - pp/2
shift <- 0.7
# now draw the outcomes 
text(cos(qq*2*pi)*shift,sin(qq*2*pi)*shift, paste(money,"Fr.",sep=" "),font=2,cex=2)
# and off you go...
dev.off()


money <- c(10,0,-15) # selects the outcomes for this pie
pieprob <- c(.5,.3,.2) # selects the probabilities for this pie
pieprobperc <- percent(pieprob)
# draw the pie chart
opadd <- c(2,0,-3,10,0,-15)
opa<- if(max(abs(opadd))>0)100/max(abs(opadd))/100 else 0
opacity<- opa*abs(money)
for (xxx in 1:length(opacity)){
  if (opacity[xxx]<minOp)opacity[xxx]=minOp else if (opacity[xxx]>1)opacity[xxx]=1
}
#to get the colors:
color <- c(if(money[1]>0) rgb(0,.55,0,opacity[1]), if(money[1]==0) zerocol, if(money[1]<0) rgb(.7,.1,.1,opacity[1]),if(money[2]>0) rgb(0,.55,0,opacity[2]), if(money[2]==0) zerocol, if(money[2]<0) rgb(.7,.1,.1,opacity[2]),if(money[3]>0)  rgb(0,.55,0,opacity[3]), if(money[3]==0) zerocol, if(money[3]<0)  rgb(.7,.1,.1,opacity[3]))
# if the number is smaller than 10 write a 0 in front and then open the png
png(paste("ExampleR.png", sep=""))
par(bg="white")
#draw the pie
pie(pieprob, labels = pieprobperc,radius =1, col= color,font=2, cex = 2)
# some parameters to shift and position the outcomes
pp <- pieprob
qq <- cumsum(pp) - pp/2
shift <- 0.7
# now draw the outcomes 
text(cos(qq*2*pi)*shift,sin(qq*2*pi)*shift, paste(money,"Fr.",sep=" "),font=2,cex=2)
# and off you go...
dev.off()
  