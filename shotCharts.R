library(ggplot2)
library(nlme)

basicShotChart <- function(playerName){
  df <- getShotData(playerName)
  shotChart <- ggplot(df,aes(x=LOC_X, y=LOC_Y)) +
    geom_point(aes(colour = EVENT_TYPE), size = 1)+
    geom_point(aes(x = mean(LOC_X), y = mean(LOC_Y)), size = 2)+
    xlim(-250,250)+
    ylim(-50,420)
  return(shotChart)
}

klayBasic <- basicShotChart("Klay Thompson")

shotModelFit <- function(player){
  df <- getShotData(player)
  mod <- glm(SHOT_MADE_FLAG ~ LOC_X + LOC_Y, 
             data = df, 
             family = binomial)
  prdct <- df[,c("LOC_X","LOC_Y")]
  df$PROB <- predict(mod, newdata = prdct)
  return(df)
}
densityShotChart <- function(player){
  df <- shotModelFit(player)
  shotChart <- ggplot(data = df, aes(x=LOC_X, y=LOC_Y, z=PROB)) + 
      xlim(-250,250)+
      ylim(-50,420)+
      geom_point(aes(color = PROB), alpha = 1/2 ) +
      scale_color_gradient(low="yellow",high="red")+
      stat_density2d(geom = "polygon", n=20, aes(fill=..level..))+
      geom_point(aes(color = PROB), alpha = 1/2)
  return(shotChart)
}

klayDens <- densityShotChart("Klay Thompson")
