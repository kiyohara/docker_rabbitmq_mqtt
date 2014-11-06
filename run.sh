
CMD="docker run"
PARAMS=""

_p() {
  [ -n "$1" ] && PARAMS="$PARAMS $1"
}

_debug() {
  [ -n "$DEBUG" ]
  return $1
}

_main() {
  _debug && _p "-ti"

  if _debug;then
    _p "--rm"
  else
    _p "--name rabbitmq-mqtt"
    _p "-d"
  fi

  _p "-p 5672:5672"
  _p "-p 1883:1883"
  _p "-p 4369:4369"
  _p "-p 25672:25672"
  _p "-p 15672:15672"

  if [ -n "$DOCKER_SSHD" ];then
    _p "-p 8022:22"
  fi

  _p "rabbitmq_mqtt"

  _debug && _p "bash"

  echo $CMD $PARAMS
  $CMD $PARAMS
}

_main
