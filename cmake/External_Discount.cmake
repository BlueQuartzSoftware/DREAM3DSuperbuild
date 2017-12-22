set(extProjectName "discount")
set(discount_VERSION "2.2.3")

message(STATUS "External Project: ${extProjectName}" )

if(WIN32)
  set(discount_INSTALL "${DREAM3D_SDK}/${extProjectName}-${discount_VERSION}")
else()
  set(discount_INSTALL "${DREAM3D_SDK}/${extProjectName}-${discount_VERSION}-${CMAKE_BUILD_TYPE}")
endif()

ExternalProject_Add(${extProjectName}
  GIT_REPOSITORY "git://github.com/BlueQuartzSoftware/discount.git"
  GIT_PROGRESS 1
  #GIT_TAG master

  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}/Download
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source"
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${discount_INSTALL}"

  #UPDATE_COMMAND "${GIT_EXECUTABLE} pull --rebase origin master"
  PATCH_COMMAND ""

  CMAKE_ARGS -DCMAKE_BUILD_TYPE=${BUILD_TYPE}

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
FILE(APPEND ${DREAM3D_SDK_FILE} "set(discount_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${discount_VERSION}-\${CMAKE_BUILD_TYPE}/lib/cmake/${extProjectName}\" CACHE PATH \"\")\n")




