Dream3DSdkBuild
===============

This project uses the ExternalProject_Add() function in CMake 3.0.0 in order to attemp to build most of the [DREAM3D](http://dream3d.bluequartz.net) 3rd Party libraries that are needed in order to build DREAM3D. Note that we do **NOT** attempt to build [Qt5](http://www.qt-project.org) for you. This is a huge build and takes a VERY long time. You are responsible for building Qt5 for your project. This will build the following libraries:


+ HDF5 Version 1.8.13
+ Boost version 1.56.0
+ Doxygen (1.8.7) (Download and install only)
+ TBB version tbb42_20140601oss
+ ITK version 4.5.1
+ Eigen verison 3.2.1
+ Qwt version 6.1

## Platform Notes ##

### OS X ###

+ Doxygen is downloaded and installed into /Applications. You may need admin privs for this to work.
+ Threading Building Blocks are built from source in order to get the install_name correct in the built libraries.


### Windows Vista/7/8 ###



### Linux ###

You should be able to use "apt-get" or "yum" or your preferred package manager to get all the dependecies except possibly HDF5 1.8.13. If you need to build HDF5 1.8.13, build it as Shared Libraries and build all the types, (base, C++, High Level) and install it somewhere in the system.



