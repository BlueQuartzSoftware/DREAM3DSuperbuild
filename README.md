Dream3DSdkBuild
===============

This project uses the ExternalProject_Add() function in CMake 3.5.0 in order to attemp to build most of the [DREAM3D](http://dream3d.bluequartz.net) 3rd Party libraries that are needed in order to build DREAM3D. Note that we do **NOT** attempt to build [Qt5](http://www.qt.io) for you. This is a huge build and takes a VERY long time. You are responsible for building Qt5 for your project. This will build the following libraries:



+ Boost version 1.60.0
+ Doxygen (1.8.11) (Download and install only)
+ Eigen verison 3.2.9
+ HDF5 Version 1.8.16
+ ITK version 4.9.1
+ Protocol Buffers 2.6.1
+ Qt version 5.6.1
+ Qwt version 6.1.3
+ TBB version tbb44_20160524oss

## Platform Notes ##


### OS X ###

+ Doxygen is downloaded and installed into /Applications. You may need admin privs for this to work.
+ Qt 5.6.2 offline installer is downloaded and used for the installation. The installer is over 750MB in size so be patient during the download.

### Windows 8.1/10 ###

+ Ensure you have the proper Version of Visual Studio installed. Versions 2013 and 2015 are supported in this release and should be usable. Both the **Pro** and **Community** versions will work. The **Express** version of 2013 is known to work but not extensively tested.
+ Download the "ninja" build system from [https://github.com/ninja-build/ninja/releases](https://github.com/ninja-build/ninja/releases) and install on your system
+ Download and install CMake from [http://www.cmake.org](http://www.cmake.org). A minimum version of CMake 3.5.1 is required.
+ The [Qt 5.6.2 Online installer](http://download.qt.io/official_releases/qt/5.6/5.6.2/) is downloaded to the developers computer which is a smaller download but during the actual installation of Qt 5.6.2 the necessary files will be retrieved from Qt's official web site. Again be patient during this process.
+ Git version 2.x is also needed to clone the repositories and download certain sources. [http://www.git-scm.com](http://www.git-scm.com). You can download the prebuilt binary for Windows and install it onto the system. During the installation ensure that the "Windows command prompt" can use Git.


#### Procedure ####

1: Open a Visual Studio command prompt for x64 development
2: Ensure ninja and CMake can be run from the command line. This many involve exporting a few environment variables from the command line.
3: Navigate to a directory where you want to checkout out the files from the repository.
4: Execute the following command to configure the SDK for building.

	cmake -G "Ninja" -DDREAM3D_SDK=C:/DREAM3D_SDK -DCMAKE_BUILD_TYPE=Debug ../

During the configuration process the Qt 5.6.x installer will be downloaded and executed. Be sure to install Qt into the DREAM3D_SDK folder. Sometimes during the installation of Qt the Qt installer application will crash. Simply try configuring again to relaunch the Qt installer. After the configuration is complete you will execute the following command to compile and install all the necessary libraries:

	ninja

After that has completed you will need to re-run the configuration and change the CMAKE_BUILD_TYPE to Release and compile and install again.

After this is all complete, ITK will be missing from the SDK. For Windows there is a specific batch file that will build it appropriately.




### Linux ###

DREAM.3D should compile under GCC 4.8 or newer but Clang 3.8 is used for development.
You should be able to use "apt-get" or "yum" or your preferred package manager to get all the dependecies except possibly HDF5 1.8.16. If you need to build HDF5 1.8.13, build it as Shared Libraries and build all the types, (base, C++, High Level) and install it somewhere in the system.


## Instructions ##

### Basic Setup ##

1: Download and install CMake from http://www.cmake.org. A minimum version of CMake 3.5.1 is required.
2: Download, build and install the "Ninja" build system from (https://github.com/ninja-build/ninja/releases)[https://github.com/ninja-build/ninja/releases] and make sure ninja is on your path.

### Clone Repository ##

Use git to clone the DREAM.3D Superbuild repository at (https://github.com/bluequartzsoftware/DREAM3DSuperbuild)[https://github.com/bluequartzsoftware/DREAM3DSuperbuild]

    git clone https://github.com/bluequartzsoftware/DREAM3DSuperbuild

Use CMake to treat the **DREAM3DSuperbuild** directory as the __Source__ directory and then select another directory for the **Where to build the binaries**. Run **Configure** from CMake at which point Qt5 will be downloaded and installed. Then **Generate** the build files. After the build files have been generated either open a new terminal or open the generate project files if you used either "Visual Studio" or "Xcode."

** Please be patient as the entire process can take a while to build all the dependent libraries **


