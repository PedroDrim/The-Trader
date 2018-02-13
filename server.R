
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shinydashboard)

shinyServer(function(input, output, session) {
     
     #===================================#
     observe({
          # Atualizando valores de exibicao (keySelect)
          keys = c("YHOO","AAPL","MSFT","GOOG","BIDU","FB","IBM","TWTR","HPQ")
          updateSelectizeInput(session, "keySelect", choices = keys, selected = keys[1], server = T)
     })
     #===================================#
     
     #===================================#
     observe({
          # Atualizando valores de exibicao (timeSelect)
          tempo = c("Todos", "5 minutos", "30 minutos", "1 Hora")
          updateSelectInput(session, "timeSelect", choices = tempo)
     })
     #===================================#
     
     #===================================#
     observeEvent(input$dataPrevision,{
          # Atualizando valores de exibicao (dataPrevision)
          estado = ifelse(input$dataPrevision, "Habilitado", "Desabilitado")
          lab = sprintf("Previsao de dados (%s).", estado)
          
          updateCheckboxInput(session, "dataPrevision", label = lab)
     })
     #===================================#
     
})
