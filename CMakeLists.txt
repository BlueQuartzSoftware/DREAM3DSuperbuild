
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

#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
function(CloneRepo)
  set(options )
  set(oneValueArgs PROJECT_NAME GIT_REPOSITORY TMP_DIR STAMP_DIR DOWNLOAD_DIR SOURCE_DIR BINARY_DIR INSTALL_DIR)
  set(multiValueArgs )
  cmake_parse_arguments(Z "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  set(projectName ${Z_PROJECT_NAME})
  message(STATUS "Cloning ${projectName}" )

  set(SOURCE_DIR "${Z_WORKSPACE_DIR}")

  set_property(DIRECTORY PROPERTY EP_BASE ${SOURCE_DIR}/${projectName})

  ExternalProject_Add(${projectName}

    TMP_DIR      ${Z_TMP_DIR}
    STAMP_DIR    ${Z_STAMP_DIR}
    DOWNLOAD_DIR ${Z_DOWNLOAD_DIR}
    SOURCE_DIR   ${Z_SOURCE_DIR}
    BINARY_DIR   ${Z_BINARY_DIR}
    INSTALL_DIR  ${Z_INSTALL_DIR}

    GIT_PROGRESS 1
    GIT_REPOSITORY "${Z_GIT_REPOSITORY}"
    GIT_TAG develop

    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    TEST_COMMAND ""

    
    LOG_DOWNLOAD 1
    LOG_UPDATE 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_TEST 1
    LOG_INSTALL 1
  )

endfunction()

set(WORKSPACE_DIR ${DREAM3DSuperBuild_SOURCE_DIR}/..)

set(projectName CMP)
CloneRepo(PROJECT_NAME ${projectName}
          GIT_REPOSITORY http://www.github.com/bluequartzsoftware/${projectName}
          TMP_DIR      ${WORKSPACE_DIR}/_superbuild/${projectName}/tmp
          STAMP_DIR    ${WORKSPACE_DIR}/_superbuild/${projectName}/stamp
          DOWNLOAD_DIR ${WORKSPACE_DIR}/_superbuild/${projectName}/download
          SOURCE_DIR   ${WORKSPACE_DIR}/${projectName}
          BINARY_DIR   ${WORKSPACE_DIR}/_superbuild/${projectName}/Binary
          INSTALL_DIR  ${WORKSPACE_DIR}/_superbuild/${projectName}/Install)

set(projectName SIMPL)
CloneRepo(PROJECT_NAME ${projectName}
          GIT_REPOSITORY http://www.github.com/bluequartzsoftware/${projectName}
          TMP_DIR      ${WORKSPACE_DIR}/_superbuild/${projectName}/tmp
          STAMP_DIR    ${WORKSPACE_DIR}/_superbuild/${projectName}/stamp
          DOWNLOAD_DIR ${WORKSPACE_DIR}/_superbuild/${projectName}/download
          SOURCE_DIR   ${WORKSPACE_DIR}/${projectName}
          BINARY_DIR   ${WORKSPACE_DIR}/_superbuild/${projectName}/Binary
          INSTALL_DIR  ${WORKSPACE_DIR}/_superbuild/${projectName}/Install)

set(projectName SIMPLView)
CloneRepo(PROJECT_NAME ${projectName}
          GIT_REPOSITORY http://www.github.com/bluequartzsoftware/${projectName}
          TMP_DIR      ${WORKSPACE_DIR}/_superbuild/${projectName}/tmp
          STAMP_DIR    ${WORKSPACE_DIR}/_superbuild/${projectName}/stamp
          DOWNLOAD_DIR ${WORKSPACE_DIR}/_superbuild/${projectName}/download
          SOURCE_DIR   ${WORKSPACE_DIR}/${projectName}
          BINARY_DIR   ${WORKSPACE_DIR}/_superbuild/${projectName}/Binary
          INSTALL_DIR  ${WORKSPACE_DIR}/_superbuild/${projectName}/Install)

set(projectName ITKImageProcessing) 
CloneRepo(PROJECT_NAME ${projectName}
          GIT_REPOSITORY http://www.github.com/bluequartzsoftware/${projectName}
          TMP_DIR      ${WORKSPACE_DIR}/_superbuild/${projectName}/tmp
          STAMP_DIR    ${WORKSPACE_DIR}/_superbuild/${projectName}/stamp
          DOWNLOAD_DIR ${WORKSPACE_DIR}/_superbuild/${projectName}/download
          SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D_Plugins/${projectName}
          BINARY_DIR   ${WORKSPACE_DIR}/_superbuild/${projectName}/Binary
          INSTALL_DIR  ${WORKSPACE_DIR}/_superbuild/${projectName}/Install)

set(d3dPlugins Anisotropy DDDAnalysisToolbox FiberToolbox HEDMAnalysis ImageProcessing MASSIFUtilities TransformationPhase UCSBUtilities DREAM3DReview)
foreach(plugin ${d3dPlugins})
  CloneRepo(PROJECT_NAME ${plugin}
          GIT_REPOSITORY http://www.github.com/dream3d/${plugin}
          TMP_DIR      ${WORKSPACE_DIR}/_superbuild/${plugin}/tmp
          STAMP_DIR    ${WORKSPACE_DIR}/_superbuild/${plugin}/stamp
          DOWNLOAD_DIR ${WORKSPACE_DIR}/_superbuild/${plugin}/download
          SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D_Plugins/${plugin}
          BINARY_DIR   ${WORKSPACE_DIR}/_superbuild/${plugin}/Binary
          INSTALL_DIR  ${WORKSPACE_DIR}/_superbuild/${projectName}/Install)
endforeach()


include(Build_DREAM3D)


file(READ ${CMAKE_CURRENT_SOURCE_DIR}/cmake/DREAM3D_SDK_PluginList.txt DREAM3D_PLUGIN_CODE)
file(APPEND ${DREAM3D_SDK_FILE} ${DREAM3D_PLUGIN_CODE})

