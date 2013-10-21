#!/bin/bash

# Cleanup ... be very careful running this
# sudo find . -uid 0   -exec rm -rfv {} \;

mkdir -p {service,sv,init,stats,opt}

echo "Step 1: Building the docker image..."

docker build -t demo/runit .

BASE=$(pwd)


echo "Step 2: Installing Applications to localized opt directory"

cd opt
mkdir -p {logstash/bin,logstash/logs,logstash/conf.d,kibana/logs,kibana/etc,elasticsearch-0.90.5/logs}
[[ ! -e logstash/bin/logstash.jar ]] && \
    wget -q -O logstash/bin/logstash.jar https://download.elasticsearch.org/logstash/logstash/logstash-1.2.1-flatjar.jar
[[ ! -e elasticsearch-0.90.5/bin/elasticsearch ]] && \
    curl -s https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.tar.gz | tar xzvf -
[[ ! -d kibana/html ]] && \
    (cd kibana && curl -s http://download.elasticsearch.org/kibana/kibana/kibana-latest.tar.gz | tar xzvf - && mv kibana-latest html)
[[ ! -e kibana/etc/kibana.conf ]] && \
    wget -q -O kibana/etc/kibana.conf https://gist.github.com/paulczar/6bd72fe5b0b782380e70/raw/9645117f3c5f23654b939eee35ae042eb55ccff9/gistfile1.txt
cd ..


echo "Step 3:  Run the Docker container with volumes attached"

DOCKER_ID=$(docker run -d -p 8080:80 -p 5014:514 -p 9200:9200 \
  -v $BASE/opt:/opt \
  -v $BASE/sv:/etc/sv \
  -v $BASE/init:/etc/init \
  -v $BASE/service:/etc/service \
  demo/runit)

sleep 2

docker ps

#echo Container ID: ${$DOCKER_ID}
