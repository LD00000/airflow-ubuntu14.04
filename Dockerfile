FROM ubuntu:14.04

MAINTAINER ld00000 <lidong9144@163.com>

ARG AIRFLOW_VERSION=1.7.1.3
ENV AIRFLOW_HOME /airflow

RUN apt-get autoclean && apt-get --purge -y autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
ADD conf/163-sources.list /etc/apt/sources.list

RUN apt-get update
RUN echo y | apt-get install wget
RUN wget https://bootstrap.pypa.io/get-pip.py  --no-check-certificate

# RUN echo y | apt-get autoremove python3.4
RUN echo y | apt-get install python2.7
# RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 100

RUN echo y | apt-get install python3-dev && echo y | apt-get install python-pip

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
    && echo y | apt-get install liblapack-dev \
    && echo y | apt-get install curl

# install airflow
RUN easy_install -U setuptools
RUN pip install -i http://pypi.douban.com/simple/ Cython \
    && pip install -i http://pypi.douban.com/simple/ pytz==2015.7 \
    && pip install -i http://pypi.douban.com/simple/ cryptography \
    && pip install -i http://pypi.douban.com/simple/ pyOpenSSL \
    && pip install -i http://pypi.douban.com/simple/ ndg-httpsclient \
    && pip install -i http://pypi.douban.com/simple/ pyasn1 \
    && pip install -i http://pypi.douban.com/simple/ pandas==0.18.1 \
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

RUN groupadd -r airflow && useradd -r -g airflow airflow
RUN (echo "airflow";sleep 1;echo "airflow") | passwd airflow > /dev/null

RUN chown -R airflow: ${AIRFLOW_HOME} \
    && chmod +x ${AIRFLOW_HOME}/entrypoint.sh
USER airflow

WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]
