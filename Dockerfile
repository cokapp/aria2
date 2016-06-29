FROM debian

MAINTAINER charlie@cokapp.com

#安装aria2和nginx
RUN apt-get update && \
    apt-get install -y aria2 nginx 

#forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

#webui
COPY yaaw-zh-hans/public_html/* /usr/share/nginx/html/

#aria2.conf
ADD aria2.conf /etc/aria2/
#start.sh
ADD start.sh /etc/aria2/

#data
VOLUME ["/etc/aria2/data"]

EXPOSE 80
EXPOSE 6800

WORKDIR /etc/aria2

CMD ["/bin/bash", "/etc/aria2/start.sh"]