#--------------------------------------------------------------------------------------------------
# Are we using DREAM3DData (ON by default)
#--------------------------------------------------------------------------------------------------
option(USE_DREAM3DDATA "Use DREAM3D Data" ON)
if("${USE_DREAM3DDATA}" STREQUAL "OFF")
  return()
endif()

set(extProjectName "DREAM3D_Data")
message(STATUS "Using: ${extProjectName}: -DUSE_DREAM3DDATA=${USE_DREAM3DDATA}")

if(NOT DEFINED DREAM3D_DATA_DIR)
  set(DATA_ROOT "${DREAM3D_SDK}")
  set(DATA_TEMP "superbuild")
  if(NOT "${DREAM3D_WORKSPACE}" STREQUAL "")
    set(DATA_ROOT ${DREAM3D_WORKSPACE})
    set(DATA_TEMP "Temp")
  endif()

  set(DREAM3D_DATA_DIR ${DATA_ROOT}/DREAM3D_Data)

  ExternalProject_Add(${extProjectName}
    TMP_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
    STAMP_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
    DOWNLOAD_DIR ${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Download
    SOURCE_DIR ${DATA_ROOT}/${extProjectName}
    BINARY_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
    INSTALL_DIR "${DATA_ROOT}/${extProjectName}"

    GIT_PROGRESS 1
    GIT_REPOSITORY "https://www.github.com/dream3d/DREAM3D_Data"
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

  ExternalProject_Add(${extProjectName}_SMALLIN100
    DEPENDS ${extProjectName}
    URL ${DATA_ROOT}/${extProjectName}/Data/SmallIN100.tar.gz
    URL_MD5 815f774a82142bfc3633d14a5759ef58
    SOURCE_DIR   ${DATA_ROOT}/${extProjectName}/Data/SmallIN100

    TMP_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
    STAMP_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
    DOWNLOAD_DIR ${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Download
    BINARY_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
    INSTALL_DIR "${DATA_ROOT}/${extProjectName}"

    #DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    TEST_COMMAND ""
  )

  ExternalProject_Add(${extProjectName}_IMAGE
    DEPENDS ${extProjectName}
    URL ${DATA_ROOT}/${extProjectName}/Data/Image.tar.gz
    URL_MD5 171a9d4396058775f9c9495916584928
    SOURCE_DIR   ${DATA_ROOT}/${extProjectName}/Data/Image

    TMP_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
    STAMP_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
    DOWNLOAD_DIR ${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Download
    BINARY_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
    INSTALL_DIR "${DATA_ROOT}/${extProjectName}"
      
    #DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    TEST_COMMAND ""
  )

  ExternalProject_Add(${extProjectName}_T12_MAI_2020
    DEPENDS ${extProjectName}
    URL ${DATA_ROOT}/${extProjectName}/Data/T12-MAI-2010.tar.gz
    URL_MD5 3c174a686bf5f5f025e19c6ca97df907
    SOURCE_DIR   ${DATA_ROOT}/${extProjectName}/Data/T12-MAI-2010

    TMP_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
    STAMP_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
    DOWNLOAD_DIR ${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Download
    BINARY_DIR "${DATA_ROOT}/${DATA_TEMP}/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
    INSTALL_DIR "${DATA_ROOT}/${extProjectName}"
      
    #DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    TEST_COMMAND ""
  )
else()
  message(STATUS "Using Installed DREAM3D_Data: -DDREAM3D_DATA_DIR=${DREAM3D_DATA_DIR}")
endif()

file(APPEND ${DREAM3D_SDK_FILE} "\n")
file(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
file(APPEND ${DREAM3D_SDK_FILE} "# DREAM3D Data Folder Location\n")
file(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_DATA_DIR \"${DREAM3D_DATA_DIR}\" CACHE PATH \"\")\n")
