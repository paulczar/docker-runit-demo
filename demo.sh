#!/bin/sh

# Cleanup ... be very careful running this
# sudo find . -uid 0   -exec rm -rfv {} \;

mkdir -p {service,sv,init,stats,opt}

# docker build -t demo/runit .

BASE=$(pwd)

cd opt

mkdir -p {logstash/bin,logstash/logs,logstash/conf.d,kibana/logs,kibana/etc}
[[ ! -e logstash/bin/logstash.jar ]] && \
    wget -q -O logstash/bin/logstash.jar https://download.elasticsearch.org/logstash/logstash/logstash-1.2.1-flatjar.jar
[[ ! -d elasticsearch-0.90.5 ]] && \
    curl -s https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.tar.gz | tar xzvf -
[[ ! -L elasticsearch ]] && \
    ln -s $BASE/opt/elasticsearch-0.90.5 $BASE/opt/elasticsearch
[[ ! -d kibana/html ]] && \
    (cd kibana && curl -s http://download.elasticsearch.org/kibana/kibana/kibana-latest.tar.gz | tar xzvf - && mv kibana-latest html)
[[ ! -f kibana/etc/kibana.conf ]] && \
    wget -q -O kibana/etc/kibana.conf https://gist.github.com/paulczar/6bd72fe5b0b782380e70/raw/9645117f3c5f23654b939eee35ae042eb55ccff9/gistfile1.txt

cd ..

DOCKER_ID=$(docker run -d -p 8080:80 -p 5014:514 -p 9200:9200 \
  -v $BASE/opt:/opt \
  -v $BASE/sv:/etc/sv \
  -v $BASE/init:/etc/init \
  -v $BASE/service:/etc/service \
  demo/runit)

echo Container ID: ${$DOCKER_ID}
