
set(extProjectName "DOxygen")
message(STATUS "External Project: ${extProjectName}" )

set(DOXYGEN_VERSION "1.8.11")
set(DOXYGEN_PREFIX "${DREAM3D_SDK}/superbuild/${extProjectName}")

set(DOXYGEN_DOWNLOAD_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}")
set(DOXYGEN_BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build")
set(DOXYGEN_SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source")
set(DOXYGEN_STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp")
set(DOXYGEN_TEMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Tmp")
set(DOXYGEN_INSTALL_DIR "${DREAM3D_SDK_INSTALL}/Doxygen-${DOXYGEN_VERSION}")

if(WIN32)
	set(DOXYGEN_URL "http://ftp.stack.nl/pub/users/dimitri/doxygen-${DOXYGEN_VERSION}.windows.x64.bin.zip")
elseif(APPLE)
	set(DOXYGEN_URL "http://ftp.stack.nl/pub/users/dimitri/Doxygen-${DOXYGEN_VERSION}.dmg")
else()
	set(DOXYGEN_URL "http://ftp.stack.nl/pub/users/dimitri/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${DOXYGEN_PREFIX})

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)




#-- On OS X systems we are going to simply download Doxygen and copy the .app bundle to the /Applications DIRECTORY
#-- which is where CMake expects to find it.
if(APPLE)


  set(DOX_OSX_BASE_NAME Doxygen-${DOXYGEN_VERSION})
  set(DOX_OSX_DMG_ABS_PATH "${DREAM3D_SDK}/superbuild/${extProjectName}/Doxygen-${DOXYGEN_VERSION}.dmg")
  set(DOXYGEN_DMG ${DOX_OSX_DMG_ABS_PATH})

	configure_file(
	  "${_self_dir}/../Doxygen_osx_install.sh.in"
	  "${CMAKE_BINARY_DIR}/Doxygen_osx_install.sh"
	  @ONLY
	)

  if(NOT EXISTS "${DOX_OSX_DMG_ABS_PATH}")
    message(STATUS "===============================================================")
    message(STATUS "   Downloading ${extProjectName}-${DOXYGEN_VERSION}")
    message(STATUS "   Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${DOXYGEN_URL} "${DOX_OSX_DMG_ABS_PATH}" SHOW_PROGRESS)
  endif()

  if(NOT EXISTS "/Applications/DOxygen.app")
  	execute_process(COMMAND "${CMAKE_BINARY_DIR}/Doxygen_osx_install.sh"
  									OUTPUT_VARIABLE MOUNT_OUTPUT
                    RESULT_VARIABLE did_run
                    ERROR_VARIABLE mount_error
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
		)
  	message(STATUS "OUTPUT_VARIABLE: ${MOUNT_OUTPUT}")
  endif()

elseif(WIN32)


else()

ExternalProject_Add( Doxygen
	#--Download step--------------
	#   GIT_REPOSITORY ""
	#   GIT_TAG ""
	URL ${DOXYGEN_URL}
	# URL_MD5
	#--Update/Patch step----------
	UPDATE_COMMAND ""
  PATCH_COMMAND ""
	#--Configure step-------------
	SOURCE_DIR "${DOXYGEN_SOURCE_DIR}"
	CONFIGURE_COMMAND ""
	#--Build step-----------------
	BINARY_DIR "${DOXYGEN_BINARY_DIR}"
	BUILD_COMMAND ""
	#--Install step-----------------
	INSTALL_DIR "${DOXYGEN_INSTALL_DIR}"
	INSTALL_COMMAND ""
	DEPENDS ${DOXYGEN_DEPENDENCIES}
)

endif()

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "set(DOXYGEN_INSTALL_DIR \"${DOXYGEN_INSTALL_DIR}\")\n")



