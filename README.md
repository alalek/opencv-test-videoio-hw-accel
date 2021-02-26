Collection of Linux docker files to test HW accelerated decode/encode in OpenCV VideoCapture and VideoWriter interfaces.
Plus script to build/run all or selective dockers.

Usage:
```
export OPENCV_SRC_DIR=<opencv_path>
export OPENCV_TEST_DATA_PATH=<opencv_extra>/testdata
OPENCV_TEST_ARGS=--gtest_filter=* ./run_dockers.sh
```

## Results
Log [summary](./summary/)

Support matrix on Linux if use media libraries from standard and non-standard apt/yum repositories (no compilation from source code)
| Linux        | Failures | Package repositories | va-driver | libmfx | ffmpeg | gst reamer | cv:: VideoCapture | cv:: VideoWriter |
| ------------ | ---------| -------------------- | --------- | ------ | ------ | ---------- | ----------------- | -----------------|
| Ubuntu 18.04 | &#x2714; | [(default apt)](./docker/ubuntu.Dockerfile)| i965 2.1.0 |  -      | 3.4.8  | 1.14.5    | VAAPI@GSTREAMER(6) | - |
| Ubuntu 20.04 | &#x2714; | [(default apt)](./docker/ubuntu.Dockerfile)| 20.1.1 | -      | 4.2.4  | 1.16.2    | VAAPI@FFMPEG(6) | - |
| | &#x2714;              | [non-free](./docker/ubuntu-non-free.Dockerfile) | 20.1.1  | 20.1.0  | 4.2.4  | 1.16.2    | VAAPI@FFMPEG(6) | VAAPI@FFMPEG(3) |
| | &#x2714;              | [+intel.com](./docker/ubuntu-intel.Dockerfile) | 21.1.0 | 21.1.0 | 4.2.4  | 1.16.2    | VAAPI@FFMPEG(6) | VAAPI@FFMPEG(3) |
| Ubuntu 21.04 | &#x2714; | [(default apt)](./docker/ubuntu.Dockerfile) | 21.1.1 | 21.1.0 | 4.3.1  | 1.18.3 (no plugins) | VAAPI@FFMPEG(6) | - |
| | &#x2716; (1)          | [non-free](./docker/ubuntu-non-free.Dockerfile) | 21.1.1 | 21.1.0 | 4.3.1  | 1.18.3 (no plugins) | VAAPI@FFMPEG(6) MFX@FFMPEG(3) | VAAPI@FFMPEG(3) MFX@FFMPEG(3) |
| CentOS 7 | &#x2714;     | [(default yum)](./docker/centos.Dockerfile) | -     | -      | -      | -         | - | - |
| | &#x2714; | [+rpmfusion.com](./docker/centos-rpmfusion.Dockerfile) | i965 | 1.21 | 3.4.8 | 1.10.4 | - | - |
| | &#x2716; (5) | [+negativo17.com](./docker/centos-negativo17.Dockerfile) | 20.4.5 | 20.3.1 | 4.3.1 | 1.16.1 | VAAPI@FFMPEG(6) MFX@FFMPEG(3) | VAAPI@FFMPEG(3) MFX@FFMPEG(3) |
| CentOS 8 | &#x2714;     | [(default yum)](./docker/centos.Dockerfile) | - | - | - | - | - | - |
| | &#x2716; (6+4) | [+rpmfusion.com](./docker/centos-rpmfusion.Dockerfile) | i965 | 1.25 | 4.2.4 | 1.16.1 | - | - |
| | &#x2714; | [+rpmfusion.com<br/>+intel.com](./docker/centos-rpmfusion-intel.Dockerfile) | 21.1.0 | 21.1.0 | 4.2.4  | 1.16.1 | VAAPI,MFX | VAAPI |
| | &#x2716; (1+9+4+4) | [+negativo17.com](./docker/centos-negativo17.Dockerfile) | 20.4.5   | 20.3.1 | 4.3.1  | 1.16.1    | VAAPI,MFX | MFX,VAAPI |
| | &#x2716; (1+9+4+4) | [+negativo17.com<br/>+intel.com](./docker/centos-negativo17-intel.Dockerfile) | 21.1.0 | 21.1.0 | 4.3.1  | 1.16.1    | VAAPI,MFX       | MFX,VAAPI      |
| Fedora 33 | &#x2716; (0+4+2) | [(base)](./docker/fedora.Dockerfile) | - | - | 4.3.1 | 1.18.2 | &#x2714; - | &#x2716; (4?) - |
| | &#x2716; (6+0+6) | [i965](./docker/fedora-i965.Dockerfile) | i965 2.4.1 | 20.3.1 | | | &#x2716; (6) VAAPI | &#x2714; (2) VAAPI@FFMPEG |
| | &#x2716; (10+0+6) | [i965<br/>+libva-devel](./docker/fedora-i965-have_va.Dockerfile) | i965 2.4.1 | 20.3.1 | | | &#x2716; VAAPI,MFX | &#x2714; (2) VAAPI@FFMPEG |
| | &#x2716; (1+0+2) | [iHD](./docker/fedora-iHD.Dockerfile) | iHD 20.3.0 | 20.3.1 | 4.3.1  | 1.16.1    | &#x2716; VAAPI,MFX | &#x2714; VAAPI,MFX |
