set(extProjectName "DREAM3DData")
message(STATUS "External Project: ${extProjectName}" )

set(url "http://dream3d.bluequartz.net/binaries/SDK/DREAM3D_Data.tar.gz")


ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME ${extProjectName}.tar.gz
  URL ${url}
  DOWNLOAD_DIR "${DREAM3D_SDK}"
  SOURCE_DIR "${DREAM3D_SDK}/DREAM3D_Data"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)

FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_DATA_DIR \"\${DREAM3D_SDK_ROOT}/DREAM3D_Data\" CACHE PATH \"\")\n")
