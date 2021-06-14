#--------------------------------------------------------------------------------------------------
# Are we building Pybind11 (ON by default)
#--------------------------------------------------------------------------------------------------
option(BUILD_PYBIND11 "Build Pybind11" ON)
if(NOT BUILD_PYBIND11)
  return()
endif()

set(extProjectName "pybind11")
set(pybind11_GIT_TAG "v2.6.2")
set(pybind11_VERSION "2.6.2")
message(STATUS "Building: ${extProjectName} ${pybind11_VERSION}: -DBUILD_PYBIND11=${BUILD_PYBIND11}" )

set(pybind11_INSTALL "${DREAM3D_SDK}/${extProjectName}-${pybind11_VERSION}")

if(DREAM3D_USE_CUSTOM_DOWNLOAD_SITE)
  set(EP_SOURCE_ARGS  
    DOWNLOAD_NAME ${extProjectName}-${pybind11_VERSION}.tar.gz
    URL ${DREAM3D_CUSTOM_DOWNLOAD_URL_PREFIX}${extProjectName}-${pybind11_VERSION}.tar.gz
  )
else()
  set(EP_SOURCE_ARGS  
  GIT_REPOSITORY "https://github.com/pybind/pybind11.git"
  GIT_PROGRESS 1
  GIT_TAG ${pybind11_GIT_TAG}
  )
endif()


ExternalProject_Add(${extProjectName}
  ${EP_SOURCE_ARGS}

  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}-${pybind11_VERSION}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}-${pybind11_VERSION}/Stamp"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}-${pybind11_VERSION}/Download
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}-${pybind11_VERSION}/Source"
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}-${pybind11_VERSION}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${pybind11_INSTALL}"

  CMAKE_ARGS
    -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD=11
    -DCMAKE_CXX_STANDARD_REQUIRED=ON
    -Wno-dev
    -DPYBIND11_TEST=OFF

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
file(APPEND ${DREAM3D_SDK_FILE} "# pybind11\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(pybind11_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${pybind11_VERSION}/share/cmake/${extProjectName}\" CACHE PATH \"\")\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${pybind11_DIR})\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(pybind11_VERSION \"${pybind11_VERSION}\" CACHE STRING \"\")\n")
