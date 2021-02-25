#!/bin/bash
set -e
set -x

cd /app
rm -rf build/CMake* || true
mkdir -p build
cd build
CMAKE=cmake
$CMAKE --version || CMAKE=cmake3
$CMAKE -DCMAKE_BUILD_TYPE=Debug ../opencv
BUILD_JOBS=${BUILD_JOBS:-$(nproc)}
cmake --build . --target opencv_test_videoio -- -j${BUILD_JOBS:-4}
