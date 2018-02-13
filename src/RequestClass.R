RequestClass = R6Class("RequestClass",
                       
                       public = list(
                         
                         #=================================================#
                         getValues.now = function(keys){
                           
                           keys_string = paste0(keys, collapse = "','")
                           
                           base = "https://query.yahooapis.com/v1/public/yql?"
                           query = sprintf("q=select symbol,Name,Currency,Bid,Ask,LastTradePriceOnly from yahoo.finance.quotes where symbol in ('%s')&",keys_string)
                           format = "format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
                           
                           yql = paste0(base, query, format)
                           
                           action.table = private$getTable(yql)
                           
                           order.name = c("symbol","Name","Currency","Bid","Ask","LastTradePriceOnly","queryDateTime")
                           action.table = action.table[,order.name, with = F]
                           action.table$type = "observed"
                           
                           return(action.table)
                         },
                         #=================================================#
                         
                         #=================================================#
                         getValues.historical = function(keys, dataInicio, dataFim){
                           
                           dataInicio = as.character(dataInicio)
                           dataFim = as.character(dataFim)
                           
                           keys_string = paste0(keys, collapse = "','")
                           
                           base = "https://query.yahooapis.com/v1/public/yql?"
                           query = sprintf("q=select * from yahoo.finance.historicaldata where symbol in ('%s') and startDate = '%s' and endDate = '%s'&",keys_string ,dataInicio, dataFim)
                           format = "format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
                           
                           yql = paste0(base, query, format)
                           
                           historical.table = private$getTable(yql)
                           historical.table$type = "observed"
                           
                           return(historical.table)
                         }
                         #==================================================#
                       ),
                       
                       private = list(
                         
                         #=================================================#
                         getTable = function(yql, queryDateTime = T){
                           
                           yql = gsub(" ","%20",yql)
                           
                           jsonResp = fromJSON(yql)
                           
                           table = jsonResp$query$results$quote
                           table = as.data.table(table)
                           
                           if(queryDateTime){
                             
                             queryDateTime = jsonResp$query$created
                             queryDateTime = gsub("Z", "", queryDateTime)
                             queryDateTime = gsub("T", " ", queryDateTime)
                             
                             table$queryDateTime = queryDateTime
                           }
                           
                           return(table)
                         }
                         #=================================================#
                       )
)