# Adopted from shinydashboard for NPCR writter by Fredrik Sandin, RCC Uppsala Örebro

library(shiny)
library(shinydashboard)

server <- shinyServer(function(input, output) {
  report_start_year <- 2008
  report_end_year <- 2019

  output$box1 <- renderValueBox({
    valueBox(
      formatC(9225, format = "d", big.mark = " "),
      paste0("new cases registered i NKBC ", report_end_year),
      icon = icon("line-chart"),
      color = "light-blue"
    )
  })

  output$box2 <- renderValueBox({
    valueBox(
      formatC(102543, format = "d", big.mark = " "),
      paste0("cases during ", report_start_year, "-", report_end_year),
      icon = icon("plus"),
      color = "light-blue"
    )
  })

  # Coverage compared to the Swedish Cancer Register
  # https://statistik.incanet.se/brostcancer/en/tackning-mot-cancerreg-33/
  output$box3 <- renderValueBox({
    valueBox(
      paste0(99, " %"),
      paste0("coverage compared to the Cancer Register ", report_end_year),
      icon = icon("bar-chart"),
      color = "green"
    )
  })

  # The patient was offered, as documented in the medical record, a contact nurse
  # https://statistik.incanet.se/brostcancer/en/omv-kontaktssk-02/
  output$box4 <- renderValueBox({
    valueBox(
      paste0(98, " %"),
      paste0("offered a contact nurse ", report_end_year),
      icon = icon("bar-chart"),
      color = "yellow"
    )
  })

  # Time from well-founded suspicion of cancer to primary surgery within 28 days
  # https://statistik.incanet.se/brostcancer/en/ledtid-misstanke-till-op-15/
  # https://vardenisiffror.se/indikator/81c7d463-e117-4d26-b25c-428dbcc9b54f
  output$box5 <- renderValueBox({
    valueBox(
      paste0(38, " %"),
      paste0("where time from suspicion of cancer to surgery is within 28 days ", report_end_year),
      icon = icon("bar-chart"),
      color = "red"
    )
  })
})

ui <- shinyUI(
  dashboardPage(
    dashboardHeader(disable = TRUE),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
      includeCSS("styles.css"),
      fluidRow(
        valueBoxOutput("box1"),
        valueBoxOutput("box2")
      ),
      fluidRow(
        valueBoxOutput("box3"),
        valueBoxOutput("box4"),
        valueBoxOutput("box5")
      )
    )
  )
)

shinyApp(ui = ui, server = server)
