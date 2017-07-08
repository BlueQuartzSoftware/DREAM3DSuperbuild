set(extProjectName "tbb")
message(STATUS "External Project: ${extProjectName}" )

set(tbb_VERSION "2017_20170604")

set(tbb_INSTALL "${DREAM3D_SDK}/tbb${tbb_VERSION}oss")
set(tbb_url_server "http://dream3d.bluequartz.net/binaries/SDK/Sources/TBB")
if(APPLE)
# https://github.com/01org/tbb/releases/download/2017_U7/tbb2017_20170604oss_mac.tgz
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_mac.tgz")
elseif(WIN32)
# https://github.com/01org/tbb/releases/download/2017_U7/tbb2017_20170604oss_win.zip
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_win.zip")
else()
# https://github.com/01org/tbb/releases/download/2017_U7/tbb2017_20170604oss_lin.tgz
	set(tbb_URL "${tbb_url_server}/tbb${tbb_VERSION}oss_lin.tgz")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)

#------------------------------------------------------------------------------
# Linux has TBB Compiled and installed
if(WIN32 OR APPLE OR "${BUILD_TBB}" STREQUAL "ON" )
  ExternalProject_Add(${extProjectName}
    # DOWNLOAD_NAME ${extProjectName}-${tbb_VERSION}.tar.gz
    URL ${tbb_URL}
    TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
    STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
    DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
    SOURCE_DIR "${DREAM3D_SDK}/${extProjectName}${tbb_VERSION}oss"
    BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
    INSTALL_DIR "${tbb_INSTALL}"
    CONFIGURE_COMMAND "" 
    BUILD_COMMAND "" 
    INSTALL_COMMAND ""

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
  FILE(APPEND ${DREAM3D_SDK_FILE} "# Intel Threading Building Blocks Library\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(SIMPL_USE_MULTITHREADED_ALGOS ON CACHE BOOL \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_INSTALL_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}${tbb_VERSION}oss\" CACHE PATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_ROOT \"\${DREAM3D_SDK_ROOT}/${extProjectName}${tbb_VERSION}oss\" CACHE PATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_ARCH_TYPE \"intel64\" CACHE STRING \"\")\n")

else()
  message(STATUS "LINUX: Please use your package manager to install Threading Building Blocks (TBB)")
  #------------------------------------------------------------------------------
  # Linux has an acceptable TBB installation
  FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "# Intel Threading Building Blocks Library\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(SIMPL_USE_MULTITHREADED_ALGOS ON CACHE BOOL \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_INSTALL_DIR \"/usr\" CACHE PATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_ROOT \"/usr\" CACHE PATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_ARCH_TYPE \"intel64\" CACHE STRING \"\")\n")

endif()

