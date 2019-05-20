#' @title Kakfa Consumer
#' @name KafkaConsumer
#' @description TDB
#' @export
#' @importFrom R6 R6Class
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
