#  ____    |__( )_________  __/__  /________      __
# ____  /| |_  /__  ___/_  /_ __  /_  __ \_ | /| / /
# ___  ___ |  / _  /   _  __/ _  / / /_/ /_ |/ |/ /
#  _/_/  |_/_/  /_/    /_/    /_/  \____/____/|__/
 
FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV AIRFLOW_VERSION 1.8.0
ENV AIRFLOW_HOME /usr/local/airflow
ENV LANGUAGE en_US.UTF-8

# Install all base image airflow linux system requirements
RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
    apt-utils \
    netcat \
    curl \
    python3-dev \
    python3-pip \
    libmysqlclient-dev \
    libkrb5-dev \
    libsasl2-dev \
    libssl-dev \
    libffi-dev \
    build-essential \
    locales \
    libmysqlclient-dev \
    unixodbc-dev \
    libblas-dev \
    liblapack-dev \
    gfortran \
    libpng-dev \
    libfreetype6-dev \
    pkg-config \
    wget

# Install Airflow's Dependencies
RUN pip3 install --upgrade pip \
    && pip install setuptools \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && pip install cython \
    && pip install requests \
    && pip install pytz==2015.7 \
    && pip install cryptography \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    # Install Airflow
    && pip install airflow==${AIRFLOW_VERSION} \
    && pip install airflow[celery]==${AIRFLOW_VERSION} \
    && pip install airflow[mysql]==${AIRFLOW_VERSION} \
    && pip install airflow[async]==${AIRFLOW_VERSION} \
    && pip install airflow[ldap]==${AIRFLOW_VERSION} \
    && pip install airflow[password]==${AIRFLOW_VERSION} \
    && pip install airflow[s3]==${AIRFLOW_VERSION} \
    && pip install airflow[slack]==${AIRFLOW_VERSION} \
    && pip install boto3 


RUN ln -sf /usr/bin/python3 /usr/bin/python

# Airflow configuration stuff
ADD config/airflow/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
ADD config/airflow/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN chown -R airflow: ${AIRFLOW_HOME} && \
    chmod +x ${AIRFLOW_HOME}/entrypoint.sh && \
    chown -R airflow: /tmp

# Incude import data
ADD packages ${AIRFLOW_HOME}/packages
ADD scripts  ${AIRFLOW_HOME}/scripts
ADD plugins ${AIRFLOW_HOME}/plugins


# Airflow RunTime Configs
USER airflow
EXPOSE 8080 5555 8793
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]
