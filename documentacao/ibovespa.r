# URL: https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22YHOO%22,%22AAPL%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=

require(jsonlite)

getIbovespaValue.now = function(keys, lastTime = NA){
  
  keys_string = paste0(keys, collapse = "','")
  
  base = "https://query.yahooapis.com/v1/public/yql?"
  query = sprintf("q=select * from yahoo.finance.quotes where symbol in ('%s')&",keys_string)
  format = "format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
  
  yql = paste0(base, query, format)

  arquivo.tmp = "data.tmp"
  download.file(yql, arquivo.tmp, quiet = T)
  
  #======================================#
  con = file(arquivo.tmp)
  open(con)
  
  linha = readLines(con)
  
  close(con)
  unlink(arquivo.tmp)
  #======================================#
  
  jsonResp = fromJSON(linha)
  
  responseTime = jsonResp$query$created
  responseTime = as.Date(responseTime)
  
  #if(lastTime == as.character(responseTime) ){
  #  return(NA)
  #}
  
  action.table = jsonResp$query$results$quote
  
  action.table$responseTime = responseTime
  
  return(action.table)
}

keys = c("YHOO","AAPL")

contador = 1
currentTime = ""
result = c()
while(TRUE){

  values = getIbovespaValue.now(keys, currentTime)
  
  if(contador == 1){
    result = values
  }else{
    result = rbind(result,values)
  }
  currentTime = unique(values$responseTime)
  
  cat(sprintf("[%s] %s Verificacao\n",Sys.time(),contador))
  contador = contador + 1
  
  if(contador == 20){
    break;
  }
  Sys.sleep(15)
}


# copia = a
# 
# a.t = a[a$symbol == unique(a$symbol)[1],]
# 
# teste  = apply(a.t, 2, as.numeric)
# for(i in 1:dim(teste)[2]){
#   
#   b = unique(teste[,i])
#   sd.v = 0
#   
#   if(length(b) > 1){
#     sd.v = sd(b,na.rm = T)
#     cat(sprintf("%s: %s\n",names(a.t)[i],sd.v))
#   }else{
#     sd.v = NA
#   }
#   
# }
