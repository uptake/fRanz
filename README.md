# fRranz: An R Kafka Client

![Lifecycle badge](https://img.shields.io/badge/lifecycle-experimental-orange.svg)

**THIS PROJECT IS STILL ALPHA CURRENTLY -- Check back often!!**


![](doc/sticker/fRanz.png)


## What is fRanz

fRanz is an open source R kafka client that allows users to read and write messages from kafka. It leverages the stability and performance of [librdkafka](https://github.com/edenhill/librdkafka) and implements ididiomatic R workflows ontop of it. 


## Installation 

We're working on it. Currently you need librdkafka as a system available library in order to load the R package. In order to install from source you also need the headers. A make recipe in the top level `make librdkafka` should work for *nix systems.


No attempt has been made for windows compatability.

## Example of sending and reading a message

```r
library(fRanz)

BROKER_HOST <- 'localhost'
BROKER_PORT <- 9092
TOPIC_NAME <- 'myTestTopic'

# KafkaBroker
broker <- KafkaBroker$new(host=BROKER_HOST, port=BROKER_PORT)

# KafkaProducer
producer <- KafkaProducer$new(brokers = list(broker))
producer$produce(topic = TOPIC_NAME,
                 key = "myKey",
                 value = "My First Message")
# Number of messages successfuly sent is returned
# [1] 1 


# KafkaConsumer
consumer <- KafkaConsumer$new(brokers = list(broker), groupId = "test", extraOptions=list(`auto.offset.reset`="earliest"))
consumer$subscribe(topics = c(TOPIC_NAME))
result <- consumer$consume(topic=TOPIC_NAME)

result
# Consumed messages are returned in a list(list(key,val)) format
# [[1]]
# [[1]]$key
# [1] "myKey"
#
# [[1]]$payload
# [1] "My First Message" 
```
