FROM ubuntu:14.04
MAINTAINER Tomokazu Kiyohara "tomokazu.kiyohara@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

ADD http://www.rabbitmq.com/rabbitmq-signing-key-public.asc /tmp/rabbitmq-signing-key-public.asc
RUN apt-key add /tmp/rabbitmq-signing-key-public.asc
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
RUN apt-get update

RUN apt-get -y -q install rabbitmq-server
RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_mqtt
RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_management
RUN echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

ADD run-container.sh /usr/sbin/run-container.sh
RUN chmod +x /usr/sbin/run-container.sh
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

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["/usr/sbin/run-container.sh"]
