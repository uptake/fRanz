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
//' @description TBD
//' @export
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
//' @description TBD
//' @export
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
//' @description TBD
//' @export
// [[Rcpp::export]]
Rcpp::List KafkaConsume(SEXP consumerPtr, int numResults) {
    Rcpp::XPtr<RdKafka::KafkaConsumer> consumer(consumerPtr);

    Rcpp::List messages(numResults);
    for(int i = 0; i < numResults; i++) {
        RdKafka::Message *msg = consumer->consume(10000);
        switch(msg->err()){
            case RdKafka::ERR_NO_ERROR: {
                printf("Message %.*s\n",
                       static_cast<int>(msg->len()),
                       static_cast<const char *>(msg->payload()));
                Rcpp::List message = Rcpp::List::create(Rcpp::Named("key") = *msg->key(),
                                                        Rcpp::Named("payload") = static_cast<const char *>(msg->payload()));
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
