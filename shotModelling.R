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
densMat$yCoord = YCOORD
densMat$xCoord = XCOORD
densMat$attempt = attempt
densMat = as.data.frame(densMat)
densMat$yCoord = densMat$yCoord - 51
densMat$xCoord = densMat$xCoord - 251

attemptMod <- lm(attempt ~ xCoord + yCoord, data = densMat)
klayShotMake <- shotModelFit("Klay Thompson")

klayShotModel <- attemptMod

head(klayShotModel)



head(klay)
