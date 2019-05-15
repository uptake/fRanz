#' @title Kakfa Producer
#' @name KafkaProducer
#' @description TDB
#' @importFrom R6 R6Class
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
                             , keys) {
            KafkaProduce(private$producerPtr
                         ,topic
                         ,0
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
