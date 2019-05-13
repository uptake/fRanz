#include <Rcpp.h>
#include <rdkafkacpp.h>



RdKafka::Conf* MakeKafkaConfig(Rcpp::StringVector keys, Rcpp::StringVector values) {
    std::string errstr;
    RdKafka::Conf *conf = RdKafka::Conf::create(RdKafka::Conf::CONF_GLOBAL);
    for(int i = 0; i < keys.size(); i ++){
        std::string temp_key = Rcpp::as< std::string >(keys[i]);
        std::string temp_value = Rcpp::as< std::string >(values[i]);
        if(conf->set(temp_key,temp_value,errstr) !=
           RdKafka::Conf::CONF_OK){
            throw std::invalid_argument(errstr);
        }
    }
    return conf;
}

