# http://www.investopedia.com/terms/b/bid-and-asked.asp
# https://www.google.com/finance?q=OTCMKTS%3ASSNNF&ei=AA8mWNn0FeSDiQLn3rl4

#==========================================================#
load.datas = function(){
     
     unlink("output//dadosBolsa.csv")     
     
     require(curl)
     require(neuralnet)
     require(jsonlite)
     require(data.table)
     require(R6)
     require(ggplot2)
     
     arquivos = list.files("src",full.names = T)
     status = sapply(arquivos, source)
     
     gc()
}
#==========================================================#

#==========================================================#
create.InitialSequence = function(keys, arquivo, quantidade, extrapolatedMinute = 0){
     
     persistenceObject = PersistenceClass$new(arquivo)
     requestObject = RequestClass$new()
     
     for(i in 1:quantidade){
          
          first = (i == 1)
          tabela = requestObject$getValues.now(keys)
          
          persistenceObject$serializeTable(tabela, first)
          
          Sys.sleep(60)
     }
     
     tabelaFinal = persistenceObject$deserializeTable()
     
     if(extrapolatedMinute > 0){
          
          neuralObject = NeuralClass$new(tabelaFinal)
          
          for(key in keys){
               
               index = which(tabelaFinal$symbol == key)
               tabelaFinal.short = tabelaFinal[index, c(1,7), with = F]
               
               qdt = strptime(tabelaFinal.short$queryDateTime, "%Y-%m-%d %H:%M:%S")
               dateTimeInicial = max(qdt) + 60
               dateTimeFinal = dateTimeInicial + (extrapolatedMinute * 60)
               
               dateTimeInicial = as.character(dateTimeInicial)
               dateTimeFinal = as.character(dateTimeFinal)
               
               dataSimulated = neuralObject$use(dateTimeInicial, dateTimeFinal, key)
               dataSimulated$queryDateTime = as.character(dataSimulated$queryDateTime)
               
               persistenceObject$serializeTable(dataSimulated, F)
          }
          
     }
}
#==========================================================#