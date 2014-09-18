#!/usr/bin/env bash

PID_FILE=/var/run/rabbitmq/pid
trap_sigterm() {
  #echo "trap sigterm: rabbtmqctl stop ${PID_FILE} ....."
  /usr/sbin/rabbitmqctl stop $PID_FILE
  #echo "..... done"
  exit 0
}

env PID_FILE=$PID_FILE /usr/sbin/rabbitmq-server &
#while true; do
#  [ -f $PID_FILE ] && break
#  sleep 1
#done
#/usr/sbin/rabbitmqctl wait $PID_FILE

trap "trap_sigterm" TERM

# for wait trap
while true; do
  sleep 1
done
