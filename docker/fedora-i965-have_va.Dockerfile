ARG ver=33
FROM opencv:fedora-i965-${ver} AS base
LABEL Name=opencv:fedora-i965-have_va-${ver} Version=0.0.1

RUN \
  dnf install -y \
    libva-devel \
  && \
  dnf clean all

CMD ["/bin/bash"]
