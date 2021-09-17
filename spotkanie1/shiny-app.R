
library(shiny)

source("app_source.R")


ui <- fluidPage(

    titlePanel("Dzień dobry!"),

    sidebarLayout(

        sidebarPanel(
            fileInput("wprowadzone_dane", "Wybierz dane csv z komputera:",
                      accept = c(
                          "text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv")
            ),
            "Wybrałeś:",
            verbatimTextOutput("table")
        ),

        mainPanel(
            plotOutput("heatmap")
        )
    )

)

server <- function(input, output, session) {


    data <- reactive({

        inFile <- input[["wprowadzone_dane"]]

        if (is.null(inFile)) return(NULL)

        read.csv(inFile$datapath)

    })

    output[["heatmap"]] <- renderPlot({

        if(is.null(data())) return(NULL)

        generate_plot(data())

    })

    output[["table"]] <- renderPrint({ head(data()) })

}

shinyApp(ui, server)
