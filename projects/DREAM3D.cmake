#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
function(CloneRepo)
  set(options )
  set(oneValueArgs DEPENDS PROJECT_NAME GIT_REPOSITORY TMP_DIR STAMP_DIR DOWNLOAD_DIR SOURCE_DIR BINARY_DIR INSTALL_DIR)
  set(multiValueArgs )
  cmake_parse_arguments(Z "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  set(projectName ${Z_PROJECT_NAME})
  message(STATUS "Cloning ${projectName}" )

  set(SOURCE_DIR "${Z_WORKSPACE_DIR}")

  # set_property(DIRECTORY PROPERTY EP_BASE ${SOURCE_DIR}/${projectName})

  ExternalProject_Add(${projectName}
    DEPENDS      ${Z_DEPENDS}
    TMP_DIR      ${Z_TMP_DIR}
    STAMP_DIR    ${Z_STAMP_DIR}
    DOWNLOAD_DIR ${Z_DOWNLOAD_DIR}
    SOURCE_DIR   ${Z_SOURCE_DIR}
    BINARY_DIR   ${Z_BINARY_DIR}
    INSTALL_DIR  ${Z_INSTALL_DIR}

    GIT_PROGRESS 1
    GIT_REPOSITORY "${Z_GIT_REPOSITORY}"
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

endfunction()


set(CLONE_REPOS 1)
if("${WORKSPACE_DIR}" STREQUAL "")
  message(FATAL_ERROR "WORKSPACE_DIR is empty. Cloning and building DREAM.3D can not continue. \
    Please set the WORKSPACE_DIR to the directory where you want to clone all the DREAM3D \
    repositories. Anything in that directory may be over written.")
endif()
if(CLONE_REPOS)
  message(STATUS "Workspace Folder:   ${WORKSPACE_DIR}")
  message(STATUS "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
  message(STATUS "The directory ${WORKSPACE_DIR}/DREAM3D")
  message(STATUS "WILL be over written with a fresh checkout. If you have any unsaved")
  message(STATUS "or commits that need to be pushed. DO THAT BEFORE starting the")
  message(STATUS "build process.")
  message(STATUS "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
endif()

set(d3dPlugins Anisotropy DDDAnalysisToolbox FiberToolbox HEDMAnalysis ImageProcessing MASSIFUtilities TransformationPhase UCSBUtilities DREAM3DReview)


if(CLONE_REPOS)

  set(projectName DREAM3D)
  CloneRepo(PROJECT_NAME ${projectName}
            GIT_REPOSITORY http://www.github.com/bluequartzsoftware/${projectName}
            TMP_DIR      ${DREAM3D_SDK}/superbuild/${projectName}/tmp
            STAMP_DIR    ${DREAM3D_SDK}/superbuild/${projectName}/stamp
            DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${projectName}/download
            SOURCE_DIR   ${WORKSPACE_DIR}/${projectName}
            BINARY_DIR   ${DREAM3D_SDK}/superbuild/${projectName}/Binary
            INSTALL_DIR  ${DREAM3D_SDK}/superbuild/${projectName}/Install)

  set(projectName CMP)
  CloneRepo(PROJECT_NAME ${projectName}
            DEPENDS DREAM3D
            GIT_REPOSITORY http://www.github.com/bluequartzsoftware/${projectName}
            TMP_DIR      ${DREAM3D_SDK}/superbuild/${projectName}/tmp
            STAMP_DIR    ${DREAM3D_SDK}/superbuild/${projectName}/stamp
            DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${projectName}/download
            SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D/ExternalProjects/${projectName}
            BINARY_DIR   ${DREAM3D_SDK}/superbuild/${projectName}/Binary
            INSTALL_DIR  ${DREAM3D_SDK}/superbuild/${projectName}/Install)

  set(projectName SIMPL)
  CloneRepo(PROJECT_NAME ${projectName}
            DEPENDS DREAM3D
            GIT_REPOSITORY http://www.github.com/bluequartzsoftware/${projectName}
            TMP_DIR      ${DREAM3D_SDK}/superbuild/${projectName}/tmp
            STAMP_DIR    ${DREAM3D_SDK}/superbuild/${projectName}/stamp
            DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${projectName}/download
            SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D/ExternalProjects/${projectName}
            BINARY_DIR   ${DREAM3D_SDK}/superbuild/${projectName}/Binary
            INSTALL_DIR  ${DREAM3D_SDK}/superbuild/${projectName}/Install)

  set(projectName SIMPLView)
  CloneRepo(PROJECT_NAME ${projectName}
            DEPENDS DREAM3D
            GIT_REPOSITORY http://www.github.com/bluequartzsoftware/${projectName}
            TMP_DIR      ${DREAM3D_SDK}/superbuild/${projectName}/tmp
            STAMP_DIR    ${DREAM3D_SDK}/superbuild/${projectName}/stamp
            DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${projectName}/download
            SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D/ExternalProjects/${projectName}
            BINARY_DIR   ${DREAM3D_SDK}/superbuild/${projectName}/Binary
            INSTALL_DIR  ${DREAM3D_SDK}/superbuild/${projectName}/Install)

  set(projectName ITKImageProcessing) 
  CloneRepo(PROJECT_NAME ${projectName}
            DEPENDS DREAM3D ITK
            GIT_REPOSITORY http://www.github.com/bluequartzsoftware/${projectName}
            TMP_DIR      ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${projectName}/tmp
            STAMP_DIR    ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${projectName}/stamp
            DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${projectName}/download
            SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D/ExternalProjects/Plugins/${projectName}
            BINARY_DIR   ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${projectName}/Binary
            INSTALL_DIR  ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${projectName}/Install)

  foreach(plugin ${d3dPlugins})
    CloneRepo(PROJECT_NAME ${plugin}
            DEPENDS DREAM3D
            GIT_REPOSITORY http://www.github.com/dream3d/${plugin}
            TMP_DIR      ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${plugin}/tmp
            STAMP_DIR    ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${plugin}/stamp
            DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${plugin}/download
            SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D/ExternalProjects/Plugins/${plugin}
            BINARY_DIR   ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${plugin}/Binary
            INSTALL_DIR  ${DREAM3D_SDK}/superbuild/DREAM3D_Plugins/${plugin}/Install)
  endforeach()

endif()

#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
set(extProjectName "DREAM3DProj")
message(STATUS "Configuring DREAM.3D" )

set(DREAM3D_VERSION "")

if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
  else()
    set(CXX_FLAGS "-std=c++11")
  endif()
endif()

set(DREAM3D_REPO_DEPENDENCIES "")
foreach(plugin ${d3dPlugins} DREAM3D CMP SIMPL SIMPLView ITKImageProcessing )
  list(APPEND DREAM3D_REPO_DEPENDENCIES ${plugin})
endforeach()

ExternalProject_Add(${extProjectName}
  DEPENDS     discount Eigen hdf5 ITK Qt5 qwt ITK DREAM3D_Data ${DREAM3D_REPO_DEPENDENCIES}
  TMP_DIR      ${DREAM3D_SDK}/superbuild/${extProjectName}/tmp
  STAMP_DIR    ${DREAM3D_SDK}/superbuild/${extProjectName}/stamp-${BUILD_TYPE}
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}/download
  SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D
  BINARY_DIR   ${WORKSPACE_DIR}/DREAM3D-Build/${BUILD_TYPE}
  INSTALL_DIR  ${WORKSPACE_DIR}/DREAM3D-Install/

  DOWNLOAD_COMMAND ""
  UPDATE_COMMAND "" 
  PATCH_COMMAND "" 
  # CONFIGURE_COMMAND "" 
  # BUILD_COMMAND "" 
  # INSTALL_COMMAND ""
  TEST_COMMAND ""

  #GIT_PROGRESS 1
  #GIT_REPOSITORY "http://www.github.com/bluequartzsoftware/DREAM3D"
  #GIT_TAG develop

  CMAKE_ARGS
    -DDREAM3D_SDK:PATH=${DREAM3D_SDK}
    -DCMAKE_BUILD_TYPE:STRING=${BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=${WORKSPACE_DIR}/${extProjectName}-Install
    -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
    -DSIMPL_DISCOUNT_DOCUMENTATION:BOOL=ON
    -DSIMPL_DOXYGEN_DOCUMENTATION:BOOL=OFF
    -DSIMPL_GENERATE_HTML:BOOL=OFF
    
  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)
