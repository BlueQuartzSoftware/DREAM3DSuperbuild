# ![DREAM3D Logo](docs/Images/DREAM3DLogo.png) DREAM.3D Superbuild #

This project will download, configure and build a complete DREAM3D SDK and optionally also build DREAM3D itself. DREAM3D can be cloned from [https://www.github.com/bluequartzsoftware/DREAM3D](https://www.github.com/bluequartzsoftware/DREAM3D). DREAM.3D home page on the internet is at [http://dream3d.bluequartz.net](http://dream3d.bluequartz.net). All the documentation is also online and searchable at [http://www.dream3d.io](http://www.dream3d.io)

## Dependent Libraries ##

+ CMake 3.16.0
+ discount 2.2.3
+ haru 2.0.0
+ Eigen 3.3.9
+ HDF5 1.10.7
+ ITK 5.2.0
+ Qt 5.14.2
+ Qwt 6.1.5 or higher
+ TBB 2020.1
+ ghcFilesystem 1.3.2 (Linux/macOS)
+ pybind11 2.6.2
+ Python 3.7 (Anaconda Preferred) if you want to include the Python bindings. The script will NOT download or install Python. That is left as an exercise for the developer.
+ mkdocs (Python)

_Please note in the below instructions that the version of CMake on www.cmake.org may be newer than what is shown in the scree captures. That is perfectly normal.

### Windows ###

For information on how to build a DREAM.3D SDK using the DREAM3D Superbuild on Windows, please visit [Making an SDK (Windows)](https://github.com/bluequartzsoftware/DREAM3DSuperbuild/blob/develop/docs/Making_an_SDK_Windows.md).

### Mac OS X ###

For information on how to build a DREAM.3D SDK using the DREAM3D Superbuild on Mac OS X, please visit [Making an SDK (OS X)](https://github.com/bluequartzsoftware/DREAM3DSuperbuild/blob/develop/docs/Making_an_SDK_OSX.md).

### Linux ###

For information on how to build a DREAM.3D SDK using the DREAM3D Superbuild on Linux, please visit [Making an SDK (Linux)](https://github.com/bluequartzsoftware/DREAM3DSuperbuild/blob/develop/docs/Making_an_SDK_Linux.md).

## TL/DR ##

+ Install Git on your system
+ Install CMake on your system
+ Install a C++ compiler suite on your system
+ Clone this repository
+ Configure with CMake. Add the required CMake variable DREAM3D_SDK=/Some/Path/To/A/DREAM3D_SDK
+ If you want to also build DREAM.3D at the same time add the "WORKSPACE_DIR" cmake variable that points to a different folder than the DREAM3D_SDK folder.
+ Have CMake generate your build files
+ Open the project solution (Visual Studio) or open a terminal and use the default tool of choice to build.
  + Windows defaults to Visual Studio. Be sure the CMake generator that you select ends with "Win64"
  + macOS and Linux default to "MakeFiles".
+ When the process is finished a complete DREAM.3D application should be waiting for you to run.

## Alternate Download Site ##

If your corporate policy does not allow downloading from GitHub but does allow http downloading from http://dream3d.bluequartz.net then use the following CMake variable to use this alternate download site:

    DREAM3D_USE_CUSTOM_DOWNLOAD_SITE=ON

All sources and prebuilt binaries will be downloaded from the dream3d.bluequartz.net domain.


## Resources ##

+ General information is available at the [DREAM.3D home page](http://dream3d.bluequartz.net).

+ An online version of the DREAM.3D documentation is at [http://www.dream3d.io](http://www.dream3d.io)
