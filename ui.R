library(shiny)
library(plotly)




shinyUI(fluidPage(
  theme = shinytheme("yeti"),
  navbarPage("INF0 498",
    tabPanel("Introduction",
      titlePanel("Geographic Location and Food Security")
    ),
    mainPanel(
      #TO BE FILLED WITH DATA INTRODUCTION
      imageOutput("image", height = 100)
    ),
    tabPanel("Affordability"
      # TAB FOR AFFORDABILITY
    ),
    tabPanel("Nutrition"
      # TAB FOR NUTRITION
    ),
    tabPanel("Accessibility"
      # TAB FOR ACCESSIBILITY
    ),
    tabPanel("Report"
      # TAB FOR FINAL REPORT
    )
  ))
)
