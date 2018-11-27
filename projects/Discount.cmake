set(extProjectName "discount")
set(discount_VERSION "2.2.3")

message(STATUS "External Project: ${extProjectName}: ${discount_VERSION}" )

if(WIN32)
  set(discount_INSTALL "${DREAM3D_SDK}/${extProjectName}-${discount_VERSION}")
else()
  set(discount_INSTALL "${DREAM3D_SDK}/${extProjectName}-${discount_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

ExternalProject_Add(${extProjectName}
  GIT_REPOSITORY "https://github.com/BlueQuartzSoftware/discount.git"
  GIT_PROGRESS 1
  #GIT_TAG master

  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}/Download
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source"
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${discount_INSTALL}"

  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD=11 
    -DCMAKE_CXX_STANDARD_REQUIRED=ON
    -Wno-dev
    -DBUILD_SHARED_LIBS=OFF 
    -DBUILD_TESTING=OFF 

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# Discount\n")
if(APPLE)
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(discount_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${discount_VERSION}-\${BUILD_TYPE}/lib/cmake/${extProjectName}\" CACHE PATH \"\")\n")
elseif(WIN32)
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(discount_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${discount_VERSION}/lib/cmake/${extProjectName}\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(discount_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${discount_VERSION}-\${BUILD_TYPE}/lib/cmake/${extProjectName}\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${discount_DIR})\n")
