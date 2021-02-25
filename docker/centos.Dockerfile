ARG ver=centos8
FROM docker.io/centos:${ver} AS base
LABEL Name=opencv:${ver} Version=0.0.1
USER root
WORKDIR /

RUN yum -y update
RUN yum install -y epel-release

# Development Tools
RUN yum install -y cmake pkg-config
RUN yum groupinstall -y 'Development Tools'

# cmake 3.x
RUN yum -y install cmake3 && cp -f /usr/bin/cmake3 /usr/bin/cmake || true

CMD ["/bin/bash"]
