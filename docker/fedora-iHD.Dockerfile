ARG ver=33
FROM opencv:fedora-${ver} AS base
LABEL Name=opencv:fedora-iHD-${ver} Version=0.0.1

RUN \
  dnf install -y dnf-plugins-core && \
  dnf copr enable -y jdanecki/intel-opencl && \
  dnf install -y \
    intel-opencl \
    clinfo \
    && \
  dnf clean all

RUN \
  dnf install -y \
    intel-media-driver \
    intel-mediasdk \
    libva-devel \
  && \
  dnf clean all

CMD ["/bin/bash"]
