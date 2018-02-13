PersistenceClass = R6Class("PersistenceClass",
                           
                           public = list(
                             
                             #=================================================#
                             initialize = function(fileName){
                               private$fileName = fileName
                               
                             },
                             #=================================================#
                             
                             #=================================================#
                             serializeTable = function(tabela, FIRST = T){
                               
                               write.table(tabela, private$fileName, row.names = F, 
                                           append = !FIRST, col.names = FIRST, sep =  ";")
                             },
                             #=================================================#
                             
                             #=================================================#
                              deserializeTable = function(){
                               
                               return(fread(private$fileName))
                             },
                             #=================================================#
                             
                             #=================================================#
                             destroyTable = function(){
                               
                               unlink(private$fileName)
                             }
                             #=================================================#
                           ),
                           
                           private = list(
                             fileName = c()
                           )
)