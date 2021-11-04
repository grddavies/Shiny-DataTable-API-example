library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  # Set up JS message handlers
  shiny::includeScript("www/handlers.js"),
  # Application title
  titlePanel("Searchable DT"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("instSelectInput")
    ),
    mainPanel(
      DT::DTOutput("table")
    )
  )
)

server <- function(input, output, session) {
  table_id <- "#DataTables_Table_0"
  instruments <- c("Guitar", "Drums", "Keyboard", "Saxophone", "Theremin")
  df <- dplyr::mutate(iris, plays_the = sample(instruments, nrow(iris), TRUE))

  output$instSelectInput <- renderUI(
    selectInput("instSelect",
      "Filter by Instrument",
      unique(df$plays_the),
      multiple = TRUE
    )
  )

  observeEvent(
    input$instSelect,
    session$sendCustomMessage(
      type = "instFilter",
      message = list(
        tablelocator = table_id,
        regex = paste0("(", paste0(input$instSelect, collapse = "|"), ")")
      )
    )
  )

  # Render data table
  output$table <- DT::renderDT(
    DT::datatable(
      df,
      extensions = "Buttons",
      options = list(
        dom = "tpB",
        lengthMenu = list(c(5, 15, -1), c("5", "15", "All")),
        pageLength = 15,
        searchable = TRUE,
        buttons = list(
          list(
            extend = "collection",
            text = "Show All",
            action = DT::JS("function(e, dt, node, config) {
                              dt.page.len(-1);
                              dt.ajax.reload();}")
          )
        )
      )
    )
  )
}

# Run the application
shinyApp(ui = ui, server = server)
