
set(extProjectName "qwt")
set(qwt_VERSION "6.1.3")

message(STATUS "External Project: ${extProjectName}: ${qwt_VERSION}" )

#set(qwt_url "http://pilotfiber.dl.sourceforge.net/project/qwt/qwt/${qwt_VERSION}/${extProjectName}-${qwt_VERSION}.zip")
set(qwt_url "http://dream3d.bluequartz.net/binaries/SDK/Sources/Qwt/qwt-${qwt_VERSION}.tar.bz2")

set(qwt_INSTALL "${DREAM3D_SDK}/${extProjectName}-${qwt_VERSION}-${qt5_version_full}")

set(qwtConfig_FILE "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/qwtconfig.pri")
set(qwtSrcPro_FILE "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/src.pro")
set(COMMENT "")
if(NOT APPLE)
  set(COMMENT "#")
endif()

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

configure_file(
  "${_self_dir}/patches/qwt/qwtconfig.pri.in"
  "${qwtConfig_FILE}"
  @ONLY
)

configure_file(
  "${_self_dir}/patches/qwt/src/src.pro.in"
  "${qwtSrcPro_FILE}"
  @ONLY
)

set(qwt_ParallelBuild "")
if(WIN32)
  set(qwt_BUILD_COMMAND "nmake")
else()
  set(qwt_BUILD_COMMAND "/usr/bin/make")
  set(qwt_ParallelBuild "-j${CoreCount}")
endif()

ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME ${extProjectName}-${qwt_VERSION}.zip
  URL ${qwt_url}
  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}-${qwt_VERSION}"
  #BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${qwt_INSTALL}"

  CONFIGURE_COMMAND ${QMAKE_EXECUTABLE} qwt.pro
  PATCH_COMMAND ${CMAKE_COMMAND} -E copy ${qwtConfig_FILE} <SOURCE_DIR>/qwtconfig.pri
                COMMAND ${CMAKE_COMMAND} -E copy ${qwtSrcPro_FILE} <SOURCE_DIR>/src/src.pro
  BUILD_COMMAND ${qwt_BUILD_COMMAND} ${qwt_ParallelBuild}
  INSTALL_COMMAND ${qwt_BUILD_COMMAND} install

  BUILD_IN_SOURCE 1
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
FILE(APPEND ${DREAM3D_SDK_FILE} "# Qwt ${qwt_VERSION} Library\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(QWT_INSTALL \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${qwt_VERSION}-${qt5_version_full}\" CACHE PATH \"\")\n")







