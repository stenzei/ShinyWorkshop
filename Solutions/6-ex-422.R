library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Shiny dashboard"),
  dashboardSidebar(
    h3("Menue"),
    sidebarMenu(
      menuItem("Plot", tabName = "plot_item", icon = icon("area-chart")),
      menuItem("Data", tabName = "table_item", icon = icon("table")),
      menuItem("More", tabName = "more_item", icon = icon("plus-square"))
    ),
    br(),
    h3("Controlls"),
    sliderInput("num", "Number of Values", min = 10, max = 500, value = 200),
    numericInput("mean", "Mean", value = 0),
    numericInput("sd", "Standard Deviation", value = 1)
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "plot_item",
        # The structure inside the tab is similar to ordinary Shiny apps
        fluidRow(
          box(width = 8, plotOutput("plot", height = 250)),
          box(
            width = 4,
            title = "Controls",
            radioButtons("col", "Point Color",
                         choices = list("Red" = "red", "Blue" = "blue"),
                         selected = "blue")
          )
        )
      ),
      tabItem(tabName = "table_item",
        # The structure inside the tab is similar to ordinary Shiny apps
        fluidRow(
          box(width = 12, dataTableOutput("table"))
        )
      ),
      tabItem(tabName = "more_item",
        # The structure inside the tab is similar to ordinary Shiny apps
        fluidRow(
          "More content."
        )
      )
    )
  )
)

server <- function(input, output) {
  # Generate data reactively
  dta <- reactive({
    val <- rnorm(input$num, input$mean, input$sd)
    num <- seq(1:input$num)
    dta <- dplyr::bind_cols(num = num, val = val)
  })
  
  # Define the outputs
  output$plot <- renderPlot({
    # Create the plot.
    plot(dta(), col = input$col)
  })
  
  output$table <- renderDataTable(
    # Return the table data.
    dta(), 
    options = list(pageLength = 10)
  )
}

shinyApp(ui, server)