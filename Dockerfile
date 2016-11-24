FROM ubuntu:14.04

MAINTAINER ld00000 <lidong9144@gmail.com>

ARG AIRFLOW_VERSION=1.7.1.3
ENV AIRFLOW_HOME /airflow

RUN rm -vfr /var/lib/apt/lists/*

# RUN echo "deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse \
#   deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse \
#   deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse \
#   deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse \
#   deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse \
#   deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse \
#   deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse \
#   deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse \
#   deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse \
#   deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" > /etc/apt/sources.list

RUN apt-get update
RUN echo y | apt-get install wget
RUN wget https://bootstrap.pypa.io/get-pip.py  --no-check-certificate

RUN echo y | apt-get install python2.7
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 100
RUN echo y | apt-get install python-pip

# RUN python3 get-pip.py

# airflow dep
RUN echo y | apt-get install libxml2-dev libxslt1-dev
RUN echo y | apt-get install python3-dev
RUN apt-get install zlib1g-dev
RUN echo y | apt-get install libevent-dev
RUN echo y | apt-get install libmysqlclient-dev
RUN echo y | apt-get install python-dev

# install airflow
RUN pip install airflow==1.7.1.3
RUN pip install airflow[mysql,celery]

ADD script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
ADD conf/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

EXPOSE 8080 5555 8793
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]
