context("KafkaBroker")


testthat::test_that("Testing KafkaBroker can be initialized", expect_true({
    kb <- KafkaBroker$new(KAFKA_HOST, KAFKA_PORT)
    TRUE 
}))
