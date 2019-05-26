#include <Rcpp.h>
#include <librdkafka/rdkafkacpp.h>

RdKafka::Conf* MakeKafkaConfig(Rcpp::StringVector keys, Rcpp::StringVector values);