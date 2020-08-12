#--------------------------------------------------------------------------------------------------
# Are we building FileSystem? Only needed on macOS systems
#--------------------------------------------------------------------------------------------------
if(WIN32)
  return()
endif()

if(CMAKE_COMPILER_IS_GNUCC AND "${CMAKE_SYSTEM_NAME}" STREQUAL "Linux" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 8.99)
  return()
endif()

set(extProjectName "ghcFilesystem")
set(ghcFilesystem_GIT_TAG "v1.3.2")
set(ghcFilesystem_VERSION "1.3.2")
message(STATUS "Building: ${extProjectName} ${ghcFilesystem_VERSION}:  ghcFilesystem required")

set(ghcFilesystem_INSTALL "${DREAM3D_SDK}/${extProjectName}-${ghcFilesystem_VERSION}-${CMAKE_BUILD_TYPE}")

ExternalProject_Add(${extProjectName}
  GIT_REPOSITORY "https://github.com/gulrak/filesystem.git"
  GIT_PROGRESS 1
  GIT_TAG ${ghcFilesystem_GIT_TAG}

  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}/Download
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source"
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${ghcFilesystem_INSTALL}"

  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD_REQUIRED=ON
    -Wno-dev

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
file(APPEND ${DREAM3D_SDK_FILE} "\n")
file(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
file(APPEND ${DREAM3D_SDK_FILE} "# GulRok FileSystem\n")
if(NOT WIN32)
  file(APPEND ${DREAM3D_SDK_FILE} "set(ghcFilesystem_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${ghcFilesystem_VERSION}-\${BUILD_TYPE}/lib/cmake/${extProjectName}\" CACHE PATH \"\")\n")
else()
    message(FATAL_ERROR "GHC FileSystem is ONLY needed on MacOS. If you are on Linux or Windows it is not needed as the std::file_system can be used instead.")
endif()
file(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${ghcFilesystem_DIR})\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(ghcFilesystem_VERSION \"${ghcFilesystem_VERSION}\" CACHE STRING \"\")\n")
