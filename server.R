library(shiny)

shinyServer(function(input, output) {
  
  output$image <- renderImage({
    return(list(
        src = "venn_diag.png",
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
