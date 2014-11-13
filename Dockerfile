FROM debian:7.6
MAINTAINER pihizi@msn.com

RUN apt-get update

# Install aria2
RUN apt-get install -y aria2

# aria2 config
ADD aria2.conf /etc/aria2/aria2.conf

VOLUME ["/var/aria2/download"]

EXPOSE 6800

CMD aria2c --conf-path=/ect/aria2/aria2.conf -D
