
if(${CMAKE_MAJOR_VERSION} STREQUAL "3")
  # CMake 3.0 introduces VERSION variables for each Project.
  cmake_policy(SET CMP0048 NEW)
  # CMake 3.0 introduces some OS X RPath policies
  cmake_policy(SET CMP0042 OLD)
  # CMake 3.1 introduces if() policies on dereferencing variables in quotes
  cmake_policy(SET CMP0054 NEW)
endif()

cmake_minimum_required(VERSION 3.5.0)

project(DREAM3DSuperBuild VERSION 1.0.0.0 LANGUAGES C CXX)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

# Set up some standard defaults, these will be passed down into external the
# projects.
include(BuildType)
include(BuildLocation)

include(ExternalProject)
include(download_dir)

if( "${DREAM3D_SDK}" STREQUAL "")
  message(FATAL_ERROR "Please specify the DREAM3D_SDK cmake variable which is the top level directory where all the DREAM.3D dependent libraries will be built")
endif()

set(DREAM3D_SDK_FILE ${DREAM3D_SDK}/DREAM3D_SDK.cmake)
set(download_dir ${DREAM3D_SDK})

message(STATUS "DREAM3D_SDK: ${DREAM3D_SDK}")
message(STATUS "DREAM3D_SDK_FILE: ${DREAM3D_SDK_FILE}")


set(BUILD_SHARED_LIBS ON)

# Use multiple CPU cores to build
include(ProcessorCount)
ProcessorCount(CoreCount)


if(APPLE)

   EXEC_PROGRAM(uname ARGS -v  OUTPUT_VARIABLE DARWIN_VERSION)
   STRING(REGEX MATCH "[0-9]+" DARWIN_VERSION ${DARWIN_VERSION})

   IF (DARWIN_VERSION EQUAL 16)
     
   ENDIF ()


  set(OSX_DEPLOYMENT_TARGET "10.10")
  set(OSX_SDK "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk")

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/OSX_DREAM3D_SDK.cmake
                ${DREAM3D_SDK}/DREAM3D_SDK.cmake COPYONLY )
elseif(WIN32)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/WIN_DREAM3D_SDK.cmake
                ${DREAM3D_SDK}/DREAM3D_SDK.cmake COPYONLY )
else()
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/Linux_DREAM3D_SDK.cmake
                ${DREAM3D_SDK}/DREAM3D_SDK.cmake COPYONLY )
endif()


FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(BUILD_SHARED_LIBS ON CACHE BOOL \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_SDK_ROOT \"${DREAM3D_SDK}\")\n")


include(External_DREAM3DData)
include(External_DOxygen)
include(External_Eigen)
include(External_HDF5)
include(External_ITK)
if("${BUILD_BOOST}" STREQUAL "ON")
  include(External_Boost)
endif()
include(External_TBB)
include(External_Qt5)
include(External_Qwt)

# include(External_ProtoBuf)

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/cmake/DREAM3D_SDK_PluginList.txt DREAM3D_PLUGIN_CODE)
file(APPEND ${DREAM3D_SDK_FILE} ${DREAM3D_PLUGIN_CODE})

