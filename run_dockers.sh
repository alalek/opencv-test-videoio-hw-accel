#!/bin/bash

DISTRIBS=${1:-ubuntu:18.04 \
  ubuntu:20.04 \
  ubuntu:21.04 \
  ubuntu-non-free:20.04 \
  ubuntu-non-free:21.04 \
  ubuntu-intel:20.04 \
  centos:centos7 \
  centos:centos8 \
  centos-rpmfusion:centos7 \
  centos-rpmfusion:centos8 \
  centos-rpmfusion-intel:centos8 \
  centos-negativo17:centos7 \
  centos-negativo17:centos8 \
  centos-negativo17-intel:centos8 \
  fedora:33 \
  fedora-i965:33 \
  fedora-i965-have_va:33 \
  fedora-iHD:33 \
  }

BASEDIR="$(dirname "$(readlink -fm "$0")")"

if [[ -d "${BASEDIR}/../modules" ]]; then
  OPENCV_SRC_DIR="$(dirname "$BASEDIR")"
else
  OPENCV_SRC_DIR=${OPENCV_SRC_DIR?Specify OPENCV_SRC_DIR}
fi

OPENCV_TEST_DATA_PATH=${OPENCV_TEST_DATA_PATH?Specify OPENCV_TEST_DATA_PATH}

DOCKER_CMD=${DOCKER_CMD:-sudo docker}
DOCKER_RUN_OPTS=${DOCKER_RUN_OPTS:---memory=6Gb --memory-swap=6Gb}
OPENCV_TEST_ARGS=${OPENCV_TEST_ARGS:---gtest_filter=*accel*}

mkdir -p logs

for dis in ${DISTRIBS}; do
  name=$(echo $dis | cut -f1 -d:)
  ver=$(echo $dis | cut -f2 -sd:)
  if [[ -n "${ver}" ]]; then
    tag="${name}-${ver}"
  else
    tag="${name}"
  fi
  echo "################# building docker image opencv:${tag}"

  ${DOCKER_CMD} build -f ${BASEDIR}/docker/${name}.Dockerfile --build-arg ver=${ver} -t opencv:${tag} ${BASEDIR}/docker > logs/docker_build_${tag}.log
  retVal=$?

  if [ $retVal -eq 0 ]; then
    echo "----------------- building OpenCV (build/${tag})"
    mkdir -p build/${tag}
    ${DOCKER_CMD} run --rm -it --user $(id -u):$(id -g) ${DOCKER_RUN_OPTS} \
      -v $BASEDIR/scripts/build.sh:/app/build.sh \
      -v $BASEDIR/build/${tag}:/app/build \
      -v $OPENCV_SRC_DIR:/app/opencv \
      opencv:${tag} bash -c /app/build.sh > logs/build_${tag}.log

    echo "----------------- running ${tag} ${OPENCV_TEST_ARGS}"
    ${DOCKER_CMD} run --rm -it ${DOCKER_RUN_OPTS} \
      --privileged --net=host \
      -v $BASEDIR/scripts/run_test.sh:/app/run_test.sh \
      -v $BASEDIR/build/${tag}:/app/build \
      -v $OPENCV_TEST_DATA_PATH:/app/testdata \
      -e OPENCV_TEST_DATA_PATH=/app/testdata \
      opencv:${tag} /bin/sh -c "/app/run_test.sh ${OPENCV_TEST_ARGS}" > logs/run_test_${tag}.log 2>&1
    #tail logs/run_test_${tag}.log

    mkdir -p summary
    ${DOCKER_CMD} run --rm ${DOCKER_RUN_OPTS} opencv:${tag} sh -c 'apt list --installed; yum list installed' | \
        grep -e va-driver -e mfx -e ffmpeg -e libva -e opencl -e intel-media -e gstreamer -e i965 > summary/${tag}.txt
    echo "================================================ ACCELERATION ALL" >> summary/${tag}.txt
    grep -e "acceleration =" -e "PSNR-original" logs/run_test_${tag}.log >> summary/${tag}.txt
    echo "================================================ ACCELERATION HW" >> summary/${tag}.txt
    grep "acceleration =" logs/run_test_${tag}.log | grep -v NONE | sort --unique >> summary/${tag}.txt
    echo "================================================ FAILED" >> summary/${tag}.txt
    grep -e "FAILED" -e "Segmentation fault" logs/run_test_${tag}.log >> summary/${tag}.txt
    echo "================================================ PASSED TESTS" >> summary/${tag}.txt
    grep "PASSED" logs/run_test_${tag}.log >> summary/${tag}.txt
    echo SUMMARY
    cat summary/${tag}.txt
  else
    tail logs/docker_build_${tag}.log
  fi
done
