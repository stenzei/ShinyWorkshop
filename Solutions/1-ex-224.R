library(shiny)
library(highcharter)

# Define program logic inside the server function.
server <- function(input, output) {
  # Define the output
  output$noise_plot <- renderHighchart({
    # Lets make some noise!
    val <- rnorm(n = input$num, mean = input$mean, sd = input$sd)
    num <- seq(1:input$num)
    dta <- dplyr::bind_cols(num = num, val = val)
    
    # Create the plot.
    highcharter::highchart() %>% 
      highcharter::hc_xAxis(dta$num) %>% 
      highcharter::hc_add_series(name = "random data",
                                 data = dta$val)
  })
}

# Define the user interface inside the ui list.
ui <- fluidPage(
  highcharter::highchartOutput("noise_plot"),
  sliderInput("num", "Number of Values", min = 10, max = 500, value = 100),
  sliderInput("mean", "Mean", min = -10, max = 10, value = 0),
  sliderInput("sd", "Standard Deviation", min = 0, max = 10, value = 1)
)

# The shiny app is created here.
shinyApp(ui = ui, server = server)