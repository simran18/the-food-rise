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
      menuItem("Report", tabName = "report", icon = icon("align-left", lib = "glyphicon"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "intro",
              h2("What is Food Insecurity?"),
              p("It is important to know that hunger and food insecurity are closely related, but distinct, concepts.
                Hunger refers to a personal, physical sensation of discomfort, while food insecurity refers to a lack
                of available financial resources for food at the level of the household."),
              h2("Goals of this Project"),
              p("<Add goals>"),
              h2("More details"),
              p("<Add details>"),
              h2("Our project in a Venn Diagram"),
              tags$img(src = "venn.png", height = 50, width = 50)
              
      )
    )
  )
)

server <- function(input, output) {
  
}

shinyApp(ui, server)