library(readxl)
library(plotly)
library(dplyr)

#load data containing all the state names and their abbreviations and the accessibility data
states <- read.csv('./data/statelatlong.csv', stringsAsFactors = FALSE)
average.data <- read_excel('./data/access.xlsx')

#gets rid of column that causes problems for later aggregate
average.data$LACCESS_CHILD_10_15 <- NULL 

#selects the column that matches the needed population and year
selected <- function(population, year) {
  if(population == "Overall Population"){
    df <- select(average.data, starts_with("LACCESS_POP"), starts_with("State"))
  }
  else if(population == "Child") {
    df <- select(average.data, starts_with("LACCESS_CHILD"), starts_with("State"))
  } else {
    df <- select(average.data, starts_with("LACCESS_SENIORS"), starts_with("State"))
  }
  
  if(year == '2015') {
    select(df, starts_with("State"), contains("15"))
  } else {
    select(df, starts_with("State"), contains("10"))
  }
}

#set up and graph data on map below
li <- list(color = toRGB("white"), width = 2)

sc <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

graph <- function(df){
  p <- plot_geo(df, locationmode = 'USA-states') %>%
    add_trace(
      z = ~x, text = ~City, locations = ~State,
      color = ~x, colors = 'Reds'
    ) %>%
    colorbar(title = "Count") %>%
    layout(
      title = 'Low Access to Grocery Store Based on Proximity<br>(Hover for breakdown)',
      geo = sc
    ) 
  return(p)
}

