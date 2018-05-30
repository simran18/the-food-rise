library(shiny)

<<<<<<< HEAD
shinyServer(function(input, output) {
  
  output$image <- renderImage({
    return(list(
        src = "venn_diag.png",
=======
shinyServer(function(input, output, session) {
  
  ##############
  #INTRODUCTION#
  ##############
  output$plot.insec <- renderPlotly({
    plot.insec
  })
  
  #############
  #EXPENDITURE#
  #############
  
  output$totalExp <- renderPlotly({
    total_exp(input$expYear)
  })
  
  output$perCapitaBubble <- renderPlotly({
    return(bubble_p)
  })
  
  ###########
  #NUTRITION#
  ###########
  
  output$nationalTrend <- renderPlotly({
    state.plot("National")
  })
  
  output$plot.b <- renderPlotly({
    plot.b
  })
  
  output$plot.ob <- renderPlotly({
    plot.ob
  })
  
  output$plot.pa <- renderPlotly({
    plot.pa
  })
  
  output$state.plot <- renderPlotly({
    state.plot(input$state.list)
  })
  
  output$analysisPlot <- renderPlotly({
    indepth.plot(input$plot.state,input$plot.class,input$plot.year,input$plot.type)
  })
  
  ########
  #ACCESS#
  ########
  output$accessPlot <- renderPlotly({
    access <- selected(input$Population, input$Year)
    #renames second column name to allow aggregate to work
    colnames(access)[2] <- "Population-Year"
    #aggregate based on mean
    avg <- aggregate(access$`Population-Year`, by = list(access$State), FUN = mean, na.rm = TRUE)
    colnames(avg)[1] <- "State"
    #join state names with abbreviations to show the hover on graph
    avg <- left_join(avg, states, by = "State")
    p_access <- graph(avg)
    p_access$elementId <- NULL
    return(p_access)
  })
  
 output$buyAccessPlot <- renderPlotly({
    state.y.plot(input$b.plot.state, input$b.plot.year)
 })
  
  ########
  #REPORT#
  ########
  
  # K means 
  output$image <- renderImage({
    return(list(
        src = "venn.png",
>>>>>>> simran
        contentType = "image/png",
        alt = "Venn"
      ))
    }, deleteFile = FALSE)
  
  output$heatmap <- renderPlot({
    states_heatmap()
  })
  
  output$diffk <- renderPlot({
    diff_k()
  })

  output$km <- renderPlot({
    interactive_kmeans(input$k)
  })
  
  output$final_result <- renderPlot({
    final_kmeans()
  })
})
