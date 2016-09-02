set(extProjectName "protobuf")
message(STATUS "External Project: ${extProjectName}" )

set(ProtoBuf_VERSION "2.6.1")

set(ProtoBuf_INSTALL "${DREAM3D_SDK}/protocol_buffers_${ProtoBuf_VERSION}")
#set(ProtoBuf_URL "https://github.com/google/protobuf/releases/download/v${ProtoBuf_VERSION}/protobuf-${ProtoBuf_VERSION}.tar.gz")
set(ProtoBuf_URL "http://dream3d.bluequartz.net/binaries/SDK/Sources/ProtocolBuffers/protobuf-${ProtoBuf_VERSION}.tar.gz")


set(ProtoBuf_REPOSITORY "https://github.com/google/protobuf")
set(ProtoBuf_GIT_TAG "${ProtoBuf_VERSION}")

if(WIN32)
  message(STATUS "Windows Developers should install a prebuilt Protocol Buffers for their system.")
endif()
#https://github-cloud.s3.amazonaws.com/releases/23357588/0a2433bc-5a29-11e4-8e74-fbea8721fcc7.gz?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAISTNZFOVBIJMK3TQ%2F20160831%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20160831T201223Z&X-Amz-Expires=300&X-Amz-Signature=f9e6ab8aa3c43581ffe5b780d809d68eccd7f8aebf2020f93678ffa492b1b965&X-Amz-SignedHeaders=host&actor_id=5182396&response-content-disposition=attachment%3B%20filename%3Dprotobuf-2.6.1.tar.gz&response-content-type=application%2Foctet-stream


set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)

ExternalProject_Add(${extProjectName}
  #GIT_REPOSITORY "${ProtoBuf_REPOSITORY}"
  #GIT_TAG "v${ProtoBuf_GIT_TAG}"
  DOWNLOAD_NAME ${extProjectName}-${ProtoBuf_VERSION}.tar.gz
  URL ${ProtoBuf_URL}
  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"
  #BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${ProtoBuf_INSTALL}"
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR>
  BUILD_COMMAND make -j${CoreCount}
  
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
FILE(APPEND ${DREAM3D_SDK_FILE} "# Protocol Buffers For TCP/IP network message handling\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(Protobuf_DIR \"\${DREAM3D_SDK_ROOT}/protocol_buffers_${ProtoBuf_VERSION}\" CACHE PATH \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${Protobuf_DIR})\n")

