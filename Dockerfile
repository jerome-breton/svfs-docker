FROM alpine:latest  
RUN apk add --no-cache --update ca-certificates openssl fuse && update-ca-certificates
RUN mkdir /ovh

RUN wget https://github.com/ovh/svfs/releases/download/v0.9.1/svfs-linux-amd64 -O /usr/bin/svfs
RUN chmod a+x /usr/bin/svfs

RUN wget https://github.com/ovh/svfs/raw/master/scripts/hubic-application.rb -O /usr/bin/hubic-application.rb
RUN chmod a+x /usr/bin/hubic-application.rb

COPY svfs-mount.sh /
RUN chmod +x /svfs-mount.sh

COPY hubic-application.sh /usr/bin/hubic-application
RUN chmod +x /usr/bin/hubic-application

CMD ["/svfs-mount.sh"]
