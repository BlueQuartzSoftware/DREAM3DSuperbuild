#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
function(CloneRepo)
  set(options )
  set(oneValueArgs DEPENDS PROJECT_NAME GIT_REPOSITORY TMP_DIR STAMP_DIR DOWNLOAD_DIR SOURCE_DIR BINARY_DIR INSTALL_DIR)
  set(multiValueArgs )
  cmake_parse_arguments(Z "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  set(projectName ${Z_PROJECT_NAME})
  message(STATUS "Creating External Project: ${projectName}" )

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
    Please set the -DWORKSPACE_DIR=/Path/to/Directory/of/DREAM3D to the directory where you want to clone all the DREAM3D \
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


if(CLONE_REPOS)

  foreach(plugin ${DREAM3D_Base_Repos})
    CloneRepo(PROJECT_NAME ${plugin}
          GIT_REPOSITORY https://www.github.com/bluequartzsoftware/${plugin}
          TMP_DIR      ${WORKSPACE_DIR}/Temp/${plugin}/tmp
          STAMP_DIR    ${WORKSPACE_DIR}/Temp/${plugin}/stamp
          DOWNLOAD_DIR ${WORKSPACE_DIR}/Temp/${plugin}/download
          SOURCE_DIR   ${WORKSPACE_DIR}/${plugin}
          BINARY_DIR   ${WORKSPACE_DIR}/Temp/${plugin}/Binary
          INSTALL_DIR  ${WORKSPACE_DIR}/Temp/${plugin}/Install)
  endforeach()

  foreach(plugin ${GitHub_BLUEQUARTZ_Plugins})
    CloneRepo(PROJECT_NAME ${plugin}
            GIT_REPOSITORY https://www.github.com/bluequartzsoftware/${plugin}
            TMP_DIR      ${WORKSPACE_DIR}/Temp/${plugin}/tmp
            STAMP_DIR    ${WORKSPACE_DIR}/Temp/${plugin}/stamp
            DOWNLOAD_DIR ${WORKSPACE_DIR}/Temp/${plugin}/download
            SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D_Plugins/${plugin}
            BINARY_DIR   ${WORKSPACE_DIR}/Temp/${plugin}/Binary
            INSTALL_DIR  ${WORKSPACE_DIR}/Temp/${plugin}/Install)
  endforeach()

  foreach(plugin ${GitHub_DREAM3D_Plugins})
    CloneRepo(PROJECT_NAME ${plugin}
            GIT_REPOSITORY https://www.github.com/dream3d/${plugin}
            TMP_DIR      ${WORKSPACE_DIR}/Temp/${plugin}/tmp
            STAMP_DIR    ${WORKSPACE_DIR}/Temp/${plugin}/stamp
            DOWNLOAD_DIR ${WORKSPACE_DIR}/Temp/${plugin}/download
            SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D_Plugins/${plugin}
            BINARY_DIR   ${WORKSPACE_DIR}/Temp/${plugin}/Binary
            INSTALL_DIR  ${WORKSPACE_DIR}/Temp/${plugin}/Install)
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
foreach(repo ${GitHub_DREAM3D_Plugins} ${DREAM3D_Base_Repos} ${GitHub_BLUEQUARTZ_Plugins} )
  list(APPEND DREAM3D_REPO_DEPENDENCIES ${repo})
  message(STATUS "Add Dependency: ${repo}" )
endforeach()


ExternalProject_Add(${extProjectName}
  DEPENDS     discount Eigen haru hdf5 ITK Qt5 qwt DREAM3D_Data ${DREAM3D_REPO_DEPENDENCIES}
  TMP_DIR      ${WORKSPACE_DIR}/Temp/DREAM3D/tmp
  STAMP_DIR    ${WORKSPACE_DIR}/Temp/DREAM3D/stamp-${BUILD_TYPE}
  DOWNLOAD_DIR ${WORKSPACE_DIR}/Temp/DREAM3D/download
  SOURCE_DIR   ${WORKSPACE_DIR}/DREAM3D
  BINARY_DIR   ${WORKSPACE_DIR}/DREAM3D-Build/${BUILD_TYPE}
  INSTALL_DIR  ${WORKSPACE_DIR}/DREAM3D-Install/

  GIT_PROGRESS 1
  GIT_REPOSITORY "https://www.github.com/bluequartzsoftware/DREAM3D"
  GIT_TAG develop

  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  #CONFIGURE_COMMAND ""
  #BUILD_COMMAND ""
  #INSTALL_COMMAND ""
  TEST_COMMAND ""

  CMAKE_ARGS
    -DDREAM3D_SDK:PATH=${DREAM3D_SDK}
    -DCMAKE_BUILD_TYPE:STRING=${BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=${WORKSPACE_DIR}/${extProjectName}-Install
    -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
    
  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)
