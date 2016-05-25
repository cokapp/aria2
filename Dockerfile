FROM debian:8
MAINTAINER charlie@cokapp.com

# less priviledge user
RUN groupadd -r dummy && useradd -r -g dummy dummy -u 1000

# webui + aria2
RUN apt-get update \
	&& apt-get install -y aria2 busybox curl git \
	&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/aa65535/yaaw-zh-hans.git

#RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
#	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
#	&& gpg --verify /usr/local/bin/gosu.asc \
#	&& rm /usr/local/bin/gosu.asc \
#	&& chmod +x /usr/local/bin/gosu

# gosu install latest
RUN GITHUB_REPO="https://github.com/tianon/gosu" \
  && LATEST=`curl -s  $GITHUB_REPO"/releases/latest" | grep -Eo "[0-9].[0-9]"` \
  && curl -L $GITHUB_REPO"/releases/download/"$LATEST"/gosu-amd64" > /usr/local/bin/gosu \
  && chmod +x /usr/local/bin/gosu

# goreman supervisor install latest
RUN GITHUB_REPO="https://github.com/mattn/goreman" \
  && LATEST=`curl -s  $GITHUB_REPO"/releases/latest" | grep -Eo "v[0-9]*.[0-9]*.[0-9]*"` \
  && curl -L $GITHUB_REPO"/releases/download/"$LATEST"/goreman_linux_amd64.tar.gz" > goreman.tar.gz \
  && tar -xvzf goreman.tar.gz && mv /goreman_linux_amd64/goreman /usr/local/bin/goreman && rm -R goreman*

# aria2.conf
ADD aria2.conf /etc/aria2/aria2.conf

# goreman setup
RUN echo -e "web: gosu dummy /bin/busybox httpd -f -p 8080 -h /yaaw-zh-hans/public_html\nbackend: gosu dummy /usr/bin/aria2c --conf-path=/etc/aria2/aria2.conf" > Procfile

EXPOSE 8080 6800
CMD ["goreman", "start"]