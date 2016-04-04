library(ggplot2)
library(nlme)
library(ggmap)
library(png)
library(grid)
library(gridExtra)
library(spatial)
library(gstat)
library(rgeos)

library(sp)

shots = SpatialPoints(coords = klay[ , c('LOC_X', 'LOC_Y')])
x = GridTopology(c(0,0), c(1,1), c(500,470))
court = SpatialGrid(x)
bins = over(court, shots)
binMat = matrix(bins, 500, 470)

YCOORD <- NULL
XCOORD <- NULL
attempt <- NULL
for (i in 1:ncol(binMat)){
  for (j in 1:nrow(binMat)){
    YCOORD <- append(YCOORD,j)
    XCOORD <- append(XCOORD,i)
  }
}

for (i in 1:length(YCOORD)){
  attempt <- append(attempt, bins[i])
}

attempt[is.na(attempt)] <- 0

densMat = NULL
densMat$LOC_Y = YCOORD
densMat$LOC_X = XCOORD
densMat$attempt = attempt
densMat = as.data.frame(densMat)
densMat$LOC_Y = densMat$LOC_Y - 51
densMat$LOC_X = densMat$LOC_X - 251

attemptMod <- lm(attempt ~ LOC_X + LOC_Y, data = densMat)
mod <- glm(SHOT_MADE_FLAG ~ LOC_X + LOC_Y, 
           data = klay, 
           family = binomial)

klayShotModel <- densMat
klayShotModel$shotMakePrediction <- predict(mod, newdata = klayShotModel)
klayShotModel$shotAtmptPrediction <- predict(attemptMod, newdata = klayShotModel)

klayShotModel$shotPrediction <- klayShotModel$shotMakePrediction * klayShotModel$shotAtmptPrediction

head(klayShotModel)
