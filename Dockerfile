FROM alpine:latest

RUN apk --no-cache --update --upgrade add tor \
    && mv /etc/tor/torrc.sample /etc/tor/torrc \
    && mkdir /etc/torrc.d \
    && sed -i \
       -e 's/#SOCKSPort 192.168.0.1:9100/SOCKSPort 0.0.0.0:9050/g' \
       -e 's/#ControlPort 9051/ControlPort 9051/g' \
       -e 's/#%include \/etc\/torrc\.d\/\*\.conf/%include \/etc\/torrc\.d\/\*\.conf/g' \
       /etc/tor/torrc \ 
     && rm -rf /var/cache/apk/* \
     	       /tmp/* \
	       /var/tmp/*

VOLUME ["/etc/torrc.d"]
VOLUME ["/var/lib/tor"]

ADD docker-entrypoint.sh /docker-entrypoint.sh
EXPOSE 9050/tcp 9051/tcp

CMD /docker-entrypoint.sh
