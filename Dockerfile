# Version 0.0.1
FROM centos
MAINTAINER Zero <admin@botvs.com>
LABEL Description="This image is used for botvs sandbox"
# install cross compiler
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo && yum clean all && yum makecache
RUN yum install make python python-devel python-setuptools tkinter zip unzip gcc git blas-devel lapack-devel -y
RUN curl -L --retry 100 http://q.botvs.net/pkg/ta-lib-0.4.0-src.tar.gz | tar xvz
RUN cd ta-lib && ./configure --prefix=/usr/ --libdir=/lib64 && make && make install && cd ../ && rm -rf ta-lib
RUN easy_install -i http://mirrors.aliyun.com/pypi/simple/ pip
RUN pip --no-cache-dir install --trusted-host mirrors.aliyun.com -i http://mirrors.aliyun.com/pypi/simple/ numpy TA-Lib
RUN pip --no-cache-dir install --trusted-host mirrors.aliyun.com -i http://mirrors.aliyun.com/pypi/simple/ statsmodels scikit-learn hmmlearn pykalman arch matplotlib
RUN yum clean all
RUN useradd noroot -u 1000 -s /bin/bash --no-create-home
USER noroot

