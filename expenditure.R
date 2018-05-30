library(plotly)
library(dplyr)
library(tidyr)
library(readxl)


expenditure_changed <- read_excel("./data/expenditure.xlsx")

expenditure_changed$hover <- with(expenditure_changed,
                                  paste(States, '<br>', "Total Expenditure(in million $):", total_2014,
                                        "<br> Dollars spent on food and beverages(per capita):", food_and_beverages_2016, "<br>")
                                  )
states <- read.csv("./data/statelatlong.csv")

colnames(states) <- c("abb", "Latitude", "Longitude", "States")

expenditure_changed <- left_join(expenditure_changed, states, by = "States")
# input can be total_2014, total_2015, total_2016
total_exp <- function(input) {
  #Give states white boundaries
  l <- list(color = toRGB("white"), width = 2)
  
  # specify some map projection/options
  g <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showlakes = TRUE,
    lakecolor = toRGB('dodgerblue3')
  )
  
  map_p <- plot_geo(expenditure_changed, locationmode = 'USA-states') %>%
    add_trace(
      z = ~eval(as.name(paste(input))), text = ~hover, locations = ~abb,
      color = ~eval(as.name(paste(input))), colors = 'Greens'
    ) %>%
    colorbar(title = "Expenditure (Million USD)") %>%
    layout(
      title = 'Total Personal Consumption Expenditures by State',
      geo = g
    )
  
  return(map_p)
}

#############
#Bubble plot#
#############

colors <- c('#4AC6B7', '#1972A4', '#965F8A', '#FF7070', '#C61951', '#DCEDC1', '#F0CA4D')
slope <- 2.666051223553066e-05
expenditure_changed$size <- sqrt(expenditure_changed$percent_change * slope)

bubble_p <- plot_ly(expenditure_changed, x = ~food_and_beverages_2016, y = ~expenditures_dollar_2016, color = ~region, size = ~percent_change, colors = colors,
             type = 'scatter', mode = 'markers',
             marker = list(symbol = 'circle', sizemode = 'diameter',
                           line = list(width = 2, color = '#FFFFFF')),
             text = ~paste('State:', States, '<br>% change:', percent_change, '<br>$ on Food and Beverages:', food_and_beverages_2016,
                           '<br>Total Expenditure(in Million USD):', total_2016)) %>%
  layout(title = 'Total expenditure vs Food and beverage spending',
         xaxis = list(title = 'Food and Beverage spending per capita (USD)',
                      gridcolor = 'rgb(255, 255, 255)',
                      zerolinewidth = 1,
                      ticklen = 5,
                      gridwidth = 2),
         yaxis = list(title = 'Per Capita Total Expenditure (USD)',
                      gridcolor = 'rgb(255, 255, 255)',
                      zerolinewidth = 1,
                      ticklen = 5,
                      gridwith = 2),
         paper_bgcolor = 'rgb(243, 243, 243)',
         plot_bgcolor = 'rgb(243, 243, 243)')
