NeuralClass = R6Class("NeuralClass",
                       
                       public = list(
                         
                         #=================================================#
                         initialize = function(tabelaEntrada){
                           
                           private$tabelaEntrada = tabelaEntrada
                           private$keys.data = unique(tabelaEntrada$symbol)
                           private$list.netLearning = length(private$keys.data)
                           
                           private$training()
                         },
                         #=================================================#
                         
                         #=================================================#
                         use = function(dateTimeInicial, dateTimeFinal, key){
                           
                           dateTimeInicial = strptime(dateTimeInicial, "%Y-%m-%d %H:%M:%S")
                           dateTimeFinal = strptime(dateTimeFinal, "%Y-%m-%d %H:%M:%S")
                           
                           startTime = dateTimeInicial
                           
                           dateTimeInicial = as.numeric(dateTimeInicial)
                           dateTimeFinal = as.numeric(dateTimeFinal)
                           
                           intervalo = seq(dateTimeInicial, dateTimeFinal, by = 60)
                           
                           net.result = attr(private$list.netLearning,key)
                           
                           net.get = compute(net.result, intervalo)$net.result
                           net.get = round(net.get,digits = 3)
                           
                           dateFormatInterval = startTime + 60*(0: (length(intervalo)-1) )
                           
                           tabelaEsperada = data.table(symbol = key, Bid = net.get[,1], Ask = net.get[,2], LastTradePriceOnly = net.get[,3], 
                                                       queryDateTime = dateFormatInterval, type = "simulated")
                           
                           tabelaEntrada = private$tabelaEntrada
                           order.name = c("symbol","Name","Currency")
                           tabelaEntrada = tabelaEntrada[,order.name, with = F]
                           tabelaEntrada = unique(tabelaEntrada)
                           
                           setkey(tabelaEsperada,symbol)
                           setkey(tabelaEntrada, symbol)
                           
                           tabelaEsperada = merge(tabelaEntrada,tabelaEsperada)
                           order.name = c("symbol","Name","Currency","Bid","Ask","LastTradePriceOnly","queryDateTime","type")
                           tabelaEsperada = tabelaEsperada[, order.name, with = F]
                           
                           return(tabelaEsperada)
                            
                         }
                         #=================================================#
                       ),
                       
                       private = list(

                         #=================================================#                         
                         keys.data = c(),
                         tabelaEntrada = data.table(),
                         list.netLearning = 0,
                         #=================================================#
                         
                         #=================================================#
                         training = function(){
                           
                           ids = private$keys.data
                           tabela = private$tabelaEntrada
                           
                           order.name = c("symbol","queryDateTime","Bid","Ask","LastTradePriceOnly")
                           tabela = tabela[,order.name, with = F]
                           for(id in ids){
                             
                             index = which(tabela$symbol == id)
                             result.key = tabela[index]
                             result.key$symbol = NULL
                             
                             qdt = strptime(result.key$queryDateTime, "%Y-%m-%d %H:%M:%S")
                             result.key$queryDateTime = as.numeric(qdt)
                             result.key = mapply(as.numeric, result.key)
                             
                             net.result = neuralnet(Bid+Ask+LastTradePriceOnly~queryDateTime,  result.key, hidden=15, threshold=0.01)
                             
                             attr(private$list.netLearning, id) = net.result
                           }
                           
                         }
                         #=================================================#
                         
                       )
)