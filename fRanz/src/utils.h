#include <Rcpp.h>
#include <rdkafkacpp.h>

RdKafka::Conf* MakeKafkaConfig(Rcpp::StringVector keys, Rcpp::StringVector values);