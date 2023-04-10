# Version 0.0.1
# docker build -q=false -t="fmz/sandbox" . -f Dockerfile
FROM ubuntu:18.04
MAINTAINER Zero <golangnuts@outlook.com>
LABEL Description="This image is used for fmz docker"
ENV DEV_HOME /opt/dev
ENV GOROOT $DEV_HOME/gopkg/go
ENV GOPATH $DEV_HOME/gopath
ENV PATH $PATH:${GOROOT}/bin
ENV PYTHONIOENCODING utf-8
ARG ENV
RUN chmod 777 -R /tmp/


RUN apt-get update --fix-missing
RUN apt-get install wget p7zip clang make curl netcat xz-utils python python-dev python-setuptools python-pip zip unzip gcc git osslsigncode -y

# install compilers
RUN apt-get -y --allow-unauthenticated install apt-utils libssl1.0.0
RUN apt-get -y install vim curl make gcc-5-multilib g++-5-multilib gcc-5-arm-linux-gnueabi* g++-5-arm-linux-gnueabi* gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf gcc-arm-linux-gnueabi g++-arm-linux-gnueabi mingw-w64 python zip unzip g++ git libtool libsysfs-dev pkg-config automake libfreetype6-dev
RUN apt-get -y install gcc-7-multilib g++-7-multilib
RUN apt-get -y install g++-aarch64-linux-gnu gcc-aarch64-linux-gnu
RUN apt-get -y install opencl-dev
RUN ln -s /usr/include/asm-generic /usr/include/asm

# install ta-lib
RUN curl -L --retry 100 https://www.fmz.com/dist/pkg/ta-lib-0.4.0-src.tar.gz | tar xvz && cd ta-lib && ./configure --prefix=/usr/ --libdir=/usr/lib/ && make && make install && cd ../ && rm -rf ta-lib
RUN if [ "$ENV" = "mini" ] ; then \
    echo "Buiding mini version" \
    ; apt-get install -y python3 python3-pip language-pack-zh-hans; \
  else \
    pip install numpy==1.16.4 \
    ; pip install setuptools --no-binary :all: --upgrade --user \
    ; pip install Cython pandas==0.24.2 TA-Lib \
    ; pip install scipy==1.2.2 statsmodels==0.9.0 scikit-learn==0.20.3 hmmlearn==0.2.1 pykalman arch==4.8.1 \
    ; apt-get install -y python3 python3-pip language-pack-zh-hans \
    ; pip3 install --upgrade pip && rm /usr/bin/pip3 && ln -s /usr/local/bin/pip3 /usr/bin/pip3 \
    ; pip3 install --ignore-installed wrapt setuptools \
    ; pip3 install pandas numpy sklearn matplotlib seaborn scipy statsmodels scikit-learn arch requests \
    ; pip3 install TA-Lib \
    ; pip3 install tensorflow  \
    ; pip3 install torch torchvision; \
  fi

RUN apt-get clean && rm -rf ~/.cache/pip

RUN useradd noroot -u 1000 -s /bin/bash -d /home/noroot -m
USER noroot
