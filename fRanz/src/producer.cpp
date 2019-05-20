#include <librdkafka/rdkafkacpp.h>
#include <Rcpp.h>
#include "utils.h"

//' @title GetRdProducer
//' @name GetRdProducer
//' @description Creates an Rcpp::XPtr<RdKafka::Producer>. For more details on options \href{https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md}{Configuration}
//' @param keys a character vector indicating option keys to parameterize the RdKafka::Producer
//' @param values a character vector indicating option values to parameterize the RdKafka::Producer. Must be of same length as keys.
//' @return a Rcpp::XPtr<RdKafka::Producer>
// [[Rcpp::export]]
SEXP GetRdProducer(Rcpp::StringVector keys, Rcpp::StringVector values) {
    std::string errstr;
    auto conf = MakeKafkaConfig(keys,values);
    RdKafka::Producer *producer = RdKafka::Producer::create(conf, errstr);
    if(!producer) {
      Rcpp::stop("Producer creation failed with error: " + errstr); 
    }
    Rcpp::XPtr<RdKafka::Producer> p(producer, true) ;
    return p;
}

//' @title KafkaProduce
//' @name KafkaProduce
//' @description Produces key/values to a particular topic on a particular partition
//' @param producer_pointer a Rcpp::XPtr<RdKafka::Producer>
//' @param topic a string indicating the topic to produce to
//' @param partition an integer indicating the partition to produce to
//' @param keys a character vector for all the keys for the messages
//' @param values a character vector for all the values for the messages. Must be of same length as keys
//' @return returns the number of messages succesfully sent
// [[Rcpp::export]]
int KafkaProduce(SEXP producer_pointer,
                 SEXP topic, 
                 Rcpp::IntegerVector partition, 
                 Rcpp::StringVector keys, 
                 Rcpp::StringVector values) {
    Rcpp::XPtr<RdKafka::Producer> producer(producer_pointer);
    std::string s_topic = Rcpp::as<std::string>(topic);

    if (keys.size() != values.size()) {
        std::cout << "keys and values must be same size" << std::endl;
        return -1;
    }
    int numMsgs = keys.size();
    int numSent = 0;

    for (int i = 0; i < numMsgs; i++) {
        std::string s_value = Rcpp::as<std::string>(values[i]);
        std::string s_key = Rcpp::as<std::string>(keys[i]);
    
        RdKafka::ErrorCode resp = producer->produce(
            s_topic, partition[0],  RdKafka::Producer::RK_MSG_COPY,
            const_cast<char *>(s_value.c_str()),s_value.size(),
            const_cast<char *>(s_key.c_str()), s_key.size(),
            0, NULL
        );

        if (resp == RdKafka::ERR_NO_ERROR) numSent++;
    }

    producer->flush(0);

    return numSent;
}