#--------------------------------------------------------------------------------------------------
# Are we Fetching DREAM3D itself
#--------------------------------------------------------------------------------------------------
set(extProjectName "DREAM3D")
OPTION(DREAM3D_CLONE_SOURCES "Clone DREAM3D Sources" OFF)
if("${DREAM3D_CLONE_SOURCES}" STREQUAL "OFF")
  return()
endif()

message(STATUS "Cloning: ${extProjectName}: -DDREAM3D_CLONE_SOURCES=${DREAM3D_CLONE_SOURCES}" )
set(CLONE_REPOS TRUE)

if("${DREAM3D_WORKSPACE}" STREQUAL "")
  message(STATUS "DREAM3D_WORKSPACE is Blank. Attempting to set to same directory as DREAM3DSuperbuild....")
  get_filename_component(DREAM3D_WORKSPACE "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
  message(STATUS "DREAM3D_WORKSPACE: ${DREAM3D_WORKSPACE}")
endif()

if(EXISTS ${DREAM3D_WORKSPACE}/DREAM3D)
  message(STATUS "*------------------------------------------------------------")
  message(STATUS "*  The directory ${DREAM3D_WORKSPACE}/DREAM3D")
  message(STATUS "*  WILL be over written with a fresh checkout. If you have any unsaved changes")
  message(STATUS "*  or commits that need to be pushed. DO THAT BEFORE starting the")
  message(STATUS "*  build process.")
  message(STATUS "*------------------------------------------------------------")
endif()

#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
function(CloneRepo)
  set(options )
  set(oneValueArgs DEPENDS PROJECT_NAME GIT_REPOSITORY TMP_DIR STAMP_DIR DOWNLOAD_DIR SOURCE_DIR BINARY_DIR INSTALL_DIR)
  set(multiValueArgs )
  cmake_parse_arguments(Z "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  set(projectName ${Z_PROJECT_NAME})
  message(STATUS "Cloning ${projectName} in ${Z_SOURCE_DIR}" )

  set(SOURCE_DIR "${Z_DREAM3D_WORKSPACE}")

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



if("${DREAM3D_WORKSPACE}" STREQUAL "")
  message(FATAL_ERROR "DREAM3D_WORKSPACE is empty. Cloning DREAM.3D can not continue. \
    Please set the -DDREAM3D_WORKSPACE=/Path/to/Directory/of/DREAM3D to the directory where you want to clone all the DREAM3D \
    repositories. Anything in that directory may be over written.")
endif()

if(CLONE_REPOS)
  foreach(plugin ${DREAM3D_Base_Repos})
    CloneRepo(PROJECT_NAME ${plugin}
          GIT_REPOSITORY https://www.github.com/bluequartzsoftware/${plugin}
          TMP_DIR      ${DREAM3D_WORKSPACE}/Temp/${plugin}/tmp
          STAMP_DIR    ${DREAM3D_WORKSPACE}/Temp/${plugin}/stamp
          DOWNLOAD_DIR ${DREAM3D_WORKSPACE}/Temp/${plugin}/download
          SOURCE_DIR   ${DREAM3D_WORKSPACE}/${plugin}
          BINARY_DIR   ${DREAM3D_WORKSPACE}/Temp/${plugin}/Binary
          INSTALL_DIR  ${DREAM3D_WORKSPACE}/Temp/${plugin}/Install)
  endforeach()

  foreach(plugin ${GitHub_BLUEQUARTZ_Plugins})
    CloneRepo(PROJECT_NAME ${plugin}
            GIT_REPOSITORY https://www.github.com/bluequartzsoftware/${plugin}
            TMP_DIR      ${DREAM3D_WORKSPACE}/Temp/${plugin}/tmp
            STAMP_DIR    ${DREAM3D_WORKSPACE}/Temp/${plugin}/stamp
            DOWNLOAD_DIR ${DREAM3D_WORKSPACE}/Temp/${plugin}/download
            SOURCE_DIR   ${DREAM3D_WORKSPACE}/DREAM3D_Plugins/${plugin}
            BINARY_DIR   ${DREAM3D_WORKSPACE}/Temp/${plugin}/Binary
            INSTALL_DIR  ${DREAM3D_WORKSPACE}/Temp/${plugin}/Install)
  endforeach()

  foreach(plugin ${GitHub_DREAM3D_Plugins})
    CloneRepo(PROJECT_NAME ${plugin}
            GIT_REPOSITORY https://www.github.com/dream3d/${plugin}
            TMP_DIR      ${DREAM3D_WORKSPACE}/Temp/${plugin}/tmp
            STAMP_DIR    ${DREAM3D_WORKSPACE}/Temp/${plugin}/stamp
            DOWNLOAD_DIR ${DREAM3D_WORKSPACE}/Temp/${plugin}/download
            SOURCE_DIR   ${DREAM3D_WORKSPACE}/DREAM3D_Plugins/${plugin}
            BINARY_DIR   ${DREAM3D_WORKSPACE}/Temp/${plugin}/Binary
            INSTALL_DIR  ${DREAM3D_WORKSPACE}/Temp/${plugin}/Install)
  endforeach()

endif()



if(TRUE)
return()
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
  DEPENDS     discount Eigen haru hdf5 ITK Qt5 qwt ${DREAM3D_REPO_DEPENDENCIES}
  TMP_DIR      ${DREAM3D_WORKSPACE}/Temp/DREAM3D/tmp
  STAMP_DIR    ${DREAM3D_WORKSPACE}/Temp/DREAM3D/stamp-${BUILD_TYPE}
  DOWNLOAD_DIR ${DREAM3D_WORKSPACE}/Temp/DREAM3D/download
  SOURCE_DIR   ${DREAM3D_WORKSPACE}/DREAM3D
  BINARY_DIR   ${DREAM3D_WORKSPACE}/DREAM3D-Build/${BUILD_TYPE}
  INSTALL_DIR  ${DREAM3D_WORKSPACE}/DREAM3D-Install/

  GIT_PROGRESS 1
  GIT_REPOSITORY "https://www.github.com/bluequartzsoftware/DREAM3D"
  GIT_TAG develop

  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
  TEST_COMMAND ""

  CMAKE_ARGS
    -DDREAM3D_SDK:PATH=${DREAM3D_SDK}
    -DCMAKE_BUILD_TYPE:STRING=${BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=${DREAM3D_WORKSPACE}/${extProjectName}-Install
    -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
    
  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)
