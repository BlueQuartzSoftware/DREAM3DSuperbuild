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

## Prerequisites ##

DREAM.3D should compile under GCC 4.8.5 or newer.

You should be able to use "apt-get" or "yum" or your preferred package manager to get all the dependecies except possibly HDF5 1.10.3. If you need to build HDF5 1.10.3, build it as Shared Libraries and build all the types, (base, C++, High Level) and install it somewhere in the system.

+ Git
+ [CMake 3.13.x](http://www.cmake.org)
+ Compiler Suite (GCC 5.x is now required. Recent Versions of Clang will also work.)
+ _optionally_ install ninja from [GitHub](https://github.com/ninja-build/ninja/releases) or your package manager.

## Procedure ##

**Decide NOW** where you want the DREAM3D SDK to be built/installed. We sandbox the entire SDK so that we do not interfere with your system or in case you can not install to typical locations:

+ /usr/local/DREAM3_SDK
+ /opt/DREAM3D_SDK

are 2 possible locations to use. Make sure those directories are created and you have write access to them.

Clone this repository:

    cd $HOME
    git clone https://github.com/bluequartzsoftware/DREAM3DSuperbuild
    cd DREAM3Superbuild
    mkdir Debug && cd Debug
    cmake -DDREAM3D_SDK=/opt/DREAM3D_SDK -DCMAKE_BUILD_TYPE=Debug ../

... Wait for Qt to download and install... **PLEASE DO NOT ADJUST THE INSTALLATION LOCATION OF Qt5**. We depend on it being placed in the DREAM3D_SDK

    make -j or ninja 

... Wait for the build to complete. This may take a while (up to an hour on lesser hardware) for **each** type of build.

** Now create a Release build following generally the same procedure **

    cd $HOME/DREAM3DSuperbuild/
    mkdir Release && cd Release
    cmake -DDREAM3D_SDK=/opt/DREAM3D_SDK -DCMAKE_BUILD_TYPE=Release ../

... There is **NO** Qt5 download this time so it will go quickly.

    make -j or ninja

... Wait for the build to complete. This may take a while (up to an hour on lesser hardware) for **each** type of build.

## After Installation ##

You will now want to clone the actual DREAM.3D repositories and supporting respositories in order to build DREAM.3D. This can be done with the following commands:

    #!/bin/bash
    DEV_ROOT=$HOME/DREAM3D-Dev

    BRANCH="develop"

    RED='\033[0;31m'
    GREEN='\033[0;32m'
    NC='\033[0m'

    function printHeader()
    {
      echo -e "${GREEN}#------------------------------------------------------------------------"
      echo -e "${RED} $1 ${NC}"
    }

    function freshCheckout()
    {
      rootdir="$1"
      echo -e "${GREEN}#------------------------------------------------------------------------"
      echo -e "${RED} rootdir=$rootdir"

      mkdir -p "$rootdir"
      cd $rootdir

      printHeader DREAM3D
      git clone -b develop ssh://git@github.com/bluequartzsoftware/DREAM3D
      cd DREAM3D
      git remote add upstream ssh://git@github.com/bluequartzsoftware/DREAM3D

      mkdir ExternalProjects
      cd ExternalProjects

      REPOS="CMP SIMPL SIMPLView SIMPLVtkLib"
      for P in $REPOS; do
        cd $rootdir/DREAM3D/ExternalProjects
        printHeader $P
        git clone -b develop ssh://git@github.com/bluequartzsoftware/$P
        cd $P
        git remote add upstream ssh://git@github.com/bluequartzsoftware/$P
      done

      printHeader BrandedDREAM3D
      git clone -b develop ssh://git@gitlab.bluequartz.net/DREAM3D/BrandedDREAM3D
      cd BrandedDREAM3D
      git remote add upstream ssh://git@gitlab.bluequartz.net/DREAM3D/BrandedDREAM3D

      cd $rootdir/DREAM3D/ExternalProjects
      mkdir Plugins
      cd Plugins

      #------------------------------------------------------------------------------
      # These plugins are standard in DREAM.3D and are checked out into an "internal"
      # plugins directory

      PLUGINS="ITKImageProcessing\
      SimulationIO\
      ZeissImport"
      for P in $PLUGINS; do
        cd $rootdir/DREAM3D/ExternalProjects/Plugins
        printHeader $P
        git clone -b develop ssh://git@github.com/bluequartzsoftware/$P
        cd $P
        git remote add upstream ssh://git@github.com/bluequartzsoftware/$P
      done

      PLUGINS="Anisotropy\
      CellularAutomata\
      DDDAnalysisToolbox\
      DREAM3DReview\
      FiberToolbox\
      HEDMAnalysis\
      ImageProcessing\
      MASSIFUtilities\
      TransformationPhase\
      UCSBUtilities" 
      for P in $PLUGINS; do
        cd $rootdir/DREAM3D/ExternalProjects/Plugins
        printHeader $P
        git clone -b develop ssh://git@github.com/DREAM3D/$P
        cd $P
        git remote add upstream ssh://git@github.com/DREAM3D/$P
      done
    }

    freshCheckout "${DEV_ROOT}"

The previous shell script will create a folder called DREAM3D-Dev inside your home directory and clone the necessary repositories there.

