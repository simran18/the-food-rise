library(shiny)
library(shinydashboard)
library(plotly)

ui <- dashboardPage(
  dashboardHeader(title = "The Food Rise"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("home", lib = "glyphicon")),
      menuItem("Expenditure", tabName = "expenditure", icon = icon("usd", lib = "glyphicon")),
      menuItem("Nutrition", tabName = "nutrition", icon = icon("glass", lib = "glyphicon")),
      menuItem("Access", tabName = "access", icon = icon("map-marker", lib = "glyphicon")),
      menuItem("Predictive Clustering", tabName = "kmeans", icon = icon("stats", lib = "glyphicon")),
      menuItem("Report", tabName = "report", icon = icon("info-sign", lib = "glyphicon"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "intro",
              h2("What is Food Security?"),
              p("Food security refers to a community’s access to sustainable and nutritious foods (James Brandon). 
                 According to a current accepted definition (FAO 2000), ‘Food Security’ is achieved when it is 
                 ensured that “all people, at all times, have physical, social and economic access to 
                 sufficient safe and nutritious food, which means their dietary needs and food preferences 
                 for are active and healthy life.”"),
              h2("How does it affect America?"),
              p("41 million Americans struggle with hunger, a number nearly equal to the 40.6 million officially 
                living in poverty. The studies have shown that food insecurity has harsh effects on the human 
                health and can lead to a higher risk of adverse outcomes. The plot below shows the current rate of
                Food Insecurity for each state in the country."),
              box(status = "warning",width = 16,plotlyOutput("plot.insec")),
              h2("What is our purpose?"),
              p("At Food Rise, we focus on Food Expenediture, Nutrition and Accessibility to deeply 
                 understand the issues and find the priority geographic locations for Food Security."),
              h3("Our Scope"),
              h4("Expenditure"),
              p("Food expenditure measures the total expense made on the food annually by the population. 
                We go over the overall spending activities that attributable to the residents of a state and 
                compare per capita total expenditure to their food and beverage spending."),
              h4("Nutrition"),
              p("It is hard to Obesity/weight status, physical inactivity and see if there is a 
                correlation using those 2 factors and see if they have a correlation for each state. 
                To measure nutrition is a tricky situation, given the definition of nutritious food 
                changing so drastically hence we choose to focus on the factors of Obesity/Weight Status and 
                Physical Inactivity. Nutrition security  refers to access by all people at all times to the 
                adequate utilization and absorption of nutrients in food, in order to be able to live a healthy 
                and active life."),
              h4("Acccessibility"),
              p("Access to food stores and food security are connected in the population’s ability to access food, 
                and possibly healthy food, in a reasonable distance from their home. Specifically, if a 
                person does not have access to a grocery store, they may struggle finding an adequate amount of 
                food to feed their household."),
              div(imageOutput("img"), align = "center"),
              br(),
              h2("Analysis Overview"),
              h3("Data Overview"),
              div(imageOutput("img2"), align = "center"),
              h3("Who We Are?"),
              p("This project was made by Madeline Holmes, Simran Bhatia, Nirmalya Ghosh, Kishore Vassan, 
                 and Shreyal Anand as part of a project to produce new information in the public health measurement field.")
      ), 
      
      tabItem(tabName = "expenditure",
              h2("How does Food Expenditure effect Food Security in America?"),
              p("14.3 percent households were food insecure at least once during the year, 
                including 5.6 percent with very low food security, meaning that the food intake of one or more 
                household members was reduced and their eating patterns were disrupted at times during the year 
                because the household lacked money and other resources for food."),
              h2("How much does America spend?"),
              p("The map shows us the total expenditure of each state for durable and non-durable goods and services.
                 For the scope of the project, we will be looking at services and more specifically, Food services."),
              h6("Explaining the terms: 
                  1. PCE by state reflects spending on activities that are
                     attributable to the residents of a state, even when those
                     activities take place outside of the state.
                 2. Per Capita PCE by state masures average PCE spending per person in a state and 
                    it is calculated as PCE in a state divided by the population of the state."),
              selectInput("expYear", "Year:",
                          c("2014" = "total_2014",
                            "2015" = "total_2015",
                            "2016" = "total_2016")),
              box(status = "warning",width = 16,plotlyOutput('totalExp')),
              br(),
              h2("How does America spend on Food?"),
              p("The average American household spends $2983.49 on food and beverages in a year. This value is lower 
                 than other households globally. The US spends the least at 6.4%, Singapore spends the second lowest 
                 amount at 6.7%. Canada spends 9.1% on food, while Australia spends 9.8%."),
              p("The plot below shows distribution of all 50 states and the District of Columbia into 8 disinct regions for purposes of presentation and analysis. 
                The two variables used to plot this, Per Capita Total Expenditure and Food and spending per capita, in USD. 
                The size represents the percentage change in food and beverage spending from the previous year. 
                Greater the size, more the change in spending."),
              p("Double click on the region for detailed analysis specific to the selected region."),
              div(plotlyOutput("perCapitaBubble", height = "100%", width = "80%"), 
                      align = "center"),
              h3("Overview"),
              p("District of Columbia stands out, being the highest in both the chosen variables and South East 
                states contirbuting to the lower values of the graph. Most of the states are concentrated 
                between the range of $2700-$3200 for F&B spending but ranging from $30k to almost $50k in 
                Per capita total expenditure. This helps identify District of Columbia as a risk zone for food 
                security in terms of expenditure.")
        ),
      tabItem(tabName = "nutrition",
              h1("Nutrition"),
              h3("What is the relation between food security and nutrition?"),
              p("The nutrition focus in Food Security adds the aspects of caring practices and health services 
                & healthy environments to this definition and concept. This is also known as Nutrition security, 
                which refers to access by all people at all times to the adequate utilization and absorption 
                of nutrients in food, in order to be able to live a healthy and active life. To measure nutrition 
                is a tricky situation, given the definition of nutritious food changing so drastically (add source).
                So, to accurately measure nutrition index in a state, the report focuses on the factors of 
                Obesity/Weight Status and Physical Inactivity."),
              box(status = "warning",width = 16,plotlyOutput("nationalTrend")),
              br(),
              br(),
              h3("National Comparison by State"),
              p("This section of the report focuses on analyzing data from the CDC’s Nutrition, Physical Activity and 
                Obesity Data to measure the Nutrition Index of each state. The specific questions used for this analysis
                are Percentage of Adults who have obesity and Percentage of Adults who engage in no leisure-time activity."),
              box(status = "warning",width = 16,plotlyOutput("plot.b")),
              p("The plot above shows a comparison for each US State in terms of Obesity and Physical Inactivity in 2016. This
                helps identify the range of nutrition related problems in each state in terms of obesity and physical inactivity. 
                The size of the dot refers to the population percentage that is obese in the state and the colour scale refers to 
                the population percentage that is inactive in the same state."),
              p("Hover over for exact values of each."),
              br(),
              h3("What is the Nutritional Trend over time?"),
              p("The next part of the analysis focuses on Obesity and Physical Inactivity as important issues in the country
                and how it affects the nation's population, in terms of location and time. Taking the analysis further, 
                the top 10 risk zone states for these factors are:"),
              p("Alabama, Arkansas, Florida, Georgia, Kentucky, Louisana, Mississippi, New Jersey, Tennessee, West Virginia
                (in no particular order)."),
              h4("Obesity"),
              p("These values show that 1 in 5 adults in the US is obese. This matches with the findings from the OECD
                update about obesity in 2017, which states that “Adult obesity rates are highest in the United States, Mexico,
                New Zealand and Hungary.” Taking a deeper look, it is found that the highest rate of obesity is found in 
                West Virginia, where in 37.7 % of the population is obese whereas the lowest rate of obesity is in 
                Colorado, where in 22.3% of the population is obese. These two values indicate the broad range of 
                obesity in each state. It shows a need to normalize these values for the entire country to help reduce obesity 
                rates."),
              br(),
              p("The plot below shows the trend for obesity over a 5 year time period for the top 10 risk zone states. 
                Double-click the legend name for selecting a particular state. "),
              box(status = "warning",width = 16,plotlyOutput("plot.ob")),
              br(),
              br(),
              h4("Physical Inactivity"),
              p("While the US is not a high risk country for physical inactivity as compared to other countries, 
                it still lies in the second risk zone according to WHO’s report on Prevalence of 
                Insufficient Physical Activity. In the country, the highest rate of physical inactivity is 
                in Arkansas, with a reported percentage of 32.5 percent. At the same time, the state with 
                lowest rate of physical inactivity is Utah, at only 22.3%. 
                It is shocking to see that the values are almost double of one another."),
              br(),
              p("The plot below shows the trend for physical inactivity over a 5 year time period for the top 10 risk zone states. 
                Double-click the legend name for selecting a particular state. "),
              box(status = "warning",width = 16,plotlyOutput("plot.pa")),
              br(),
              h3("Trend over the Years"),
              p("The plots above show the trend for obesity and physical activity for each state, 
                select a state to know
                more about it."),
              br(),
              selectInput("state.list","Choose State",choices = state.name,selected = "Alabama"),
              box(status = "warning",width = 16,plotlyOutput("state.plot")),
              br(),
              h3("In-depth Analysis for each State"),
              p("Looking at the analysis above it is important to know the reason 
                why all of this is happening, and who it is affecting
                the most in each state. For more information, 
                select a state, year, type of social determinant and the factor of nutrition
                to know more about it."),
              br(),
              fluidRow(
                column(3,selectInput("plot.state","Choose State",choices=state.name,selected = "Alabama")),
                column(3,selectInput("plot.class","Choose Class",choices = c("Obesity / Weight Status",
                                                                             "Physical Activity"),
                                     selected = "Obesity / Weight Status")),
                column(3,selectInput("plot.year","Choose Year",
                                     choices=c(2011,2012,2013,2014,2015,2016),
                                     selected = 2011)),
                column(3,selectInput("plot.type","Choose Type",
                                     choices=c("Gender","Income","Education","Age (years)"),
                                     selected = "Income"))
              ),
              box(status = "warning",width = 16,plotlyOutput("analysisPlot"))
              
      ),
      tabItem(tabName = "access",
              h2("Is food accessible in America?"),
              p("In a recent study analyzing the relationship between access and the amount of healthy food available.
                The authors found that the children that had more access to grocery stores in low poverty areas 
                tended to have more servings of fruits and vegetables (Mushi-Brunt, 262). Therefore, having a grocery
                store accessible to the population, no matter what their socioeconomic standing is, is important 
                because it can impact the amount of health foods that person is consuming. Access to grocery stores
                is the first step to providing the population with healthy foods, and is why this variable was 
                chosen to analyze how food secure residents are in different states."),
              h3("Food Accessibility across the Nation for different Population Types"),
              p("The plot below analyzes two age groups in two separate years (2015 and 2010), children and 
                Senior Citizens, to see if their age groups had an impact on their grocery store accessibility 
                and thus their food security."),
              div(
                fluidRow(
                  column(5, radioButtons("Year", h4("Select a Year"),
                                         choices = list("2015" = "2015", "2010" = "2010"))),
                  column(5,radioButtons("Population", h4("Select a Population Type"),
                                        choices = list("Overall Population" = "Overall Population", 
                                                       "Children" = "Child",
                                                       "Senior Citizens" = "Senior")))
                )
              ),
              box(status = "warning",width = 16,plotlyOutput("accessPlot")),
              br(),
              h2("What states have high risk for low accessibility?"),
              p("Overall, the states with the most consistent high rates of low access to grocery stores 
                based on the overall population are: California, Massachusetts, New Jersey, Connecticut, 
                and Arizona. Specifically, Connecticut and Massachusetts are consistently the top two states 
                that have the highest population with low access to grocery stores in both 2010 and 2015. In fact, 
                the Boston Globe recently discussed how many residents in Massachusetts struggle to have access to 
                grocery stores. Felice Freyer describes how the nearest grocery store for a resident is about 
                two hours away, but also requires a two-hour bus ride with multiple transfers (Freyer, para. 1). 
                One of the biggest issues Massachusetts faces is the transportation to the grocery store (Freyer, 
                para. 7). If a resident does not have a car, they must rely on the subpar public transportation 
                which causes problems for how accessible the grocery stores are for their residents. Massachusetts 
                is consistently one of the states with the largest population that has low access to grocery stores, 
                and this can lead to unhealthy diets."),
              p("In Massachusetts in 2015, the number of children that had 
                low access to grocery stores was 28,452 and the number of Senior Citizens with low access to 
                grocery stores was 17,844. Although there are much fewer Senior Citizens struggling with grocery 
                store access than children, this number of Senior Citizens in Massachusetts was one of the highest
                values when compared to other states. It is interesting to see how the population of each state 
                differs when looking at these age groups. Some encouraging data proves that there has been a decline
                in the number of Senior Citizens in Delaware, New Jersey, and Massachusetts that have low access to
                grocery stores from 2010 to 2015. Clearly, certain states are attempting to increase the accessibility to 
                grocery stores, and certain states have been fairly successful."),
              br(),
              p(),
              fluidRow(
                column(5, selectInput("b.plot.state",h4("Select a State"), 
                                      choices= list(state.name=state.abb),selected = "Alabama")),
                column(5, radioButtons("b.plot.year", h4("Select Time"),
                                       choices = list("Past", "Recent", "All"),
                                       selected = "All"))
              ),
              box(status = "warning",width = 16,plotlyOutput("buyAccessPlot"))
      ),
      tabItem(tabName = "kmeans",
              h2("What is K-Means clustering?"),
              p("K-means clustering is a type of unsupervised learning, which is used when you have unlabeled data (i.e., data without defined categories or groups). 
                We will use this clustering algorithm to try to find states with similar Food Security situation, which is the purpose of our project.
                The algorithm works iteratively to assign each data point to one of K groups based on the features that are provided. 
                In this section, we will select features for the algorithm, find the optimum number of clusters, and visulize the clusters of states interactively."),
              h3("Correlation Matrix"),
              p("Below you can see a correlation matrix of all the variables that were used in the earlier sections."),
              box(status = "warning",width = 16,plotOutput("corr",width = "80%",height = 600)),
              box(status = "warning",width = 16,plotOutput("varclust",width = "80%",height = 600)),
              p("From the above two plots, we observe is that Obesity and Physical Inactivity are highly correlated. Hence, we remove Obesity from our K-Means Analysis."),
              h3("Finding Optimum K Value"),
              p("The plot below you can use different evalutating methods. 
                You can use the Elbow method and Silhouette method to find k value."),
              selectInput("meth","Method of Evalutating k",c("With-In-Sum-Of-Squares" = "wss",
                                                             "Silhouette" = "silhouette")),
              box(status = "warning",width = 16,plotOutput('diffk')),
              h3("Visualizing K-Means"),
              p("In this section, we will visualize the clusters formed from the different k values.
                 The above image shows the states that have similar food security result based on - 
                 Percent Population Low Access, Number of Grocery Stores per 1000 population, # of Conveience 
                 Stores per 1000 population, Physical Inactivity measure, Number of Farmers Market per 1000 population, 
                 Food and Beverages Expenditure per capita, Number of Supercenters per 1000 population.
                 You can use the slider below, to see the clusters change."),
              sliderInput("k", "K Value", min = 2, max = 15,value = 2,step = 1),
              box(status = "warning",width = 16,plotOutput("km")),
              p("Each cluster shows a value of similarity in terms of Food Security factors, which helps find
                geographic locations that are at risk. This vizualization also helps show if states from our previous analysis
                are clustered together or not.")              
      ),
      tabItem(tabName = "report",
              h2("What did we learn from our analysis?"),
              p("This section of the report focuses on our inferences on food security in the United States. 
                 Each individual section below, will focus on each aspect of food security—Expenditure, 
                 Nutrition, and Access. Finally, we will analyze the impact of geographic 
                location on food security."),
              br(),
              h3("Expenditure"),
              h4("The National Comparison"),
              div(imageOutput("expend1"), align = "center"),
              p("The plot map above shows the total expenditure of each state for 
                 durable and non-durable goods and services. For the scope of the project, 
                 we will be looking at services and more specifically, Food services."),
              h4("Conclusions"),
              p("1. Far West: Alaska is the highest in both variables. While most of the states in this region are close to the average per capita total expenditure and food and beverage spending per capita, Nevada is the lowest spender on food and beverage."),
              p("2. Great Lakes: Illinois has the highest Per capita expenditure but the lowest spent on Food and Beverage, while within this region, Indiana has the lowest in both the variables. Highest Food and beverage spender: Wisconsin."),
              p("3. Mideast: Out of all the states, District of Columbia stands out, as if it were an outlier, with the highest per capita total expenditure and food and beverage spending per capita. Most of the states are between the range of ~$40-49k for Per capita total expenditure and ~$2.7-3.2k for F&B spending."),
              p("4. New England: It is interesting to see that most of the states don’t have similar values. Massachusetts have the highest per capita total expenditure and an average F&B spending for the region. While Vermont is the highest spender for F&B and Rhode Island being the lowest in both variables."),
              p("5. Plains: North Dakota stands out instantly as the change reported was negative but also remains the highest F&B spender and highest Per capita total expenditure in the region. Kansas is the lowest per capita total expenditure."),
              p("6. Rocky Mountains: Idaho has the highest percent change at 8.2% and yet remains the lowest per capita total expenditure state in the region and a bit below the average F&B spending."),
              p("7. South East: It is the region with the most number of states(12). Most of the states are concentrated between the $2600-$2800 range for F&B spending and Per capita total expenditure range of $32k-36k. 
                It is interesting to find that, increase in per capita total expenditure doesn’t mean increase in F&B spending for this subset of state. While the highest per capita spender is Virginia, it only spends ~$3000 on F&B, not significantly higher than most of 
                the states concentrated in the average zone. Mississippi is the lowest in both variables for this region."),
              p("8. South West: We can see a linear plot of dots, there is an almost linear increase in total expenditure. There seems to be a more direct relationship between the per capita total expenditure and the F&B spending in these states. Texas is the highest in both variables while Oklahoma is the lowest.
                "),
              h4("Risk Zone Identified"),
              p("District of Columbia stands out, being the highest in both the variables and South East states contributing to the lower values of the graph. Most of the states are concentrated between the range of $2700-$3200 for F&B spending but ranging from $30k to almost $50k in Per capita total expenditure."),
              br(),
              h3("Nutrition"),
              h4("The National Comparison"),
              p("The graph below shows the trend of how nutritional index (in terms of Physical Inactivity and
                Obesity/Weight Status) have changed over the past 5-years."),
              div(imageOutput("nutrition1"), align = "center"),
              p("Takeing a specific look at each state for it's nutritional value currently, the plot below
                shows a state-wise comparison for the percentage of the population that is physically inactive and obese."),
              div(imageOutput("nutrition2"), align = "center"),
              h4("Conclusions"),
              p("The average value of obesity is 29.8% and average value of physical inactivity is 23.4% nationally in 2016.  The top 10 high risk zone states (with Obesity > 34 % or Physical Inactivity > 29%) are Alabama, Arkansas, Florida, Georgia, Kentucky, Louisiana, Mississippi, New Jersey, Tennessee, West Virginia (in no particular order)."),
              p("These values show that 1 in 5 adults in the US is obese. This matches with the findings from the OECD Update about obesity in 2017, which states that “Adult obesity rates are highest in the United States, Mexico, New Zealand and Hungary.”
                 In addition, even though the US is not a high-risk country for physical inactivity as compared to other countries, it still lies in the second risk zone according to WHO’s report on Prevalence of Insufficient Physical Activity."),
              h4("The Risk Zone Identified"),
              p("The highest rate of obesity is found in West Virginia, where in 37.7 % of the population is obese in 2016. The analysis found that males are marginally more obese than women. Additionally, low income households have higher obesity (with 16.2%) as compared to high income households (with 12.5%). The age group at the highest risk for obesity in West Virginia is 45-54 years (with 20.7%) and the lowest risk for obesity is 18-24 years (with 11.6%).
                 For physical inactivity, the highest rate is in Arkansas, with a reported percentage of 32.5 percent in 2016. Even though the Arkansas has been more physically inactive in the past years than in 2016, its own highest obesity rates are in 2016 as well. The analysis reported that men are physically more inactive in Arkansas than women, that lower the household income, higher is the rate for physical inactivity."),
              br(),
              h3("Accessibility"),
              h4("Overall population with Low Access to Grocery Stores in 2015"),
              div(imageOutput("access1"), align = "center"),
              h4("Conclusions"),
              p("In terms of Convenience Stores, the number of stores per 1000 people slightly decreased in Connecticut, remained the same in Massachusetts, and increased in New Jersey from 2009 to 2014. Each of these states had a different change in the number of Convenience Stores, but all continued to struggle with low access in recent years. 
                 In Connecticut, Massachusetts, and New Jersey, the number of farmers markets increased from 2009 to 2016. This could provide more of the population with healthy, organic foods that are sold by farmers markets.
                 For each of the three states, the number of grocery stores per 1000 people is approximately the same value—0.25. This explains why these three states are the most concerning with access to grocery stores, and explain why their unweighted values are so similar. As discussed earlier, a limited supply of grocery stores can have a negative impact on the population’s ability to adequately feed everyone.
                 Finally, the number of supercenters per 1000 people for all three states was almost insignificant and under 0.05. It was interesting to see such a small value for a type of food supply that can provide the public with an extremely large supply of food and other retail items.
                 Overall, each of the three states had similar values for their number of food supply stores per 1000 people, and is consistent with the understanding that these are the top three states that are similar in their service to providing the public with access to food. These states continue to have extremely large numbers of people that have low access to grocery stores, but have larger access to convenience stores. The concerning aspect of this access is how convenience stores 
                "),
              h4("The Risk Zone Identified"),
              p("In a recent study analyzing the relationship between access and the amount of healthy food available. The authors found that the children that had more access to grocery stores in low poverty areas tended to have more servings of fruits and vegetables (Mushi-Brunt, 262). Therefore, having a grocery store accessible to the population, no matter what their socioeconomic standing is, is important because it can impact the amount of health foods that person is consuming. Access to grocery stores is the first step to providing the population with healthy foods, and is why this variable was chosen to analyze how food secure residents are in different states."),
              h5("Conneticut"),
              div(imageOutput("CT"), align = "center"),
              h5("Massachusetts"),
              div(imageOutput("MA"), align = "center"),
              h5("New Jersey"),
              div(imageOutput("NJ"), align = "center"),
              br(),
              h3("Predictive Clustering"),
              p("In the plot below, we can see a heatmap of how closely the states are clustered based on 
                Euclidean Distance metric."),
              box(status = "warning",width = 16,plotOutput("heatmap", width = "80%", height = 600)),
              p(".... what we observe"),
              p("Talk about how we decided this k"),
              box(status = "warning",width = 16,plotOutput('final_result', width = '80%', height = 500)),
              br(),
              h3("Limitations"),
              p("Food                                                           Insecurity differences within regions may be more than access to supermarkets relative to the distance but be a by-product of the social and welfare settings that disallow proper food systems in that region. (https://www.sciencedirect.com/science/article/pii/S1353829208000178)"),
              p("We assumed that we have a consistent timeline with the datasets we download but there were many time discrepancies across our data sets, which made it very difficult to connect the visualizations together. We decided to work with whatever year we had and tried our best to plot them."),
              p("The sources we got our data from was hard to directly load into R and visualize. We had to selected individual columns and create separate files for the data we required for each factor."),
              p("Data collection methods are not standardized. Different agencies use their own data collection methods, which makes it hard to interact with data from multiple sources.")
            
      )
      
    )
  )
)



