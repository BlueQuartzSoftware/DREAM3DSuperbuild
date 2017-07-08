
set(extProjectName "DREAM3D")
message(STATUS "Configuring DREAM.3D" )

set(DREAM3D_VERSION "")
set(SOURCE_DIR "${WORKSPACE_DIR}")

set_property(DIRECTORY PROPERTY EP_BASE ${SOURCE_DIR}/DREAM3D)

if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
elseif(APPLE)
  set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
  else()
    set(CXX_FLAGS "-std=c++11")
  endif()
endif()

ExternalProject_Add(${extProjectName}
  DEPENDS      DOxygen Eigen hdf5 ITK Qt5 qwt tbb CMP SIMPL SIMPLView DREAM3D_Data ITKImageProcessing ${d3dPlugins} 
  TMP_DIR      ${SOURCE_DIR}/_superbuild/${extProjectName}/tmp
  STAMP_DIR    ${SOURCE_DIR}/_superbuild/${extProjectName}/stamp-${BUILD_TYPE}
  DOWNLOAD_DIR ${SOURCE_DIR}/_superbuild/${extProjectName}/download
  SOURCE_DIR   ${SOURCE_DIR}/${extProjectName}
  BINARY_DIR   ${SOURCE_DIR}/${extProjectName}-Build/${BUILD_TYPE}
  INSTALL_DIR  ${SOURCE_DIR}/Install/${extProjectName}

  GIT_PROGRESS 1
  GIT_REPOSITORY "http://www.github.com/bluequartzsoftware/DREAM3D"
  GIT_TAG develop

  CMAKE_ARGS
    -DDREAM3D_SDK:PATH=${DREAM3D_SDK}
    -DCMAKE_BUILD_TYPE:STRING=${BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=${SOURCE_DIR}/_superbuild/${extProjectName}

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)



