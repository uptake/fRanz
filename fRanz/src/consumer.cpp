#include <rdkafkacpp.h>
#include <Rcpp.h>
#include "utils.h"
#include <iostream>
#include <string>
#include <cstdlib>
#include <cstdio>
#include <csignal>
#include <thread>
#include <chrono>
#include <cstring>

////////////////////////////////////////////////////////////////////////////////////////
//' @title GetRdConsumer
//' @name GetRdConsumer
//' @description Creates an Rcpp::XPtr<RdKafka::Consumer>. For more details on options \link{https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md}
//' @param keys a character vector indicating option keys to parameterize the RdKafka::Consumer
//' @param values a character vector indicating option values to parameterize the RdKafka::Consumer. Must be of same length as keys.
//' @return a Rcpp::XPtr<RdKafka::Consumer>
// [[Rcpp::export]]
SEXP GetRdConsumer(Rcpp::StringVector keys, Rcpp::StringVector values) {
    std::string errstr;
    auto conf = MakeKafkaConfig(keys,values);
    RdKafka::KafkaConsumer *consumer = RdKafka::KafkaConsumer::create(conf, errstr);
    if(!consumer) {
      Rcpp::stop("Consumer creation failed with error: " + errstr); 
    }
    Rcpp::XPtr<RdKafka::KafkaConsumer> p(consumer, true) ;
    return p;
}

//' @title RdSubscribe
//' @name RdSubscribe
//' @description A method to register a consumer with a set amount of topics as consumers. 
//' This is important so the broker can track offsets and register it in a consumer group
//' @param consumerPtr a reference to a Rcpp::XPtr<RdKafka::KafkaConsumer>
//' @param Rtopics a character vector listing the topics to subscribe to
//' @return the int representation of the librdkafka error code of the response to subscribe. 0 is good
// [[Rcpp::export]]
int RdSubscribe(SEXP consumerPtr, const Rcpp::StringVector Rtopics) {
    Rcpp::XPtr<RdKafka::KafkaConsumer> consumer(consumerPtr);
    std::vector<std::string> topics(Rtopics.size());
    for (int i = 0; i < Rtopics.size(); i++){
        topics[i] = Rtopics(i);
    }
    RdKafka::ErrorCode resp;
    resp = consumer->subscribe(topics);
    return static_cast<int>(resp);
}

//' @title KafkaConsume
//' @name KafkaConsume
//' @description Consume a fixed number of results from whatever topic(s)
//'              the provided consumer is subscribed to.
//' @param consumerPtr a reference to a Rcpp::XPtr<RdKafka::KafkaConsumer>
//' @param numResults how many results should be consumed before returning. Will return early if offset is at maximum
//' @return a list of length numResults with values list(key=key,value=value)
// [[Rcpp::export]]
Rcpp::List KafkaConsume(SEXP consumerPtr, int numResults) {
    Rcpp::XPtr<RdKafka::KafkaConsumer> consumer(consumerPtr);

    Rcpp::List messages(numResults);
    for(int i = 0; i < numResults; i++) {
        RdKafka::Message *msg = consumer->consume(10000);
        switch(msg->err()){
            case RdKafka::ERR_NO_ERROR: {
                Rcpp::List message = Rcpp::List::create(Rcpp::Named("key") = *msg->key(),
                                                        Rcpp::Named("value") = static_cast<const char *>(msg->payload()));
                messages[i] = message;
                break;
            } case RdKafka::ERR__PARTITION_EOF: {
                printf("No additional messages available\n");
                goto exit_loop;
            } default: {
                /* Errors */
                printf("Consume failed: %s", msg->errstr().c_str());
                goto exit_loop;
            }
        } 
    }   
    exit_loop:;
    
    return messages;
}
