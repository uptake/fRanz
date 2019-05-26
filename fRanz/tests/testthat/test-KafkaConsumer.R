context("KafkaConsumer and KafkaProducer")


testthat::test_that("Testing KafkaConsumer and KafkaProducer work consuming 1 message",{
    testthat::skip_on_cran()
    ## Standard Set Up
    topic <- uuid::UUIDgenerate()
    group <- uuid::UUIDgenerate()
    kb <- KafkaBroker$new(KAFKA_HOST, KAFKA_PORT)
    kp <- KafkaProducer$new(brokers = list(kb))


    key <- uuid::UUIDgenerate()
    value <- uuid::UUIDgenerate()
    numSent <- kp$produce(topic = topic, keys = key, values = value)
    expect_equal(numSent,1)

    kc <- KafkaConsumer$new(brokers = list(kb), groupId = group, extraOptions=list(`auto.offset.reset`="earliest"))
    kc$subscribe(topics = c(topic))
    result <- kc$consume(topic=topic, numResults=1)
    expect_equal(length(result),1)
    expect_equal(result[[1]][["key"]], key)
    expect_equal(result[[1]][["value"]], value)

})


testthat::test_that("Testing KafkaConsumer and KafkaProducer work consuming random number of messages",{
    testthat::skip_on_cran()
    ## Standard Set Up
    topic <- uuid::UUIDgenerate()
    group <- uuid::UUIDgenerate()
    kb <- KafkaBroker$new(KAFKA_HOST, KAFKA_PORT)
    kp <- KafkaProducer$new(brokers = list(kb))
    numMessages <- sample(50:100,1)
    keys <- sapply(seq(numMessages), function(x) paste0("key_",x))
    values <- sapply(seq(numMessages), function(x) paste0("value_",x))
    numSent <- kp$produce(topic = topic, keys = keys, values = values)
    expect_equal(numSent,numMessages)

    kc <- KafkaConsumer$new(brokers = list(kb), groupId = group, extraOptions=list(`auto.offset.reset`="earliest"))
    kc$subscribe(topics = c(topic))
    result <- kc$consume(topic=topic, numResults=numMessages)
    expect_equal(length(result),numMessages)
    expect_equal(unlist(lapply(result,function(x) x$key)), keys)
    expect_equal(unlist(lapply(result,function(x) x$value)), values)

})
