#http://shinyapps.stat.ubc.ca/r-graph-catalog/#fig07-21_blood-level-data-multipanel-plot
#http://www.r-graph-gallery.com/104-plot-lines-with-error-envelopes-ggplot2/

GraphClass = R6Class("GraphClass",
                     
                     public = list(
                       
                       #=================================================#
                       getPlot = function(tabela, colname, rangemax, simulated = F){
                         
                         if(simulated){
                           flag = "simulada"
                           index = which(tabela$type == "simulated")
                           tabela = tabela[index]
                         }else{
                           flag = "real"
                           index = which(tabela$type == "observed")
                           tabela = tabela[index]
                         }
                         
                         tabela.sort = private$prepareData(tabela, rangemax)       
                         tabela.sort$symbol = as.factor(tabela.sort$symbol)
                         
                         titulo = sprintf("Quadro de acoes (%s)",flag)
                         
                         index.name = which(names(tabela.sort) == colname)
                         names(tabela.sort)[index.name] = "mark"
                         
                         tabela.sort$mark = as.numeric(tabela.sort$mark)
                         
                         dias.min = min(tabela.sort$queryDateTime)
                         dias.max = max(tabela.sort$queryDateTime)
                         
                         dias.min = strsplit(dias.min, split = " ")[[1]]
                         dias.max = strsplit(dias.max, split = " ")[[1]]
                         
                         dias.min = dias.min[2]
                         dias.max = dias.max[2]
                         
                         eixo.y = sprintf("%s (%s)",colname ,unique(tabela.sort$Currency) )
                         eixo.x = sprintf("De %s ate %s (min)", dias.min ,dias.max)
                         
                         vetor.qdt = strptime(tabela.sort$queryDateTime, "%Y-%m-%d %H:%M:%S")
                         vetor.qdt = as.numeric(vetor.qdt)
                         vetor.qdt = (vetor.qdt - min(vetor.qdt) )/60
                         
                         tabela.sort$queryDateTime = vetor.qdt
                         
                         ggplot(tabela.sort, aes(x=queryDateTime, y=mark, group=symbol)) +
                           geom_line(aes(colour = symbol)) + 
                           labs(title = titulo, x = eixo.x, y = eixo.y)
                         
                       }
                       #=================================================#
                     ),
                     
                     private = list(
                       
                       #=================================================#
                       prepareData = function(tabela.ini, rangemax){
                         
                         keys = unique(tabela.ini$symbol)
                         
                         datas.list = lapply(keys, function(key, data, tamanho){
                           
                           index = which(data$symbol == key)
                           data = data[index]
                           
                           inicio = 1
                           tamanho = dim(data)[1]
                           
                           if(tamanho > rangemax){
                             inicio = tamanho - rangemax
                           }
                           data = data[inicio:tamanho]
                           
                           return(data)
                         }, tabela.ini, rangemax)
                         
                         md = do.call(rbind,datas.list)
                         return(md)
                       }
                       #=================================================#
                       
                     )
)
