
project(Dream3DSdkBuild)

cmake_minimum_required(VERSION 3.0.0)

# ------------------------------------------------------------------------------
#  Qt 5 Section
# ------------------------------------------------------------------------------
find_package(Qt5Core)
get_target_property(QtCore_location Qt5::Core LOCATION)
find_package(Qt5Widgets)
get_target_property(Qt5Widgets_location Qt5::Widgets LOCATION)
find_package(Qt5Network)
get_target_property(Qt5Network_location Qt5::Network LOCATION)
find_package(Qt5Gui)
get_target_property(Qt5Gui_location Qt5::Gui LOCATION)
find_package(Qt5Concurrent)
get_target_property(Qt5Concurrent_location Qt5::Concurrent LOCATION)

if(Qt5Core_FOUND)
  message(STATUS "Qt5Core Found at ${QtCore_location}")
  message(STATUS "Qt5Widgets Found at ${Qt5Widgets_location}")
  message(STATUS "Qt5Network Found at ${Qt5Network_location}")
  message(STATUS "Qt5Gui Found at ${Qt5Gui_location}")
else()
  message(FATAL_ERROR "Qt Version 5.x was NOT found and is required to build DREAM3D. Please build or install it first before trying to build the rest of the SDK")
endif()



# We need this for the next command
include(ExternalProject)

# Now look for the DREAM3D_SDK variable that is set on newer versions of DREAM3D. If we
# find that variable is set to something then we are going to use that directory to 
# install everything into.
if("${DREAM3D_SDK}" STREQUAL "")
	set(DREAM3D_SDK ${Dream3DSdkBuild_BINARY_DIR}/DREAM3D_SDK)
	set(DREAM3D_SDK_INSTALL ${Dream3DSdkBuild_BINARY_DIR}/DREAM3D_SDK)
	set(DREAM3D_SDK_FILE ${DREAM3D_SDK_INSTALL}/DREAM3D_SDK.cmake)
else()
	set(DREAM3D_SDK_INSTALL ${DREAM3D_SDK})
	set(DREAM3D_SDK_FILE ${DREAM3D_SDK}/DREAM3D_SDK.cmake)
endif()

message(STATUS "DREAM3D_SDK: ${DREAM3D_SDK}")
message(STATUS "DREAM3D_SDK_INSTALL: ${DREAM3D_SDK_INSTALL}")
message(STATUS "DREAM3D_SDK_FILE: ${DREAM3D_SDK_FILE}")

if(PARALLEL_BUILD STREQUAL "")
	set(PARALLEL_BUILD 4)
endif()

set(BUILD_SHARED_LIBS ON)

# We need this for the next command
include(ExternalProject)


FILE(WRITE ${DREAM3D_SDK_FILE} "# This file was automatically generated from DREAM3D SuperBuild\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(BUILD_SHARED_LIBS ON CACHE BOOL \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_SDK_ROOT \"${DREAM3D_SDK}\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_DATA_DIR \${DREAM3D_SDK_ROOT}/DREAM3D_Data CACHE PATH \"\")\n")


include(TBB.cmake)
include(DOxygen.cmake)
include(HDF5.cmake)
include(Eigen.cmake)
include(ITK.cmake)

include(Boost.cmake)
#include(Qwt.cmake)

#


