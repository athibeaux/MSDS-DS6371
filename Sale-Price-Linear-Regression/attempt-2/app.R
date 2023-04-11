#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(rsconnect)
library(shiny)
library(ggplot2)
train = read.csv('https://github.com/athibeaux/MSDS-DDS/raw/main/Project/train.csv', header = TRUE, fill = NA)
C21 = train %>% select(GrLivArea,Neighborhood,SalePrice) %>% filter(Neighborhood == "NAmes" | Neighborhood == "Edwards" | Neighborhood == "BrkSide")
C21$logprice = log(C21$SalePrice)
C21$logLivArea = log(C21$GrLivArea)
C21$Neighborhood <- as.factor(C21$Neighborhood)


# Define UI for application that draws a scatterplot
ui <- fluidPage(

    # Application title
    titlePanel("Select Neighborhood to measure Living Area Sq. Footage vs Sale Price"),

    # Sidebar with a neighborhood input 
    sidebarLayout(
        sidebarPanel(
          selectInput("neighborhoods", "Select the Neighborhood", 
                      choices = c("Brookside" = "BrkSide","Edwards" = "Edwards","North Ames" = "NAmes"), 
                      selected = c("Brookside", "Edwards","North Ames"), multiple = TRUE),
          # Future Expansion: Allow user to select whether to use raw or log-transformed data
          #selectInput("explvar", "Choose Explanatory Variable",
           #         choices = c("Living Area in 100 Sq. Ft." = "GrLivArea", "Living Area, log-transformed scale" = "logLivArea"), 
            #        selected = "Living Area Variable"),
          #selectInput("respvar", "Choose Response Variable",
           #           choices = c("Sale Price" = "SalePrice", "Sale Price, log-transformed scale" = "logprice"), 
            #          selected = "Sale Price")
        ),

        # Show the generated scatterplot
        mainPanel(
           plotOutput("myplot")
        )
    )
)

# Define server logic required to filter by neighborhood
server <- function(input, output) {
           
  output$myplot <- renderPlot({
    
    C21 %>% filter(Neighborhood == {input$neighborhoods}) %>% ggplot(aes(GrLivArea, SalePrice, color = Neighborhood)) + geom_point() +
      geom_smooth(method = "lm") + 
      xlab("Living Area in 100 Sq. Feet") + ylab("Sale Price") +
      ggtitle("Square Footage of Living Areas vs. Sales Price")
  })

}

# Run the application 
shinyApp(ui = ui, server = server)
