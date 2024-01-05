#!/bin/bash

case "$1" in
    start)
        docker-compose up -d
        ;;
    stop)
        docker-compose down
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
esac
