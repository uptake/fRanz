library(fRanz)

# system call to start a local kafka instance
system("docker-compose up -d --build")

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



#KafkaConsumer
consumer <- KafkaConsumer$new(brokers = list(broker), groupId = "test", extraOptions=list(`auto.offset.reset`="earliest"))

consumer$subscribe(topics = c(TOPIC_NAME))

result <- consumer$consume(topic=TOPIC_NAME)

result


#### Multiple messages

producer <- KafkaProducer$new(brokers = list(broker))
producer$produce(topic = TOPIC_NAME,
                 key = "mySecondKey",
                 value = "My Second Message")

producer$produce(topic = TOPIC_NAME,
                 key = "myThirdKey",
                 value = "My Third Message")

consumer <- KafkaConsumer$new(brokers = list(broker), groupId = "test", extraOptions=list(`auto.offset.reset`="earliest"))

consumer$subscribe(topics = c(TOPIC_NAME))

result <- consumer$consume(topic=TOPIC_NAME)

result