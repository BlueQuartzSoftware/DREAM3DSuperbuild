
if(${CMAKE_MAJOR_VERSION} STREQUAL "3")
  # CMake 3.0 introduces VERSION variables for each Project.
  cmake_policy(SET CMP0048 NEW)
  # CMake 3.1 introduces if() policies on dereferencing variables in quotes
  cmake_policy(SET CMP0054 NEW)
endif()

cmake_minimum_required(VERSION 3.11.0)

project(DREAM3DSuperBuild VERSION 1.2.0.0 LANGUAGES C CXX)

# This allows us to just use the "include()" command and the name of the project
set(CMAKE_MODULE_PATH 
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake" 
        "${CMAKE_CURRENT_SOURCE_DIR}/projects" 
        ${CMAKE_MODULE_PATH})

set(BUILD_TYPE ${CMAKE_BUILD_TYPE})
if("${BUILD_TYPE}" STREQUAL "")
    set(BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()


# Set up some standard defaults, these will be passed down into external the
# projects.
include(BuildType)
include(BuildLocation)
include(ExternalProject)
include(download_dir)

# Use multiple CPU cores to build
include(ProcessorCount)
ProcessorCount(CoreCount)


if( "${DREAM3D_SDK}" STREQUAL "")
  message(FATAL_ERROR "Please specify the DREAM3D_SDK cmake variable which is the top level directory where all the DREAM.3D dependent libraries will be built")
endif()

set(DREAM3D_SDK_FILE ${DREAM3D_SDK}/DREAM3D_SDK.cmake)
set(download_dir ${DREAM3D_SDK})


message(STATUS "DREAM3D_SDK Folder: ${DREAM3D_SDK}")
message(STATUS "DREAM3D_SDK_FILE:   ${DREAM3D_SDK_FILE}")


set(BUILD_SHARED_LIBS ON)

if(APPLE)
  set(OSX_SDK "NOT-FOUND")
  EXEC_PROGRAM(uname ARGS -v  OUTPUT_VARIABLE DARWIN_VERSION)
  STRING(REGEX MATCH "[0-9]+" DARWIN_VERSION ${DARWIN_VERSION})
  #message(STATUS "DARWIN_VERSION: ${DARWIN_VERSION}")
  IF (DARWIN_VERSION EQUAL 14) # macOS 10.10 Yosemite
    message(STATUS "Found macOS 10.10 Yosemite as the host. Darwin Version:${DARWIN_VERSION}")
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 15) # macOS 10.11 El Capitan
    message(STATUS "Found macOS 10.11 El Capitan as the host. Darwin Version:${DARWIN_VERSION}")
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 16) # macOS 10.12 Sierra (Xcode 8.x or Xcode 9.x)
    message(STATUS "Found macOS 10.12 Sierra as the host. Darwin Version:${DARWIN_VERSION}")
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")
  ENDIF ()
  
  IF (DARWIN_VERSION EQUAL 17) # macOS 10.13 High Sierra (Xcode 9.x)
    message(STATUS "Found macOS 10.13 High Sierra as the host. Darwin Version:${DARWIN_VERSION}")  
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")
  ENDIF ()

  IF (DARWIN_VERSION EQUAL 18) # macOS 10.14 Mojave (Xcode 10.x)
    message(STATUS "Found macOS 10.14 Mojave as the host. Darwin Version:${DARWIN_VERSION}")
    set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")
  ENDIF ()

  if("${OSX_SDK}" STREQUAL "NOT-FOUND")
    message(FATAL_ERROR "This version of macOS (${DARWIN_VERSION}) is not recognized.\
    The following versions are supported:\n\
    (14) macOS 10.10 Yosemite\n\
    (15) macOS 10.11 El Capitan\n\
    (16) macOS 10.12 Sierra\n\
    (17) macOS 10.13 High Sierra\n\
    (18) macOS 10.14 Mojave\n\
    Please edit ${CMAKE_CURRENT_LIST_FILE} and add this version of macOS to the detection logic.
    ")

  endif()

  set(OSX_DEPLOYMENT_TARGET "10.10")

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/projects/apple/OSX_DREAM3D_SDK.cmake
              ${DREAM3D_SDK}/DREAM3D_SDK.cmake @ONLY )
elseif(WIN32)

  if(MSVC90)
    message(FATAL_ERROR "Visual Studio Version 9 2009 is NOT supported.")
  endif(MSVC90)
  if(MSVC10)
    message(FATAL_ERROR "Visual Studio Version 10 2010 is NOT supported.")
  endif(MSVC10)
  if(MSVC11)
    message(FATAL_ERROR "Visual Studio Version 11 2012 is NOT supported.")
  endif(MSVC11)
  if(MSVC12)
    message(FATAL_ERROR "Visual Studio Version 12 2013 is NOT supported.")
  endif(MSVC12)

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/projects/win32/WIN_DREAM3D_SDK.cmake
              ${DREAM3D_SDK}/DREAM3D_SDK.cmake COPYONLY )
else()

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/projects/unix/Linux_DREAM3D_SDK.cmake
              ${DREAM3D_SDK}/DREAM3D_SDK.cmake COPYONLY )
endif()

FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_SDK_VERSION ${DREAM3DSuperBuild_VERSION})\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(BUILD_SHARED_LIBS ON CACHE BOOL \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_SDK_ROOT \"${DREAM3D_SDK}\")\n")

FILE(APPEND ${DREAM3D_SDK_FILE} "\n#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# DREAM.3D does not use QtWebEngine to render the docs anymore. Let the system do it.\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(SIMPL_USE_QtWebEngine OFF)\n")

FILE(APPEND ${DREAM3D_SDK_FILE} "\n#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# Always write out the compile_commands.json file to help out things like QtCreator and VS Code\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)\n")


include(Python)
include(Pybind11)
include(Discount)
include(DREAM3DData)
#include(DOxygen)
include(Eigen)
include(HDF5)
include(TBB)
include(Haru)

option(BUILD_ITK "Build ITK" ON)
if("${BUILD_ITK}" STREQUAL "ON")
  include(ITK)
endif()

OPTION(BUILD_BOOST "Build Boost" OFF)
if("${BUILD_BOOST}" STREQUAL "ON")
  include(Boost)
endif()

OPTION(INSTALL_QT5 "Download and Install Qt5" ON)
if("${INSTALL_QT5}" STREQUAL "ON")
  include(Qt5)
elseif(NOT "${qt5_version_full}" STREQUAL "")
  set(extProjectName "Qt${qt5_version_full}")
  FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "# Qt5 ${qt5_version_full} Library\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(Qt5_DIR \"${Qt5_DIR}\" CACHE PATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${Qt5_DIR})\n")
else()
  message(WARNING "The DREAM3D_SDK.cmake file will be incomplete as intended. The paths to your Qt installation will be missing and DREAM.3D will probably not build.")
endif()

OPTION(BUILD_QWT "Build Qwt" ON)
if("${BUILD_QWT}" STREQUAL "ON")
  include(Qwt)
else()
  message(STATUS "Qwt is NOT being built. Plase be sure to set the QWT_INSTALL cmake variable when configuring DREAM3D")
endif()

OPTION(BUILD_DREAM3D "Build DREAM.3D" OFF)
if("${BUILD_DREAM3D}" STREQUAL "ON")
  include(DREAM3D)
endif()


file(READ ${CMAKE_CURRENT_SOURCE_DIR}/projects/DREAM3D_SDK_PluginList.txt DREAM3D_PLUGIN_CODE)
file(APPEND ${DREAM3D_SDK_FILE} ${DREAM3D_PLUGIN_CODE})

