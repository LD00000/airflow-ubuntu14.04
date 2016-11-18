
# sudo docker run -d -i -t -p 8082:8080 ubuntu:14.04 /bin/bash

FROM ubuntu:14.04

MAINTAINER ld00000 "lidong9144@gmail.com"		

RUN apt-get update
RUN echo y | apt-get install wget
RUN wget https://bootstrap.pypa.io/get-pip.py  --no-check-certificate
RUN python3 get-pip.py

# airflow dep
RUN echo y | apt-get install libxml2-dev libxslt1-dev
RUN echo y | apt-get install python3-dev
RUN apt-get install zlib1g-dev
RUN echo y | apt-get install libevent-dev

# install airflow
ENV AIRFLOW_HOME ~/airflow
RUN pip install airflow==1.7.1.3
RUN pip install "airflow[hive,hdfs,jdbc]"
RUN airflow initdb

EXPOSE 8080

ENTRYPOINT airflow webserver -p 8080 &
