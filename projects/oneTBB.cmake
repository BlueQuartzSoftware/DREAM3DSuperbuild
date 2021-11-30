#--------------------------------------------------------------------------------------------------
# Are we building oneTBB (ON by default)
#--------------------------------------------------------------------------------------------------
option(BUILD_oneTBB "Build oneTBB" ON)
if(NOT BUILD_oneTBB)
  return()
endif()

set(extProjectName "oneTBB")
set(oneTBB_GIT_TAG "v2021.4.0")
set(oneTBB_VERSION "2021.4.0")
message(STATUS "Building: ${extProjectName} ${oneTBB_VERSION}: -DBUILD_oneTBB=${BUILD_oneTBB}")

set(oneTBB_INSTALL "${NX_SDK}/${extProjectName}-${oneTBB_VERSION}-${CMAKE_BUILD_TYPE}")

if(DREAM3D_USE_CUSTOM_DOWNLOAD_SITE)
  set(EP_SOURCE_ARGS  
    DOWNLOAD_NAME ${extProjectName}-${oneTBB_VERSION}.zip
    URL ${DREAM3D_CUSTOM_DOWNLOAD_URL_PREFIX}${extProjectName}-${oneTBB_VERSION}.zip
  )
else()
  set(EP_SOURCE_ARGS  
    GIT_REPOSITORY "https://github.com/oneapi-src/onetbb"
    GIT_PROGRESS 1
    GIT_TAG ${oneTBB_GIT_TAG}
  )
endif()


ExternalProject_Add(${extProjectName}
  ${EP_SOURCE_ARGS}

  TMP_DIR "${NX_SDK}/superbuild/${extProjectName}-${oneTBB_VERSION}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${NX_SDK}/superbuild/${extProjectName}-${oneTBB_VERSION}/Stamp"
  DOWNLOAD_DIR ${NX_SDK}/superbuild/${extProjectName}-${oneTBB_VERSION}/Download
  SOURCE_DIR "${NX_SDK}/superbuild/${extProjectName}-${oneTBB_VERSION}/Source"
  BINARY_DIR "${NX_SDK}/superbuild/${extProjectName}-${oneTBB_VERSION}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${oneTBB_INSTALL}"

  CMAKE_ARGS
    -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD_REQUIRED=ON


  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)

#-- Append this information to the NX_SDK CMake file that helps other developers
#-- configure DREAM3D for building
file(APPEND ${NX_SDK_FILE} "\n")
file(APPEND ${NX_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
file(APPEND ${NX_SDK_FILE} "# oneTBB\n")
file(APPEND ${NX_SDK_FILE} "set(TBB_DIR \"\${NX_SDK_ROOT}/${extProjectName}-${oneTBB_VERSION}-\${BUILD_TYPE}/lib/cmake/TBB\" CACHE PATH \"\")\n")
file(APPEND ${NX_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${TBB_DIR})\n")
file(APPEND ${NX_SDK_FILE} "set(TBB_VERSION \"${oneTBB_VERSION}\" CACHE STRING \"\")\n")
