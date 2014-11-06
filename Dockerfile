#FROM kiyohara/docker-supervisor
FROM kiyohara/docker-sshd

MAINTAINER Tomokazu Kiyohara "tomokazu.kiyohara@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

ADD http://www.rabbitmq.com/rabbitmq-signing-key-public.asc /tmp/rabbitmq-signing-key-public.asc
RUN apt-key add /tmp/rabbitmq-signing-key-public.asc
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
RUN apt-get update

RUN apt-get -y -q install rabbitmq-server
RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_mqtt
RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_management
RUN echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

ADD rabbitmq-wrapper.sh /usr/bin/rabbitmq-wrapper.sh
RUN chmod +x /usr/bin/rabbitmq-wrapper.sh
RUN mkdir -p /var/run/rabbitmq
RUN chown rabbitmq:rabbitmq /var/run/rabbitmq

# main
EXPOSE 5672

# MQTT
EXPOSE 1883

# epmd
EXPOSE 4369
EXPOSE 25672

# management plugin
EXPOSE 15672


## supervisord
ADD etc/supervisor/conf.d/rabbitmq.conf /etc/supervisor/conf.d/rabbitmq.conf
