library(plotly)
library(dplyr)
library(tidyr)
library(plyr)
library(ggplot2)

obes.pa.data <- read.csv("data/Physical_Activity_Obesity.csv", stringsAsFactors = F)
obes.pa.data <- obes.pa.data[which(obes.pa.data$Class != "Fruits and Vegetables"),]
obes.pa.data <- filter(obes.pa.data, LocationAbbr != "PR" & LocationAbbr != "GU" & LocationAbbr != "VI")

# organizing the data for 2016 for state comparison
nutr.data <- filter(obes.pa.data, YearStart == 2016 & 
                                LocationDesc != "National" & Total == "Total" & QuestionID != "Q037") %>%
             select(c("LocationAbbr", "LocationDesc", "Class", "Data_Value"))  



# making the data wide for analysis
nutr.2016 <- spread(data = nutr.data, key = Class, value = Data_Value)
colnames(nutr.2016) <- c("State", "StateFull", "Obesity", "PhysicalInactivity")

# comparison between states
plot.a <- plot_ly(nutr.2016, y = ~State, x = ~Obesity, 
                  type = 'bar', name = 'Obesity', 
                  marker = list(color = 'rgb(139,0,0)'), orientation = "h") %>%
  add_trace(x = ~PhysicalInactivity, name = 'Physical Inactivity', 
            marker = list(color = 'rgb(0,200,200)')) %>%
  layout(xaxis = list(title = "Percentage Value"), 
         yaxis = list(title = "US States"), barmode = 'stack',
         title = "State-Wise Comparison of Obesity & Physical Inactivity")

plot.b <- plot_ly(nutr.2016, x = ~State, y = ~Obesity, type = 'scatter',
                  mode = 'marker', color = ~PhysicalInactivity, size = ~Obesity, hoverinfo = 'text',
                  text = ~paste(StateFull,
                                "</br>", "Physical Inactivity: ", PhysicalInactivity, "%",
                                "</br> Obesity: ", Obesity, "%")) %>% 
          layout(xaxis = list(title = "", tickangle = 45), 
                 yaxis = list(title = "Percentage Value"),
                 title = "State-Wise Comparison of Obesity & Physical Inactivity")


# for report analysis
rep.nutr.data <- nutr.data

for (i in 1:nrow(rep.nutr.data)) {
  if(rep.nutr.data$Class[i] != "Physical Activity") {
    rep.nutr.data$Data_Value[i] <- rep.nutr.data$Data_Value[i] * -1
  }
}

rep.nutr.data <- with(rep.nutr.data, rep.nutr.data[order(Class,Data_Value),])

rep.nutr.data <- rep.nutr.data[order(rep.nutr.data$Data_Value),]

plot.e <- ggplot(rep.nutr.data, aes(x = LocationDesc, y = Data_Value, fill = Class)) + 
  geom_bar(subset = .(Class == "Obesity / Weight Status"), stat = "identity") + 
  geom_bar(subset = .(Class == "Physical Activity"), stat = "identity") + 
  scale_y_continuous(breaks = seq(-45, 45, 5)) +
  coord_flip() + 
  labs (x = "Percentage Value", y = "US States",
        title = "State-Wise Comparison of Obesity & Physical Inactivity")
  scale_fill_brewer(palette = "Set1") 
  

# conduct analysis about states
# highest obesity
high.obes <- nutr.2016[which.max(nutr.2016$Obesity),]$StateFull
high.obes.val <- nutr.2016[which.max(nutr.2016$Obesity),]$Obesity

# lowest obesity
low.obes <- nutr.2016[which.min(nutr.2016$Obesity),]$StateFull
low.obes.val <- nutr.2016[which.min(nutr.2016$Obesity),]$Obesity

# lowest physical activity
high.pia <- nutr.2016[which.max(nutr.2016$PhysicalInactivity),]$StateFull
high.pia.val <- nutr.2016[which.max(nutr.2016$PhysicalInactivity),]$PhysicalInactivity

# highest physical activity
low.pia <- nutr.2016[which.min(nutr.2016$PhysicalInactivity),]$StateFull
low.pia.val <- nutr.2016[which.min(nutr.2016$PhysicalInactivity),]$PhysicalInactivity

# average pa 
mean.pa <- mean(nutr.2016$PhysicalInactivity)

# average obesity
mean.ob <- mean(nutr.2016$Obesity) 

# priority states (check values of unhealthy)
prior.data <- filter(nutr.2016, Obesity >= 34 | PhysicalInactivity >= 29)

# indepth analysis - select function
yearly.data <- filter(obes.pa.data, Total == "Total") %>% 
               filter(QuestionID == "Q036" | QuestionID == "Q047") %>% 
               select(c("YearStart", "LocationDesc", "Class", "Data_Value"))  

yearly.data <- yearly.data[order(yearly.data$YearStart),]

# plot all obesity over year for each state
obes.pa.y <- spread(data = yearly.data, key = Class, value = Data_Value)
colnames(obes.pa.y) <- c("Year", "State", "Obesity", "PhysicalInactivity")

# filter for state?
plot.ob <- plot_ly(obes.pa.y, x = ~Year, y = ~Obesity, color = ~State,
                   type = 'scatter', mode = 'lines+markers') %>% 
          layout(title = ~paste("Trend of Obesity Over The Years"),
                 xaxis = list(title = "Years"),
                 yaxis = list(title = 'Obesity Percentage Value'))


# plot all physical inactivity over years for each state
plot.pa <- plot_ly(obes.pa.y, x = ~Year, y = ~PhysicalInactivity, color = ~State,
                   type = 'scatter', mode = 'lines+markers') %>% 
  layout(title = ~paste("Trend of Physical Inactivity Over The Years"),
         xaxis = list(title = "Years"),
         yaxis = list(title = 'Physical Inactivity Percentage Value'))


# show trend over the years from 2011 - 2016 by selecting state
state.plot <- function(State) {
  state.data <- yearly.data[which(yearly.data$LocationDesc == State),]
  plot.out <- plot_ly(state.data, x = ~YearStart, y = ~Data_Value, color = ~Class, 
                      type = 'scatter', mode = 'lines+markers') %>% 
              layout(title = ~paste("Trend of Physical Inactivity & Obesity in", State, "Over The Years"),
                     xaxis = list(title = "Years"),
                     yaxis = list(title = 'Percentage Value'))

  return(plot.out)
}

# show distribution of nutritional value by selecting state, year, type and social determinant
obes.pa.depth <- filter(obes.pa.data, QuestionID == "Q036" | QuestionID == "Q047") %>% 
                select(c("YearStart", "LocationDesc", "Class", "Data_Value", 
                         "StratificationCategory1", "Stratification1"))

indepth.plot <- function(State, Class, Year, Type) {
  indepth.data <- filter(obes.pa.depth, LocationDesc == State & YearStart == Year & 
                         Class == Class & StratificationCategory1 == Type) %>%  
                  select("Stratification1", "Data_Value") 
  plot.out <- plot_ly(indepth.data, labels = ~Stratification1, values = ~Data_Value, type = 'pie') %>% 
              layout(title = ~paste("Percentage Distribution of", Class,"in", State, "by", Type, "in", Year),
                     xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                     yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                     showlegend = T)
  
  return(plot.out)
}

# Analysis for the report for 2 states (West Virginia & Arkansas) in 2016

# top state is West Virginia for Obesity
# add state.plot("West Virginia")
# It shows that obesity rates increased while physical inactivity rates decreased, indicating 
# that there is no direct correlation between these two values. 

# gender
# add indepth.plot("West Virginia", "Obesity / Weight Status", 2016, "Gender")
# the gender distribution is equal, with males being marginally more obese than women. 

# income 
# add indepth.plot("West Virginia", "Obesity / Weight Status", 2016, "Income")
# Even though minorly, it shows that low income households have higher obesity (with 16.2%) as
# compared to high income households (with 12.5%)

# education
# add indepth.plot("West Virginia", "Obesity / Weight Status", 2016, "Education")
# It shows that there is an equal distribution in terms of education, 
# high school graduates are the most obese

# age (years)
# add indepth.plot("West Virginia", "Obesity / Weight Status", 2016, "Age (years)")
# It is interesting to note that even though high school graduates are the most obese, in terms of years the 
# age group of 45-54 years (with 20.7%) is the most obese and 18-24 years (with 11.6%) is the least obese.


# Top state for Physical Inactivity is Arkansas in 2016
# add state.plot("Arkansas")
# This plot shows that as obesity increases, Physical Inactivity is also relatively high. Even though
# the population of this state has been physically inactive in the past years (comparatively), in 2016 it 
# had it's highest obesity rates as well. This graph shows that there is some relation at the least between
# these two values. 

# Gender
# add indepth.plot("Arkansas", "Physical Activity", 2016, "Gender")
# This shows that males are more physically inactive as compared to females in Arkansas.

# Income
# indepth.plot("Arkansas", "Physical Activity", 2016, "Income")
# The distribution shows that lower the household income, higher is the rate for physical inactivity. This
# indicates that being physically active is more for the riches. 

