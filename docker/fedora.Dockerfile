ARG ver=33
FROM docker.io/fedora:${ver} AS base
LABEL Name=opencv:fedora-${ver} Version=0.0.1
USER root
WORKDIR /

RUN \
  dnf update -y && \
  dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
  && \
  dnf install -y \
    @development-tools \
    cmake ninja-build \
    zlib zlib-devel libjpeg-turbo libjpeg-turbo-devel libpng-devel \
    ffmpeg-devel \
    gstreamer1-devel gstreamer1 \
    gstreamer1-libav \
    gstreamer1-plugins-base-devel gstreamer1-plugins-base \
    gstreamer1-plugins-good \
    gstreamer1-plugins-bad-free \
    gstreamer1-plugins-ugly-free \
    gstreamer1-vaapi \
    libva-utils \
  && \
  dnf clean all

CMD ["/bin/bash"]
