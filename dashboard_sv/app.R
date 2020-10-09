# Adopted from shinydashboard for NPCR writter by Fredrik Sandin, RCC Uppsala Örebro

library(shiny)
library(shinydashboard)

server <- shinyServer(function(input, output) {
  report_start_year <- 2008
  report_end_year <- 2019

  output$box1 <- renderValueBox({
    valueBox(
      formatC(9225, format = "d", big.mark = " "),
      paste0("nya fall registrerade i NKBC år ", report_end_year),
      icon = icon("line-chart"),
      color = "light-blue"
    )
  })

  output$box2 <- renderValueBox({
    valueBox(
      formatC(102543, format = "d", big.mark = " "),
      paste0("fall under ", report_start_year, "-", report_end_year),
      icon = icon("plus"),
      color = "light-blue"
    )
  })

  # Täckningsgrad mot cancerregistret
  # https://statistik.incanet.se/brostcancer/sv/tackning-mot-cancerreg-33/
  output$box3 <- renderValueBox({
    valueBox(
      paste0(99, " %"),
      paste0("täckningsgrad mot cancerregistret år ", report_end_year),
      icon = icon("bar-chart"),
      color = "green"
    )
  })

  # Patienten har erbjudits, i journalen dokumenterad, kontaktsjuksköterska
  # https://statistik.incanet.se/brostcancer/sv/omv-kontaktssk-02/
  output$box4 <- renderValueBox({
    valueBox(
      paste0(98, " %"),
      paste0("erbjöds kontaktsjuksköterska år ", report_end_year),
      icon = icon("bar-chart"),
      color = "yellow"
    )
  })

  # Tid från välgrundad misstanke om cancer till primär operation inom 28 dagar
  # https://statistik.incanet.se/brostcancer/sv/ledtid-misstanke-till-op-15/
  # https://vardenisiffror.se/indikator/81c7d463-e117-4d26-b25c-428dbcc9b54f
  output$box5 <- renderValueBox({
    valueBox(
      paste0(38, " %"),
      paste0("där tid från misstanke om cancer till operation är inom 28 dagar ", report_end_year),
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
