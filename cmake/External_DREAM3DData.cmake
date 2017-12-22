set(extProjectName "DREAM3D_Data")
message(STATUS "External Project: ${extProjectName}" )

#set(dream3d_data_url "http://dream3d.bluequartz.net/binaries/SDK/DREAM3D_Data.tar.gz")


ExternalProject_Add(${extProjectName}
  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}/Download
  SOURCE_DIR   ${DREAM3D_SDK}/${extProjectName}
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}"

  GIT_PROGRESS 1
  GIT_REPOSITORY "http://www.github.com/dream3d/DREAM3D_Data"
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

if(EXISTS ${DREAM3D_SDK}/${extProjectName}/Data/SmallIN100.tar.gz)

    ExternalProject_Add(${extProjectName}_SMALLIN100
        DEPENDS ${extProjectName}
        URL ${DREAM3D_SDK}/${extProjectName}/Data/SmallIN100.tar.gz
        URL_MD5 815f774a82142bfc3633d14a5759ef58
        SOURCE_DIR   ${DREAM3D_SDK}/${extProjectName}/Data/SmallIN100

        TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
        STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
        DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}/Download
        BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
        INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}"

        #DOWNLOAD_COMMAND ""
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        TEST_COMMAND ""
    )

endif()

if(EXISTS ${DREAM3D_SDK}/${extProjectName}/Data/Image.tar.gz)

  ExternalProject_Add(${extProjectName}_IMAGE
      DEPENDS ${extProjectName}
      URL ${DREAM3D_SDK}/${extProjectName}/Data/Image.tar.gz
      URL_MD5 171a9d4396058775f9c9495916584928
      SOURCE_DIR   ${DREAM3D_SDK}/${extProjectName}/Data/Image

      TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
      STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
      DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}/Download
      BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
      INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}"
        
      #DOWNLOAD_COMMAND ""
      UPDATE_COMMAND ""
      PATCH_COMMAND ""
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
      TEST_COMMAND ""
  )
endif()


FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# DREAM3D Data Folder Location\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_DATA_DIR \"\${DREAM3D_SDK_ROOT}/DREAM3D_Data\" CACHE PATH \"\")\n")
