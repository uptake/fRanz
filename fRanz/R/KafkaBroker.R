#' @title KafkaBroker
#' @name KafkaBroker
#' @description TDB
#' @export
#' @importFrom R6 R6Class
KafkaBroker <- R6::R6Class(
    classname = "KafkaBroker"
    , public = list(
        initialize = function(host
                              , port) {
            #TODO: Validate
            private$host <- host
            private$port <- port
        }

        , getHost = function() {
            private$host
        }

        , getPort = function() {
            private$port
        }
        
        , getHostPort = function(){
            return(paste0(private$host,":",private$port))
        }
        , getTopics = function() {
            #TODO: Implement
            return(NULL)
        }
    )
    , private = list(
        host = NULL
        , port = NULL
        , partitions = NULL
    )
)
