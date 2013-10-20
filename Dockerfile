# Installs runit for service management
#
# Author: Paul Czarkowski
# Date: 10/20/2013


FROM paulczar/jre7
MAINTAINER Paul Czarkowski "paul@paulcz.net"

RUN apt-get update

RUN apt-get -y install curl wget git nginx

RUN apt-get -y install runit || echo

CMD ["/usr/sbin/runsvdir-start"]
