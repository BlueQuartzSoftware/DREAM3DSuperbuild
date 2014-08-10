
message( "External project - Doxygen" )


set(DOXYGEN_VERSION "1.8.7")
set(DOXYGEN_PREFIX "${CMAKE_BINARY_DIR}/Doxygen")

set(DOXYGEN_BINARY_DIR "${DOXYGEN_PREFIX}/Doxygen-${DOXYGEN_VERSION}-Build")

set(DOXYGEN_SOURCE_DIR "${DOXYGEN_PREFIX}/Doxygen-${DOXYGEN_VERSION}")
set(DOXYGEN_STAMP_DIR "${DOXYGEN_PREFIX}/Stamp")
set(DOXYGEN_TEMP_DIR "${DOXYGEN_PREFIX}/Tmp")
set(DOXYGEN_INSTALL_DIR "${DREAM3D_SDK_INSTALL}/Doxygen-${DOXYGEN_VERSION}")

if(WIN32)
	set(DOXYGEN_URL "http://ftp.stack.nl/pub/users/dimitri/doxygen-${DOXYGEN_VERSION}.windows.x64.bin.zip")
elseif(APPLE)
	set(DOXYGEN_URL "http://ftp.stack.nl/pub/users/dimitri/Doxygen-${DOXYGEN_VERSION}.dmg")
else()
	set(DOXYGEN_URL "http://ftp.stack.nl/pub/users/dimitri/doxygen-${DOXYGEN_VERSION}.linux.bin.tar.gz")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${DOXYGEN_PREFIX})



#-- On OS X systems we are going to simply download Doxygen and copy the .app bundle to the /Applications DIRECTORY
#-- which is where CMake expects to find it.
if(APPLE)
	set(DOXYGEN_DMG "${DOXYGEN_PREFIX}/Download/Doxygen-${DOXYGEN_VERSION}.dmg")
	if(NOT EXISTS "${DOXYGEN_PREFIX}/Download/Doxygen-${DOXYGEN_VERSION}.dmg")
		file(DOWNLOAD ${DOXYGEN_URL} "${DOXYGEN_PREFIX}/Download/Doxygen-${DOXYGEN_VERSION}.dmg" SHOW_PROGRESS)
	endif()

	configure_file(${Dream3DSdkBuild_SOURCE_DIR}/Doxygen_osx_install.sh.in
				   ${DOXYGEN_PREFIX}/Download/Install.sh @ONLY)

	execute_process(COMMAND "${DOXYGEN_PREFIX}/Download/Install.sh")

elseif(WIN32)


else()

ExternalProject_Add( Doxygen
	#--Download step--------------
	#   GIT_REPOSITORY ""
	#   GIT_TAG ""
	URL ${DOXYGEN_URL}
	URL_MD5
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



