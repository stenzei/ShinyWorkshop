server <- function(input, output) {
  # Define the output
  output$noise_plot <- renderHighchart({
    # Lets make some noise!
    distr <- switch(input$dist,
                    norm = rnorm,
                    lognorm = rlnorm
    )
    
    val <- distr(input$num, input$mean, input$sd)
    num <- seq(1:input$num)
    dta <- dplyr::bind_cols(num = num, val = val)
    
    
    # Create the plot.
    highcharter::highchart() %>% 
      highcharter::hc_xAxis(dta$num) %>% 
      highcharter::hc_add_series(name = "random data",
                                 data = dta$val)
  })
}

ui <- fluidPage(
  sidebarPanel(
    radioButtons("dist", "Distribution",
                 choices = list("Normal" = "norm", "Log Normal" = "lognorm"),
                 selected = "norm"),
    sliderInput("num", "Number of Values", min = 10, max = 500, value = 200),
    p("Use the slider input to choose the number of plotted random values."),
    numericInput("mean", "Mean", value = 0),
    numericInput("sd", "Standard Deviation", value = 1)
  ),
  mainPanel(
    h3("Plots & Infos"),  
    highcharter::highchartOutput("noise_plot"),
    p("This is still a plot of random numbers.")
  )
)

# The shiny app is created here.
shinyApp(ui = ui, server = server) 