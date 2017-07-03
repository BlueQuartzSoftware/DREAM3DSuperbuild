How To Use DREAM3DSuperbuild To Build A DREAM3D SDK (Linux)
===============

## Procedure ##

DREAM.3D should compile under GCC 4.8 or newer but Clang 3.8 is used for development.
You should be able to use "apt-get" or "yum" or your preferred package manager to get all the dependecies except possibly HDF5 1.8.16. If you need to build HDF5 1.8.13, build it as Shared Libraries and build all the types, (base, C++, High Level) and install it somewhere in the system.

## Additional Notes ##
The procedure above builds the following libraries:

+ Boost version 1.60.0
+ Doxygen (1.8.11) (Download and install only)
+ Eigen verison 3.2.9
+ HDF5 Version 1.8.16
+ ITK version 4.9.1
+ Protocol Buffers 2.6.1
+ Qt version 5.6.2
+ Qwt version 6.1.3
+ TBB version tbb44_20160524oss
