#!/bin/sh
SERVICE_NAME=h2o
PATH_TO_JAR=/opt/h2o.jar
PID_PATH_NAME=/tmp/h2o-pid
PATH_TO_FLATFILE=/opt/flatfile.txt
HOST_IP=$(hostname -I | cut -f2 -d ' ')
case $1 in
    start)
        echo "Starting $SERVICE_NAME ..."
        if [ ! -f $PID_PATH_NAME ]; then
            nohup java -Xmx4g -jar $PATH_TO_JAR -flatfile $PATH_TO_FLATFILE -name myh2ocluster -ip $HOST_IP -port 54321 2>> /dev/null >> /dev/null &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is already running ..."
        fi
    ;;
    stop)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stoping ..."
            kill $PID;
            echo "$SERVICE_NAME stopped ..."
            rm $PID_PATH_NAME
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
    restart)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stopping ...";
            kill $PID;
            echo "$SERVICE_NAME stopped ...";
            rm $PID_PATH_NAME
            echo "$SERVICE_NAME starting ..."
            nohup java -Xmx4g -jar $PATH_TO_JAR -flatfile $PATH_TO_FLATFILE -name myh2ocluster -ip $HOST_IP -port 54321 2>> /dev/null >> /dev/null &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
esac
