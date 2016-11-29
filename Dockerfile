FROM ubuntu:14.04

MAINTAINER ld00000 <lidong9144@gmail.com>

ARG AIRFLOW_VERSION=1.7.1.3
ENV AIRFLOW_HOME /airflow


RUN apt-get update
RUN echo y | apt-get install wget
RUN wget https://bootstrap.pypa.io/get-pip.py  --no-check-certificate

RUN echo y | apt-get autoremove python3.4 \
    && echo y | apt-get install python2.7 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 100 \
    && echo y | apt-get install python-pip

# airflow dep
RUN echo y | apt-get install libxml2-dev libxslt1-dev \
    && apt-get install zlib1g-dev \
    && echo y | apt-get install libevent-dev \
    && echo y | apt-get install libmysqlclient-dev \
    && echo y | apt-get install python-dev \
    && echo y | apt-get install libkrb5-dev \
    && echo y | apt-get install libsasl2-dev \
    && echo y | apt-get install libssl-dev \
    && echo y | apt-get install libffi-dev \
    && echo y | apt-get install build-essential \
    && echo y | apt-get install libblas-dev \
    && echo y | apt-get install liblapack-dev

# install airflow
RUN easy_install -U setuptools \
    && pip install -i http://pypi.douban.com/simple/ celery==3.1.23 \
    && pip install -i http://pypi.douban.com/simple/ airflow[mysql,celery,hive,hdfs,jdbc]==$AIRFLOW_VERSION \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
COPY conf/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

EXPOSE 8080 5555 8793

WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]
