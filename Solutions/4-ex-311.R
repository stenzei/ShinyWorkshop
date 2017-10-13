library(dplyr)
library(highcharter)
library(shiny)

server <- function(input, output) {
  dta <- reactive({
    val <- rnorm(input$num, input$mean, input$sd)
    num <- seq(1:input$num)
    dta <- dplyr::bind_cols(num = num, val = val)
  })
  
  # Define the output
  output$noise_plot <- renderPlot({
    # Create the plot.
    plot(dta(), col = input$col)
  })
  output$noise_table <- renderDataTable({
    # Return the table data.
    dta()
  })
  output$point_color <- renderText({
    # Return text
    if (input$col == "red") {
      "Red Points"      
    } else {
      "Blue Points"
    }
  })
}

ui <- fluidPage(
  title = "Random Numbers",
  
  fluidRow(
    column(width = 2,
           h3("Controls"),
           radioButtons("col", h3("Point Color"),
                        choices = list("Red" = "red", "Blue" = "blue"),
                        selected = "blue"),
           sliderInput("num", "Number of Values", min = 10, max = 500, value = 200),
           p("Use the slider input to choose the number of plotted random values."),
           numericInput("mean", h3("Mean"), value = 0),
           numericInput("sd", h3("Standard Deviation"), value = 1)
    ),
    column(width = 5,
           h3("Plot"),  
           plotOutput("noise_plot"),
           h3("Point Color"),
           textOutput("point_color")
    ),
    column(width = 5,
           h3("Table"),  
           dataTableOutput("noise_table")
    )
  )
)
shinyApp(ui = ui, server = server)
