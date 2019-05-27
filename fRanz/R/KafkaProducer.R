#' @title Kakfa Producer
#' @name KafkaProducer
#' @description A producer is an application that is responsible
#'              for publishing data to topics.
#' @references \href{https://kafka.apache.org/documentation/#intro_producers}{Apache Kafka docs - Producers}
#' @importFrom R6 R6Class
#' @export
KafkaProducer <- R6::R6Class(
    classname = "KafkaProducer"
    , public = list(
        initialize = function(brokers,extraOptions=list()) {
            #TODO: Assert broker class
            private$brokers <- brokers
            brokerList <- unlist(lapply(brokers,function(x) x$getHostPort()))
            private$producerPtr <- GetRdProducer(c("metadata.broker.list",names(extraOptions))
                                                   ,c(brokerList,unlist(extraOptions,use.names = FALSE)))
        }

        # Produce single message to topic
        , produce = function(topic
                             , values
                             , keys
                             , partition = 0) {
            KafkaProduce(private$producerPtr
                         ,topic
                         ,partition
                         ,keys
                         ,values)
        }

        , getTopics = function() {
            #TODO: Get this working
            Reduce(c, lapply(brokers, function(broker) {broker$getTopics()}))
        }

    )
    , private = list(
        brokers = NULL
        , producerPtr = NULL
    )
)
