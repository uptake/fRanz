#' @title Kafka Broker
#' @name KafkaBroker
#' @description Brokers are servers that know the state
#'              of a Kafka cluster and participate in actions like
#'              creating / deleting topics and broadcasting messages
#'              to consumer groups.
#' @importFrom R6 R6Class
#' @export
#' @examples
#' \donttest{
#' library(fRanz)
#' 
#' BROKER_HOST <- 'localhost'
#' BROKER_PORT <- 9092
#' TOPIC_NAME <- 'myTestTopic'
#' # KafkaBroker
#' broker <- KafkaBroker$new(host=BROKER_HOST, port=BROKER_PORT)
#' 
#' # KafkaProducer
#' producer <- KafkaProducer$new(brokers = list(broker))
#' producer$produce(topic = TOPIC_NAME,
#'                  key = "myKey",
#'                  value = "My First Message")
#' # Number of messages successfuly sent is returned
#' # [1] 1 
#' 
#' 
#' # KafkaConsumer
#' consumer <- KafkaConsumer$new(brokers = list(broker),
#'                                groupId = "test",
#'                                extraOptions=list(`auto.offset.reset`="earliest"))
#' consumer$subscribe(topics = c(TOPIC_NAME))
#' result <- consumer$consume(topic=TOPIC_NAME)
#' 
#' result
#' # Consumed messages are returned in a list(list(key,val)) format
#' # [[1]]
#' # [[1]]$key
#' # [1] "myKey"
#' #
#' # [[1]]$payload
#' # [1] "My First Message" 
#'}
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
