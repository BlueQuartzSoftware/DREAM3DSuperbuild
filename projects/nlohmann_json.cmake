#--------------------------------------------------------------------------------------------------
# Are we building NLohmann JSON (ON by default)
#--------------------------------------------------------------------------------------------------
option(BUILD_NLOHMANN_JSON "Build NLohmann JSON" ON)
if(NOT BUILD_NLOHMANN_JSON)
  return()
endif()

set(extProjectName "nlohmann_json")
set(nlohmann_json_GIT_TAG "v3.9.1")
set(nlohmann_json_VERSION "3.9.1")
message(STATUS "Building: ${extProjectName} ${nlohmann_json_VERSION}:  nlohmann_json required")

set(nlohmann_json_INSTALL "${DREAM3D_SDK}/${extProjectName}-${nlohmann_json_VERSION}")

ExternalProject_Add(${extProjectName}
  GIT_REPOSITORY "https://github.com/nlohmann/json/"
  GIT_PROGRESS 1
  GIT_TAG ${nlohmann_json_GIT_TAG}

  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}/Download
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source"
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${nlohmann_json_INSTALL}"

  CMAKE_ARGS
    -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD_REQUIRED=ON
    -Wno-dev
    -DJSON_BuildTests=OFF

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
file(APPEND ${DREAM3D_SDK_FILE} "# nlohmann_json\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(nlohmann_json_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${nlohmann_json_VERSION}/lib/cmake/${extProjectName}\" CACHE PATH \"\")\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${nlohmann_json_DIR})\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(nlohmann_json_VERSION \"${nlohmann_json_VERSION}\" CACHE STRING \"\")\n")
