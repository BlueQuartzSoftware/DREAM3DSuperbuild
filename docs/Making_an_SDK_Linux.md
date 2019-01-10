# Making an SDK (Linux) #

<a name="prerequisites">

## Prerequisites ##

</a>

These prerequisites need to be completed before making a DREAM.3D SDK.

If you have already fulfilled all of these prerequisites, skip to the [Procedure](#procedure) section.

<a name="compiler_suite">

### Install a Compiler Suite ###

</a>

A compatible compiler needs to be installed on your system to be able to build DREAM.3D.

For more information, please visit [Installing a Compiler Suite](http://dream3d.bluequartz.net/binaries/Help/DREAM3D/compiler_suite.html).

## Procedure ##

DREAM.3D should compile under GCC 4.8 or newer but Clang 3.8 is used for development.
You should be able to use "apt-get" or "yum" or your preferred package manager to get all the dependecies except possibly HDF5 1.8.16. If you need to build HDF5 1.8.13, build it as Shared Libraries and build all the types, (base, C++, High Level) and install it somewhere in the system.

## Additional Notes ##

The procedure above builds the following libraries:

+ Eigen 3.3.5 or higher
+ HDF5 1.20.3.20 or higher
+ ITK 4.13.2 or higher
+ Qt 5.11.1 or higher
+ Qwt 6.1.3 or higher
+ TBB 2018_20180618 or higher

---
**Previous Page**: [Installing a Compiler Suite](http://dream3d.bluequartz.net/binaries/Help/DREAM3D/compiler_suite.html)