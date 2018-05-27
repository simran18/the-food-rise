library(plotly)
library(dplyr)
library(tidyr)
library(plyr)
library(ggplot2)
library(readxl)

# loading the data
stores.data <- read_excel("data/Stores-Accessibility.xlsx")
fm.data <- read_excel("data/Local-Accessibility.xlsx")

# selecting the needed variables
stores.data <- select(stores.data, c("State", "GROCPTH09", "GROCPTH14",
                                     "SUPERCPTH09", "SUPERCPTH14", "CONVSPTH09",
                                     "CONVSPTH14"))
fm.data <- select(fm.data, c("State", "FMRKTPTH09", "FMRKTPTH16"))


# finding average values by state
stores.mean <- aggregate(stores.data[-1], list(stores.data$State), mean)

fm.mean <- aggregate(fm.data[-1], list(fm.data$State), mean, na.rm=T)

# joining the datasets
buy.data <- left_join(stores.mean, fm.mean, by = "Group.1")
colnames(buy.data)[1] <- "State"

# selecting data for 2009
buy.old <- select(buy.data, ends_with("09"))
buy.old$State <- buy.data$State
buy.old <- gather(buy.old, "Type", "Value", -State)

# selecting data for 2016
buy.new <- select(buy.data, -ends_with("09"))
buy.new <- gather(buy.new, "Type", "Value", -1)


state.y.plot <- function(State) {
  state.old <- buy.old[which(buy.old$State == State),]
  state.new <- buy.new[which(buy.new$State == State),]
  
  plot.o- plot_ly(state.old, x = ~Type, y = ~Value, type = 'bar') %>% 
             layout(xaxis = list(tickmode = "array",
                    ticktext = c("Convenience Stores", "Farmers Market", "Grocery Stores", "Supercenters")))
  
  plot.new<- plot_ly(state.new, x = ~Type, y = ~Value, 
                     type = 'bar') 
  
   plot.out <- subplot(plot.old, plot.new) %>% 
             layout(title = ~paste("Comparison of Accessibility by Different Types of Stores"),
                 yaxis = list(title = '# Per 1,000 Pop.'))
  
  return(plot.o)
}


