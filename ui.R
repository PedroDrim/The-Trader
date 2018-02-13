
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shinydashboard)

# pesquisar a variavel LastTradeRealtimeWithTime para identificar o estado da bolsa (aberta / fechada)
# https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%27AAPL%27)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=

shinyUI(fluidPage(
     
     #==========================================#
     dashboardPage(
          
          #==========================================#
          dashboardHeader(disable = TRUE),
          #==========================================#
          
          #==========================================#
          dashboardSidebar(width = 300,
               
               # Criando um separador
               hr(),
               
               # Seletor de Flags da bolsa de valores
               selectizeInput('keySelect', 'Selecione as chaves:', choices = NULL,
                              options = list(maxItems = 5)),
               
               # Seletor para a limitação dos dados exibidos no grafico
               selectInput('timeSelect', 'Selecione o tempo de exibicao:', "Todos",
                           selectize = TRUE),
          
               # Habilitar modelo de previsao dos dados
               checkboxInput('dataPrevision', label = 'Previsao de dados:', value = TRUE)
          ),
          #==========================================#
          
          #==========================================#
          dashboardBody()
          #==========================================#
          
     )
     #==========================================#
)
)
