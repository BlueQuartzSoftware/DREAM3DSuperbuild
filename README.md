Dream3DSdkBuild
===============

This project uses the ExternalProject_Add() function in CMake 3.5.0 in order to attemp to build most of the [DREAM3D](http://dream3d.bluequartz.net) 3rd Party libraries that are needed in order to build DREAM3D. Note that we do **NOT** attempt to build [Qt5](http://www.qt.io) for you. This is a huge build and takes a VERY long time. You are responsible for building Qt5 for your project. This will build the following libraries:



+ Boost version 1.60.0
+ Doxygen (1.8.11) (Download and install only)
+ Eigen verison 3.2.8
+ HDF5 Version 1.8.16
+ ITK version 4.9.1
+ Protocol Buffers 2.6.1
+ Qt version 5.6.1
+ Qwt version 6.1.3
+ TBB version tbb44_20160524oss

## Platform Notes ##


### OS X ###

+ Doxygen is downloaded and installed into /Applications. You may need admin privs for this to work.
+ Qt 5.6.1 offline installer is downloaded and used for the installation.

### Windows 8.1/10 ###



### Linux ###

DREAM.3D should compile under GCC 4.8 or newer but Clang 3.8 is used for development.
You should be able to use "apt-get" or "yum" or your preferred package manager to get all the dependecies except possibly HDF5 1.8.16. If you need to build HDF5 1.8.13, build it as Shared Libraries and build all the types, (base, C++, High Level) and install it somewhere in the system.



