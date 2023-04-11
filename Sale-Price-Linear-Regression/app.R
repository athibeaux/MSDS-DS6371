#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Square Footage vs Sale Price"),

    # Sidebar with a select input for Neighborhoods 
    sidebarLayout(
        sidebarPanel(
          selectInput("neighborhood", "Neighborhood:",
                      c("all" = "all",
                        "brookside" = "Brookside",
                        "edwards" = "Edwards",
                        "names" = "North Ames"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate plot based on input$bins from ui.R
      train = read.csv('https://github.com/athibeaux/MSDS-DDS/raw/main/Project/train.csv', 
                       header = TRUE, fill = NA)
      C21 = train %>% select(GrLivArea,Neighborhood,SalePrice) %>% 
        filter(Neighborhood == "NAmes" | Neighborhood == "Edwards" | Neighborhood == "BrkSide")
        x <- C21[,1]
        y <- C21[,3]

        # draw the histogram with the specified number of bins
          C21 %>% plot(x, y, color = Neighborhood)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
