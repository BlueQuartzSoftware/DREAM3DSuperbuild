How To Use DREAM3DSuperbuild To Build A DREAM3D SDK (Windows 8.1/10)
===============

## Procedure ##

+ Ensure you have the proper Version of Visual Studio installed. Versions 2013 and 2015 are supported in this release and should be usable. Both the **Pro** and **Community** versions will work. The **Express** version of 2013 is known to work but not extensively tested.
+ Download the "ninja" build system from [https://github.com/ninja-build/ninja/releases](https://github.com/ninja-build/ninja/releases) and install on your system
+ Download and install CMake from [http://www.cmake.org](http://www.cmake.org). A minimum version of CMake 3.5.1 is required.
+ The [Qt 5.6.2 Online installer](http://download.qt.io/official_releases/qt/5.6/5.6.2/) is downloaded to the developers computer which is a smaller download but during the actual installation of Qt 5.6.2 the necessary files will be retrieved from Qt's official web site. Again be patient during this process.
+ Git version 2.x is also needed to clone the repositories and download certain sources. [http://www.git-scm.com](http://www.git-scm.com). You can download the prebuilt binary for Windows and install it onto the system. During the installation ensure that the "Windows command prompt" can use Git.

1: Open a Visual Studio command prompt for x64 development
2: Ensure ninja and CMake can be run from the command line. This many involve exporting a few environment variables from the command line.
3: Navigate to a directory where you want to checkout out the files from the repository.
4: Execute the following command to configure the SDK for building.

	cmake -G "Ninja" -DDREAM3D_SDK=C:/DREAM3D_SDK -DCMAKE_BUILD_TYPE=Debug ../

During the configuration process the Qt 5.6.x installer will be downloaded and executed. Be sure to install Qt into the DREAM3D_SDK folder. Sometimes during the installation of Qt the Qt installer application will crash. Simply try configuring again to relaunch the Qt installer. After the configuration is complete you will execute the following command to compile and install all the necessary libraries:

	ninja

After that has completed you will need to re-run the configuration and change the CMAKE_BUILD_TYPE to Release and compile and install again.

After this is all complete, ITK will be missing from the SDK. For Windows there is a specific batch file that will build it appropriately.

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
