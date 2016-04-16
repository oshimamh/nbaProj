
## This is the R script that is used to scrape data from nba.com. It also
## creates an example data frame with klay thompson's shot data. 
## The most used function is getShotData(). There is also getRoster() and getTeamShooting()
source('./shotDataScraper.R')

## This is the R script that contains the functions to create shot charts using
## data scraped from the web. It also creates example charts for Klay Thompson.
## There are two shot chart types basicShotChart() and densityShotChart(). 
## There is also a function to get shot success model for a player, shotModelFit().
source('./shotCharts.R')

## This is the R script that contains a function to scrape play type data from NBA.com
## Function created here is getPlayData(). Also gathers some example data to work with.
source('./playTypeScraper.R')
