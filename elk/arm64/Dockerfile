FROM openjdk:8-jdk-alpine

RUN apk update && apk add unzip curl nano
RUN addgroup -S elasticsearch && adduser -S -G elasticsearch elasticsearch
RUN su -l elasticsearch -s /bin/sh

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.16.zip && unzip elasticsearch-5.6.16.zip
# WORKDIR /home/elasticsearch/elasticsearch-5.6.16/bin
# ENTRYPOINT [ "/home/elasticsearch/elasticsearch-5.6.16/bin" ]
EXPOSE 9200 9300
RUN pwd
CMD [ "/home/elasticsearch/elasticsearch-5.6.16/bin/elasticsearch" ]
