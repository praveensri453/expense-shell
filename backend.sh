#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is...$R FAILED $N"  | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "disabled nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "enabled nodejs"

dnf install nodejs -y  &>>$LOG_FILE
VALIDATE $? "installing nodejs

useradd expense &>>$LOG_FILE
VALIDATE $? "useradd"

mkdir /app &>>$LOG_FILE
VALIDATE $? "app created"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "application code downloaded"

cd /app
VALIDATE $? "change directory to /app"

unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "unzip"


npm install &>>$LOG_FILE
VALIDATE $? "npm installing"

