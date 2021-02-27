#!/bin/bash
set -e
set -x

clinfo || true
vainfo || true
echo "Testing args: $@"
export GTEST_COLOR=0
/app/build/bin/opencv_test_videoio "$@"
