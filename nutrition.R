library(plotly)
library(dplyr)
library(tidyr)
library(plyr)
library(ggplot2)

obes.pa.data <- read.csv("data/Physical_Activity_Obesity.csv", stringsAsFactors = F)
obes.pa.data <- obes.pa.data[which(obes.pa.data$Class != "Fruits and Vegetables"),]

# organizing the data for 2016 for state comparison
nutr.data <- filter(obes.pa.data, YearStart == 2016 & 
                                LocationDesc != "National" & Total == "Total" & QuestionID != "Q037") %>%
             select(c("LocationAbbr", "LocationDesc", "Class", "Data_Value"))  

nutr.data <- filter(nutr.data, LocationAbbr != "PR" & LocationAbbr != "GU" & LocationAbbr != "VI")

# making the data wide for analysis
nutr.2016 <- spread(data = nutr.data, key = Class, value = Data_Value)
colnames(nutr.2016) <- c("State", "StateFull", "Obesity", "NoPhysicalActivity")

# comparison between states
plot.a <- plot_ly(nutr.2016, y = ~State, x = ~Obesity, 
                  type = 'bar', name = 'Obesity', 
                  marker = list(color = 'rgb(139,0,0)'), orientation = "h") %>%
  add_trace(x = ~NoPhysicalActivity, name = 'No Physical Activity', 
            marker = list(color = 'rgb(0,200,200)')) %>%
  layout(xaxis = list(title = "Percentage Value"), 
         yaxis = list(title = "US States"), barmode = 'stack',
         title = "State-Wise Comparison of Obesity & No Physical Activity")

plot.b <- plot_ly(nutr.2016, x = ~State, y = ~Obesity, type = 'scatter',
                  mode = 'marker', color = ~NoPhysicalActivity, size = ~Obesity, hoverinfo = 'text',
                  text = ~paste(StateFull,
                                "</br>", "No Physical Activitity: ", NoPhysicalActivity, "%",
                                "</br> Obesity: ", Obesity, "%")) %>% 
          layout(xaxis = list(title = "", tickangle = 45), 
                 yaxis = list(title = "Percentage Value"),
                 title = "State-Wise Comparison of Obesity & No Physical Activity")


# for report analysis
plot.e <- ggplot(nutr.data, aes(x = LocationDesc, y = Data_Value, fill = Class)) + 
  geom_bar(subset = .(Class == "Obesity / Weight Status"), stat = "identity") + 
  geom_bar(subset = .(Class == "No Physical Activity"), stat = "identity") + 
  scale_y_continuous(breaks = seq(-45, 45, 5)) +
  coord_flip() + 
  labs (x = "Percentage Value", y = "US States",
        title = "State-Wise Comparison of Obesity & No Physical Activity")
  scale_fill_brewer(palette = "Set1") 
  

# conduct analysis about states
# highest obesity
high.obes <- nutr.2016[which.max(nutr.2016$Obesity),]$StateFull
high.obes.val <- nutr.2016[which.max(nutr.2016$Obesity),]$Obesity

# lowest obesity
low.obes <- nutr.2016[which.min(nutr.2016$Obesity),]$StateFull
low.obes.val <- nutr.2016[which.min(nutr.2016$Obesity),]Obesity

# lowest physical activity
low.pa <- nutr.2016[which.max(nutr.2016$NoPhysicalActivity),]$StateFull
low.pa.val <- nutr.2016[which.max(nutr.2016$NoPhysicalActivity),]$NoPhysicalActivity

# highest physical activity
high.pa <- nutr.2016[which.min(nutr.2016$NoPhysicalActivity),]$StateFull
high.pa.val <- nutr.2016[which.min(nutr.2016$NoPhysicalActivity),]$NoPhysicalActivity

# average pa 
mean.pa <- mean(nutr.2016$NoPhysicalActivity)

# average obesity
mean.ob <- mean(nutr.2016$Obesity) 

# priority states (check values of unhealthy)
prior.data <- filter(nutr.2016, Obesity >= 34 | NoPhysicalActivity >= 29)

# indepth analysis - select function - only for priority or all?
# show trend over the years from 2011 - 2016 by selecting state

yearly.data <- filter(obes.pa.data, Total == "Total") %>% 
               filter(QuestionID == "Q036" | QuestionID == "Q047") %>% 
               select(c("YearStart", "LocationDesc", "Class", "Data_Value"))  
state.plot <- function(State) {
  state.data <- yearly.data[which(yearly.data$LocationDesc == State),]
  plot.out <- plot_ly(state.data, x = ~YearStart, y = ~Data_Value, color = ~Class, 
                      type = 'scatter', mode = 'lines+markers') %>% 
              layout(title = ~paste("Trend of No Physical Activity & Obesity in", State, "Over The Years"),
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
