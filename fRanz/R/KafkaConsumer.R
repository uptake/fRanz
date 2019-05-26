#' @title Kakfa Consumer
#' @name KafkaConsumer
#' @description A consumer is an application which 
#'              subscribes to one or more topics and processes
#'              new messages as they arrive on that topic.
#' 
#'              Consumers may also be instructed to process older
#'              messages.
#'
#'              Consumers belong to "consumer groups". Consumer
#'              groups with more than one consumer instance can be
#'              used to parallelize message processing and / or
#'              distribute it over multiple physical machines.
#' @references \href{https://kafka.apache.org/documentation/#intro_consumers}{Apache Kafka docs - Consumers}
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
#' consumer <- KafkaConsumer$new(brokers = list(broker), groupId = "test", extraOptions=list(`auto.offset.reset`="earliest"))
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
KafkaConsumer <- R6::R6Class(
    classname = "KafkaConsumer"
    , public = list(
        initialize = function(brokers
                              , groupId
                              , extraOptions = list()) {
            #TODO: Assert broker class
            private$brokers <- brokers
            brokerList <- unlist(lapply(brokers,function(x) x$getHostPort()))
            private$consumerPtr <- GetRdConsumer(c("metadata.broker.list", "group.id",names(extraOptions))
                                                 ,c(brokerList, groupId,unlist(extraOptions,use.names = FALSE)))
        }

        , subscribe = function(topics) {
            for (topic in topics) {
                result <- RdSubscribe(private$consumerPtr, topic)
                if (result == 0) {
                    private$topics <- c(private$topics, topic)
                }
            }
        }

        , consume = function(topic, numResults=100) {
            Filter(function(msg) !is.null(msg), KafkaConsume(private$consumerPtr, numResults))
        }

        , getTopics = function() {
            Reduce(c, lapply(brokers, function(broker) {broker$getTopics()}))
        }
    )
    , private = list(
        brokers = NULL
        , topics = NULL
        , consumerPtr = NULL
    )
)
