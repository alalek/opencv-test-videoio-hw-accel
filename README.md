Collection of Linux docker files to test HW accelerated decode/encode in OpenCV VideoCapture and VideoWriter interfaces.
Plus script to build/run all or selective dockers.

Usage:
```
export OPENCV_SRC_DIR=<opencv_path>
export OPENCV_TEST_DATA_PATH=<opencv_extra>/testdata
OPENCV_TEST_ARGS=--gtest_filter=* ./run_dockers.sh
```

## Results
Log [summary](./summary/) from 2021-03-01:

Support matrix on Linux if use media libraries from standard and non-standard apt/yum repositories (no compilation from source code)
| Linux        | Failures | Package repositories | va-driver | libmfx | ffmpeg | gst reamer | cv:: VideoCapture | cv:: VideoWriter |
| ------------ | ---------| -------------------- | --------- | ------ | ------ | ---------- | ----------------- | -----------------|
| Ubuntu 18.04 | &#x2714; | [(default apt)](./docker/ubuntu.Dockerfile)| i965 2.1.0 |  -      | 3.4.8  | 1.14.5    | &#x2714;<br/>GST:VAAPI(5) | &#x2714; - |
| Ubuntu 20.04 | &#x2714; | [(default apt)](./docker/ubuntu.Dockerfile)| 20.1.1 | -      | 4.2.4  | 1.16.2    | &#x2714;<br/>FFMPEG:VAAPI(6) | &#x2714; - |
| | &#x2714;              | [non-free](./docker/ubuntu-non-free.Dockerfile) | 20.1.1  | 20.1.0  | 4.2.4  | 1.16.2    | &#x2714;<br/>FFMPEG:VAAPI(6) | &#x2714;<br/>GST:VAAPI(3) |
| | &#x2714;              | [+intel.com](./docker/ubuntu-intel.Dockerfile) | 21.1.0 | 21.1.0 | 4.2.4  | 1.16.2    | &#x2714;<br/>FFMPEG:VAAPI(6) | &#x2714;<br/>GST:VAAPI(3) |
| Ubuntu 21.04 | &#x2716; &#x2716; &#x2716; (crash) | [(default apt)](./docker/ubuntu.Dockerfile) | 21.1.1 | 21.1.0 | 4.3.2  | 1.18.3 | &#x2716;<br/>? | &#x2716;<br/>? |
| | &#x2716; &#x2716; &#x2716; (crash) | [non-free](./docker/ubuntu-non-free.Dockerfile) | 21.1.1 | 21.1.0 | 4.3.2  | 1.18.3 | &#x2716;<br/>? | &#x2716;<br/>? |
| CentOS 7 | &#x2714;     | [(default yum)](./docker/centos.Dockerfile) | -     | -      | -      | -         | - | - |
| | &#x2714; | [+rpmfusion.com](./docker/centos-rpmfusion.Dockerfile) | i965 | 1.21 | 3.4.8 | 1.10.4 | - | - |
| | &#x2716; (2+0+0) | [+negativo17.com](./docker/centos-negativo17.Dockerfile) | 20.4.5 | 20.3.1 | 4.3.1 | 1.16.1 | - | - |
| CentOS 8 | &#x2714;     | [(default yum)](./docker/centos.Dockerfile) | - | - | - | - | - | - |
| | &#x2714; | [+rpmfusion.com](./docker/centos-rpmfusion.Dockerfile) | i965 2.4.1 | 1.25 | 4.2.4 | 1.16.1 | - | - |
| | &#x2714; | [+rpmfusion.com<br/>+intel.com](./docker/centos-rpmfusion-intel.Dockerfile) | 21.1.0 | 21.1.0 | 4.2.4  | 1.16.1 | &#x2714;<br/>FFMPEG:VAAPI(6) | &#x2714;<br/>FFMPEG:VAAPI(3) |
| | &#x2716; (2+2+0) | [+negativo17.com](./docker/centos-negativo17.Dockerfile) | 20.4.5   | 20.3.1 | 4.3.1  | 1.16.1    | &#x2716;<br/>FFMPEG:VAAPI(6) | &#x2716;<br/>FFMPEG:VAAPI(3),MFX(3) |
| | &#x2716; (2+2+0) | [+negativo17.com<br/>+intel.com](./docker/centos-negativo17-intel.Dockerfile) | 21.1.0 | 21.1.0 | 4.3.1  | 1.16.1 | &#x2716;<br/>FFMPEG:VAAPI(6) | &#x2716;<br/>FFMPEG:VAAPI(3),MFX(3) |
| Fedora 33 | &#x2714; | [(base)](./docker/fedora.Dockerfile) | - | - | 4.3.2 | 1.18.2 | &#x2714; - | &#x2714; - |
| | &#x2714; | [i965](./docker/fedora-i965.Dockerfile) | i965 2.4.1 | 20.3.1 | 4.3.2 | 1.18.2 | &#x2714;<br/>GST:VAAPI(3) | &#x2714;<br/>GST:VAAPI(1) |
| | &#x2714; | [i965<br/>+libva-devel](./docker/fedora-i965-have_va.Dockerfile) | i965 2.4.1 | 20.3.1 | 4.3.2 | 1.18.2 | &#x2714;<br/>GST:VAAPI(3) | &#x2714;<br/>GST:VAAPI(1) |
| | &#x2714; | [iHD](./docker/fedora-iHD.Dockerfile) | iHD 20.3.0 | 20.3.1 | 4.3.2 | 1.18.2 | &#x2714;<br/>FFMPEG:VAAPI(6)<br/>GST:VAAPI(3) | &#x2714;<br/>FFMPEG:VAAPI(3),MFX(3)<br/>GST:VAAPI(1) |


Ubuntu 21.04 crash point (with/without the patch):

```
[ RUN      ] videoio/videocapture_acceleration.read/20, where GetParam() = (sample_322x242_15frames.yuv420p.mpeg2video.mp4, GSTREAMER, NONE, false)
[ INFO:0] global /app/opencv/modules/videoio/src/cap_gstreamer.cpp (831) open OpenCV | GStreamer: /app/testdata/highgui/video/sample_322x242_15frames.yuv420p.mpeg2video.mp4
[ INFO:0] global /app/opencv/modules/videoio/src/cap_gstreamer.cpp (864) open OpenCV | GStreamer: mode - FILE
error: XDG_RUNTIME_DIR not set in the environment.
error: XDG_RUNTIME_DIR not set in the environment.
error: XDG_RUNTIME_DIR not set in the environment.
[ WARN:0] global /app/opencv/modules/videoio/src/cap_gstreamer.cpp (1044) open OpenCV | GStreamer warning: unable to query duration of stream
[ WARN:0] global /app/opencv/modules/videoio/src/cap_gstreamer.cpp (1081) open OpenCV | GStreamer warning: Cannot query video position: status=1, value=0, duration=-1
VideoCapture GSTREAMER:VAAPI
VideoCapture with acceleration = VAAPI  @ GSTREAMER  on sample_322x242_15frames.yuv420p.mpeg2video.mp4 with PSNR-original = 31.2869
free(): invalid next size (normal)
/app/run_test.sh: line 10:    13 Segmentation fault      (core dumped) /app/build/bin/opencv_test_videoio "$@"
opencv_test_videoio FAILED with errorcode=139
```
