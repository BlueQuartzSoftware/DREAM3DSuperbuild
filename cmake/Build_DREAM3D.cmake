
set(extProjectName "DREAM3D")
message(STATUS "Configuring DREAM.3D" )

set(DREAM3D_VERSION "")
#set(DREAM3D_URL "https://bitbucket.org/DREAM3D/DREAM3D/get/${DREAM3D_VERSION}.tar.gz")
set(DREAM3D_URL "http://dream3d.bluequartz.net/binaries/SDK/Sources/DREAM3D/DREAM3D-${DREAM3D_VERSION}.tar.gz")
set(SOURCE_DIR "${DREAM3DSuperBuild_SOURCE_DIR}/..")
set(SOURCE_DIR "/tmp/Workspace")

set_property(DIRECTORY PROPERTY EP_BASE ${SOURCE_DIR}/DREAM3D)

ExternalProject_Add(${extProjectName}
  DEPENDS   CMP SIMPL SIMPLView ITKImageProcessing ${d3dPlugins} DOxygen DREAM3D_Data Eigen hdf5 ITK Qt5 qwt tbb
  TMP_DIR      ${SOURCE_DIR}/_superbuild/${extProjectName}/tmp
  STAMP_DIR    ${SOURCE_DIR}/_superbuild/${extProjectName}/stamp
  DOWNLOAD_DIR ${SOURCE_DIR}/_superbuild/${extProjectName}/download
  SOURCE_DIR   ${SOURCE_DIR}/${extProjectName}
  BINARY_DIR   ${SOURCE_DIR}/${extProjectName}-Build/${BUILD_TYPE}
  INSTALL_DIR  ${SOURCE_DIR}/_superbuild/${extProjectName}

  GIT_PROGRESS 1
  GIT_REPOSITORY "http://www.github.com/bluequartzsoftware/DREAM3D"
  GIT_TAG develop

  # BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${BUILD_TYPE}"
  # INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${DREAM3D_VERSION}"

  CMAKE_ARGS
    -DDREAM3D_SDK:PATH=${DREAM3D_SDK}
    -DCMAKE_BUILD_TYPE:STRING=${BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>

  #   -DCMAKE_CXX_FLAGS=${DREAM3D_CXX_FLAGS}
  #   -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
  #   -DCMAKE_OSX_SYSROOT=${OSX_SDK}
  #   -DCMAKE_CXX_STANDARD=11 
  #   -DCMAKE_CXX_STANDARD_REQUIRED=ON
  #   -Wno-dev
  #   -DQT_QMAKE_EXECUTABLE=
  #   -DBUILD_SHARED_LIBS=OFF 
  #   -DBUILD_TESTING=OFF 

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)



