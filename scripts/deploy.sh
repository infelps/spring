#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=spring

echo "> copy Build file"
cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> check current pid"
CURRENT_PID=$(pgrep -fl spring | grep jar | awk '{print $1}')

echo "current pid : $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> deploy new application"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR NAME : $JAR_NAME"

echo "> $JAR_NAME에 실행권한 추가"

chmod +x $JAR_NAME

echo "execute $JAR_NAME"

nohup java -jar \
    -Dspring.config.location=classpath:/application.properties,classpath:/application-real.properties,/home/ec2-user/app/application-oauth.properties,/home/ec2-user/app/application-real-db.properties \
    -Dspring.profiles.active=real \
    $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &