library(ggplot2)
library(nlme)
library(coefplot)

basicShotChart <- function(playerShotData){
  shotChart <- ggplot(playerShotData,
                      aes(x=LOC_X, y=LOC_Y)
  ) +
    geom_point(
      aes(colour = EVENT_TYPE)
    )
  return(shotChart)
}

invlogit <- function(x){
  1/(1+exp(-x))
}

#use a binomial glm to model the probability of James Harden making a shot 
#based on the x and y coordinates of the shot location.

hardenData = getShotData("James Harden")
hardenMod1 = glm(EVENT_TYPE~LOC_X+LOC_Y-1, data = hardenData, family = binomial)
summary(hardenMod1)
coefplot(hardenMod1, trans = invlogit, title = "Probability of a Made Shot")
XYCoord = hardenData[,c("LOC_X","LOC_Y")]
ggplot(data = heatMap, aes(x=LOC_X, y=LOC_Y, color=prediction)) + 
  geom_point() + 
  scale_color_gradient(low="blue",high="red")
ggplot(data = heatMap, aes(x=LOC_X, y=LOC_Y, z=prediction)) + 
  geom_point(aes(color = prediction)) +
  geom_density2d()+
  scale_color_gradient(low="blue",high="red")

shotModelFit <- function(player){
  df <- getShotData(player)
  mod <- glm(SHOT_MADE_FLAG~LOC_X+LOC_Y-1, data = df, family = binomial)
  prdct <- df[,c("LOC_X","LOC_Y")]
  prdct$PROB <- predict(mod, newdata = prdct)
  return(prdct)
}
densityShotChart <- function(player){
  df <- shotModelFit(player)
  shotChart <- ggplot(data = df, aes(x=LOC_X, y=LOC_Y, z=PROB)) + 
    xlim(-250,250)+
    ylim(0,400)+
    geom_point(aes(color = PROB)) +
    geom_density2d()+
    scale_color_gradient(low="blue",high="red")
  return(shotChart)
}
