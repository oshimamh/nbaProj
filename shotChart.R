library(rjson)
library(ggplot2)
library(hexbin)
library(gstat)
library(js)
library(V8)

## create a list of all players and teams in the NBA from 2001-2016
idURL <- paste("http://stats.nba.com/stats/commonallplayers?",
               "IsOnlyCurrentSeason=0&LeagueID=00&Season=2015-16", 
               sep = "")

idData <- fromJSON(file = idURL, method="C")
idDf<- data.frame(
  matrix(
    unlist(idData$resultSets[[1]][[3]]),
    ncol = 13,byrow = TRUE), 
  stringsAsFactors = FALSE)
colnames(idDf)<- idData$resultSets[[1]][[2]]
head(idDf)
#subset player IDs to only include current players
curPlayerId <- subset(idDf, TEAM_ID>0 & GAMES_PLAYED_FLAG>0, 
                     select = PERSON_ID:TEAM_ID)
#extract team IDs
teamIdDf <- unique(
  subset(idDf,TEAM_ID>0, select = TEAM_ID:TEAM_CODE)
  )

getShotData <- function(player){
  shotURL = paste("http://stats.nba.com/stats/shotchartdetail?CFID=&CFPARAMS=&",
                  "ContextFilter=&",
                  "ContextMeasure=FGA&DateFrom=&DateTo=&GameID=&GameSegment=&LastNGames=0&",
                  "LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&",
                  "Period=0&Position=&RookieYear=&SeasonSegment=&",
                  "SeasonType=Regular+Season&TeamID=0&VsConference=&",
                  "VsDivision=&",
                  "PlayerID=",player,
                  "&Season=2015-16",
                  sep = "")
  shotData = fromJSON(file = shotURL, method="C")
  shotDataf = data.frame(
    matrix(
      unlist(shotData$resultSets[[1]][[3]]),
      ncol=21, byrow = TRUE)
    )
  #set column names
  colnames(shotDataf) = shotData$resultSets[[1]][[2]]
  #convert coordinates to numerics
  shotDataf$LOC_X = as.numeric(
    as.character(shotDataf$LOC_X)
    )
  shotDataf$LOC_Y = as.numeric(
    as.character(shotDataf$LOC_Y)
    )
  shotDataf$SHOT_DISTANCE = as.numeric(
    as.character(shotDataf$SHOT_DISTANCE)
    )
}
plotShotChart = function(playerShotData){
  ggplot(playerShotData, 
         aes(x=LOC_X, y=LOC_Y)
  ) +
    geom_point(
      aes(colour = EVENT_TYPE)
    )
}
