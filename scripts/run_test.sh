#!/bin/bash
set -e
set -x

clinfo || true
vainfo || true
echo "Testing args: $@"
/app/build/bin/opencv_test_videoio "$@"
