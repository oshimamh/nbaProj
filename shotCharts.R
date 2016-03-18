library(ggplot2)
library(nlme)
library(coefplot)
library(ggmap)
library(png)
library(rjson)
library(grid)
library(gridExtra)

basicShotChart <- function(playerName){
  df <- getShotData(playerName)
  shotChart <- ggplot(df,aes(x=LOC_X, y=LOC_Y)) +
    geom_point(aes(colour = EVENT_TYPE))+
    xlim(-250,250)+
    ylim(-50,420)
  return(shotChart)
}

basicShotChart("Klay Thompson")

invlogit <- function(x){
  1/(1+exp(-x))
}

#use a binomial glm to model the probability of James Harden making a shot 
#based on the x and y coordinates of the shot location.

hardenData = getShotData("James Harden")
hardenMod1 = glm(EVENT_TYPE~LOC_X+LOC_Y-1, data = hardenData, family = binomial)
summary(hardenMod1)
coefplot(hardenMod1, trans = invlogit, title = "Probability of a Made Shot")

shotModelFit <- function(player){
  df <- getShotData(player)
  mod <- glm(SHOT_MADE_FLAG~LOC_X+LOC_Y-1, data = df, family = binomial)
  prdct <- df[,c("LOC_X","LOC_Y")]
  prdct$PROB <- predict(mod, newdata = prdct)
  return(prdct)
}
densityShotChart <- function(player){
  img <- readPNG("nba_court.png")
  g <- rasterGrob(img, interpolate=TRUE)
  df <- shotModelFit(player)
  shotChart <- ggplot(data = df, aes(x=LOC_X, y=LOC_Y, z=PROB)) + 
      annotation_custom(g, -275, 275, -35, 420)+
      xlim(-250,250)+
      ylim(-50,420)+
      geom_point(aes(color = PROB)) +
      scale_color_gradient(low="yellow",high="red")+
      stat_density2d(geom = "polygon", n=200, aes(fill=..level.., alpha = 1/2))
  return(shotChart)
}

densityShotChart("Klay Thompson")
