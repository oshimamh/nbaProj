BIO 453: Quantitative Methods Semester Project
=========================
This project is an analysis of shot location data from the National Basketball Association. 

## shotDataScraper.R
This R script file contains three functions and some other code to gather data from NBA.com

__Gathering the player ID and team ID data__

Using the fromJSON function from the rjson package we can download and read in the data from the NBA's website. This data then has to be unlisted and converted to a dataframe object. This ID data is used to lookup players by name in the functions from this project. The ID dataframe is also subsetted by unique teams to create a dataframe of the teams in the NBA.

__getShotData(playerName)__

This function accepts a player's name as a string in the form "FirstName LastName" and returns a dataframe of shot data for that player from the 2015-16 season. The resulting dataframe includes 21 variables that categorize the location, the context, and result of each shot. Each observation in the dataframe represents a shot taken by that player.

  *Example*

```
## fetch shot data for Klay Thompson
klay <- getShotData("Klay Thompson")
```
__getRoster(teamAbbr)__

This function accepts a team's three character abbreviation as a string and returns a vector of each player ("FirstName LastName") on that team. 

*Example*
```
# fetch roster for the Golden State Warriors
gswRoster <- getRoster("GSW")
```
__getTeamShooting(team)__

This function accepts a team's three character abbreviation as a string and returns a dataframe of shot data for each player on that team. The function loops through the roster of the team and aggregates the shot data of each player on the roster.

*Example*
```
# fetch team shooting data for the Golden State Warriors
gswShooting <- getTeamShooting("GSW")
```


  




