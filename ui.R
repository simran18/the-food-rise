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
              h2("What is Food Insecurity?"),
              p("Add Definition Here"),
              plotlyOutput("plot.insec"),
              h2("Goals of the Project"),
              p("Add scope"),
              h3("Scope of The Project"),
              img(src = "www/Food Rise.png", align = "center"),
              br(),
              h2("Analysis Overview"),
              h4("Data Overview"),
              p("Add info"),
              h4("External Research"),
              p("Add Info"),
              h4("Who We Are?"),
              p("Add info.")
      ), 
      
      tabItem(tabName = "expenditure",
              h2("How much does America spend on Food?"),
              p("It is important to know that hunger and food insecurity are closely related, but distinct, concepts.
                Hunger refers to a personal, physical sensation of discomfort, while food insecurity refers to a lack
                of available financial resources for food at the level of the household."),
              h2("National Food Expenditure Over The Years"),
              selectInput("expYear", "Year:",
                          c("2014" = "total_2014",
                            "2015" = "total_2015",
                            "2016" = "total_2016")),
              plotlyOutput('totalExp'),
              p(""),
              br(),
              ##plotlyOutput('perCapitaBubble', width = '80%', height = 500),
              div(plotlyOutput("perCapitaBubble", height = "100%", width = "80%"), align = "center")
              
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
              h2("Is food accessible?"),
              p("Add info Here"),
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
              plotlyOutput("accessPlot"),
              br(),
              h2("What does accessibility look like in every state?"),
              p("Add info Here"),
              fluidRow(
                column(5, selectInput("b.plot.state",h4("Select a State"), 
                                      choices= list(state.name=state.abb),selected = "Alabama")),
                column(5, radioButtons("b.plot.year", h4("Select Time"),
                                       choices = list("Past", "Recent"),
                                       selected = "Recent"))
              ),
             plotlyOutput("buyAccessPlot")
      ),
      tabItem(tabName = "kmeans",
              h2("K means clustering"),
              plotOutput("heatmap", width = "80%", height = 600),
              p(),
              plotOutput('diffk'),
              h3("K Means Clustering"),
              plotOutput("km"),
              sliderInput("k", "K Value", min = 2, max = 15,value = 2,step = 1)
      ),
      tabItem(tabName = "report",
              h2("What did we learn from this?"),
              p("Talk about how we decided this k"),
              plotOutput('final_result', width = '80%', height = 500)
      )
      
    )
  )
)



