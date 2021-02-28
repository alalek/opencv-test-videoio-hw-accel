#!/bin/bash
set -e

echo "===== clinfo"
clinfo || true
echo "===== vainfo"
vainfo || true
echo "Testing args: $@"
export GTEST_COLOR=0
/app/build/bin/opencv_test_videoio "$@" || echo "opencv_test_videoio FAILED with errorcode=$?"
