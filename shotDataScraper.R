require(rjson)
require(ggplot2)
require(nlme)


## create a list of all players and teams in the NBA from 2001-2016
idURL <- paste("http://stats.nba.com/stats/commonallplayers?",
               "IsOnlyCurrentSeason=1&LeagueID=00&Season=2015-16",
               sep = "")

idData <- fromJSON(file = idURL, method="C")
idDf<- data.frame(
  matrix(unlist(idData$resultSets[[1]][[3]]), ncol = 13,byrow = TRUE),
  stringsAsFactors = FALSE)
colnames(idDf)<- idData$resultSets[[1]][[2]]

#extract team IDs
teamIdDf <- unique(
  subset(idDf,TEAM_ID>0, select = TEAM_ID:TEAM_CODE)
)

getShotData <- function(playerName){

  ndx <- which(idDf$DISPLAY_FIRST_LAST %in% playerName)
  player <- idDf[ndx,1]
  
  shotURL <- paste("http://stats.nba.com/stats/shotchartdetail?CFID=&CFPARAMS",
                   "=&ContextFilter=&ContextMeasure=FGA&DateFrom=&DateTo=&",
                   "GameID=&GameSegment=&LastNGames=0&",
                   "LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&",
                   "Period=0&Position=&RookieYear=&SeasonSegment=&",
                   "SeasonType=Regular+Season&TeamID=0&VsConference=&",
                   "VsDivision=&PlayerID=",player,
                   "&Season=2015-16",
                   sep = "")
  shotData <- fromJSON(file = shotURL, method="C")
  shotDataf <- data.frame(
    matrix(unlist(shotData$resultSets[[1]][[3]]),
      ncol=21, byrow = TRUE)
  )
  #set column names
  colnames(shotDataf) <- shotData$resultSets[[1]][[2]]
  #convert coordinates to numerics
  shotDataf$LOC_X <- as.numeric(
    as.character(shotDataf$LOC_X)
  )
  shotDataf$LOC_Y <- as.numeric(
    as.character(shotDataf$LOC_Y)
  )
  shotDataf$SHOT_DISTANCE <- as.numeric(
    as.character(shotDataf$SHOT_DISTANCE)
  )
  shotDataf$MINUTES_REMAINING <- as.numeric(
    as.character(shotDataf$MINUTES_REMAINING)
  )
  shotDataf$SECONDS_REMAINING <- as.numeric(
    as.character(shotDataf$SECONDS_REMAINING)
  )
  shotDataf[which(shotDataf$LOC_X >= -250 & shotDataf$LOC_X <= 250 & shotDataf$LOC_Y >= -50 & shotDataf$LOC_Y <= 420),]
  return(shotDataf)
}

getRoster <- function(teamAbbr){
  tmNdx <- which(teamIdDf$TEAM_ABBREVIATION %in% teamAbbr)
  teamId <- teamIdDf[tmNdx,1]
  plNdx <- which(idDf$TEAM_ID %in% teamId)
  roster <- idDf[plNdx,3]
  return(roster)
}

getTeamShooting <- function(team){
  teamShotData <- NULL
  ros <- getRoster(team)
  for (i in 1:length(ros)){
    playerShot <- getShotData(ros[i])
    teamShotData <- rbind(teamShotData, playerShot)
  }
  return(teamShotData)
}

getCentroids <- function(player){
  df <- getShotData(player)
  
  paintShots = df[which(df$LOC_X <= 100 & df$LOC_X >= -100 & df$LOC_Y <= 100),]
  lCornerShots = df[which(df$LOC_X <= -100 & df$LOC_Y <= 100),]
  rCornerShots = df[which(df$LOC_X >= 100 & df$LOC_Y <= 100),]
  topArchShots = df[which(df$LOC_X <= 100 & df$LOC_X >= -100 & df$LOC_Y >= 100),]
  lArchShots = df[which(df$LOC_X <= -100 & df$LOC_Y >= 100),]
  rArchShots = df[which(df$LOC_X >= 100 & df$LOC_Y >= 100),]
  
  meanPaint = c(mean(paintShots$LOC_X), mean(paintShots$LOC_Y), mean(paintShots$LOC_X[which(paintShots$SHOT_MADE_FLAG == 1)]), mean(paintShots$LOC_Y[which(paintShots$SHOT_MADE_FLAG == 1)]))
  meanLCorner = c(mean(lCornerShots$LOC_X), mean(lCornerShots$LOC_Y), mean(lCornerShots$LOC_X[which(lCornerShots$SHOT_MADE_FLAG == 1)]), mean(lCornerShots$LOC_Y[which(lCornerShots$SHOT_MADE_FLAG == 1)]))
  meanRCorner= c(mean(rCornerShots$LOC_X), mean(rCornerShots$LOC_Y), mean(rCornerShots$LOC_X[which(rCornerShots$SHOT_MADE_FLAG == 1)]), mean(rCornerShots$LOC_Y[which(rCornerShots$SHOT_MADE_FLAG == 1)]))
  meanTopArch = c(mean(topArchShots$LOC_X), mean(topArchShots$LOC_Y), mean(topArchShots$LOC_X[which(topArchShots$SHOT_MADE_FLAG == 1)]), mean(topArchShots$LOC_Y[which(topArchShots$SHOT_MADE_FLAG == 1)]))
  meanLArch = c(mean(lArchShots$LOC_X), mean(lArchShots$LOC_Y), mean(lArchShots$LOC_X[which(lArchShots$SHOT_MADE_FLAG == 1)]), mean(lArchShots$LOC_Y[which(lArchShots$SHOT_MADE_FLAG == 1)]))
  meanRArch = c(mean(rArchShots$LOC_X), mean(rArchShots$LOC_Y), mean(rArchShots$LOC_X[which(rArchShots$SHOT_MADE_FLAG == 1)]), mean(rArchShots$LOC_Y[which(rArchShots$SHOT_MADE_FLAG == 1)]))
  
  centroids = as.data.frame(rbind(meanPaint, meanLCorner, meanRCorner, meanLArch, meanRArch, meanTopArch))
  colnames(centroids) = c("AttemptX", "AttemptY", "MakeX", "MakeY")
  
  return(centroids)
  
}
